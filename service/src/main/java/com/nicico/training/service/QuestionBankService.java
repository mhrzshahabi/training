package com.nicico.training.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IQuestionBankService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class QuestionBankService implements IQuestionBankService {

    private final ModelMapper modelMapper;
    private final QuestionBankDAO questionBankDAO;
    private final CategoryDAO categoryDAO;
    private final SubcategoryDAO subcategoryDAO;
    private final EnumsConverter.EQuestionLevelConverter eQuestionLevelConverter = new EnumsConverter.EQuestionLevelConverter();
    private final ICategoryService categoryService;
    private final ISubcategoryService subcategoryService;
    private  final TeacherDAO teacherDAO;
    private final ObjectMapper objectMapper;



    @Transactional(readOnly = true)
    @Override
    public boolean isExist(Long id) {
        QuestionBank tmp = getById(id);
        return tmp == null ? false : tmp.getQuestionBankTestQuestion().size() > 0;
    }

    @Transactional(readOnly = true)
    @Override
    public QuestionBank getById(Long id) {
        return questionBankDAO.findById(id).orElse(null);
    }


    @Transactional(readOnly = true)
    @Override
    public QuestionBankDTO.FullInfo get(Long id) {

        final Optional<QuestionBank> cById = questionBankDAO.findById(id);
        final QuestionBank model = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.QuestionBankNotFound));

        QuestionBankDTO.FullInfo map = modelMapper.map(model, QuestionBankDTO.FullInfo.class);
        map.setQuestionLevelId(model.getEQuestionLevel().getId());
        return map;
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<QuestionBankDTO.Info> search(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException {

        return BaseService.<QuestionBank, QuestionBankDTO.Info, QuestionBankDAO>optimizedSearch(questionBankDAO, p -> modelMapper.map(p, QuestionBankDTO.Info.class), request);
    }

    @Override
    public List<QuestionBank> searchModels(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException {
     SearchDTO.SearchRs<QuestionBank>  searchRs=  BaseService.optimizedSearch(questionBankDAO,p->modelMapper.map(p,QuestionBank.class),request);
     List<QuestionBank> list=searchRs.getList();
     return list;
    }

    @Override
    public SearchDTO.SearchRs<QuestionBankDTO.IdClass> searchId(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException {
        return BaseService.<QuestionBank, QuestionBankDTO.IdClass, QuestionBankDAO>optimizedSearch(questionBankDAO, p -> modelMapper.map(p, QuestionBankDTO.IdClass.class), request);
    }



    @Transactional
    @Override
    public QuestionBankDTO.Info create(QuestionBankDTO.Create request) {
        final QuestionBank model = modelMapper.map(request, QuestionBank.class);
        Integer codeId = questionBankDAO.getLastCodeId();

        if (codeId != null)
            model.setCodeId(codeId + 1);
        else
            model.setCodeId(1);
        model.setCode(model.getCodeId().toString());
        model.setEQuestionLevel(eQuestionLevelConverter.convertToEntityAttribute(request.getQuestionLevelId()));
        model.setEQuestionLevelId(request.getQuestionLevelId());
        if (request.getQuestionDesigner() != null) {
            model.setQuestionDesigner(request.getQuestionDesigner());
        } else {
            model.setQuestionDesigner(SecurityUtil.getUsername());
        }
        model.setGroupQuestions(getListOfGroupQuestions(request.getGroupQuestions()));

        return save(model);
    }


    @Transactional
    @Override
    public QuestionBankDTO.Info update(Long id, QuestionBankDTO.Update request) {
        final Optional<QuestionBank> cById = questionBankDAO.findById(id);
        final QuestionBank model = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.QuestionBankNotFound));
        if (request.getCode()==null)
            request.setCode(cById.get().getCode());
        model.setCategoryId(request.getCategoryId());
        model.setSubCategoryId(request.getSubCategoryId());
        model.setEQuestionLevel(eQuestionLevelConverter.convertToEntityAttribute(request.getQuestionLevelId()));
        model.setEQuestionLevelId(request.getQuestionLevelId());
        model.setProposedPointValue(request.getProposedPointValue());
        model.setQuestionDesigner(request.getQuestionDesigner());

        QuestionBank updating = new QuestionBank();
        modelMapper.map(model, updating);
        modelMapper.map(request, updating);

        updating.setId(id);
        updating.setQuestionTargets(request.getQuestionTargets());
        updating.setGroupQuestions(getListOfGroupQuestions(request.getGroupQuestions()));
        QuestionBank save = questionBankDAO.save(updating);

        return modelMapper.map(save, QuestionBankDTO.Info.class);
    }

    @Override
    public List<QuestionBank> getListOfGroupQuestions(List<Long> groupQuestions) {
        if (groupQuestions!=null)
        {
            List<QuestionBank> questionBanks=new ArrayList<>();
            for (Long questionId : groupQuestions){
                Optional<QuestionBank> questionBank=   questionBankDAO.findById(questionId);
                questionBank.ifPresent(questionBanks::add);
            }
            return questionBanks;
        }else
            return null;
    }

    @Transactional
    @Override
    public void delete(Long id) {
        questionBankDAO.deleteById(id);
    }


    private QuestionBankDTO.Info save(QuestionBank tclass) {
        final QuestionBank saved = questionBankDAO.saveAndFlush(tclass);
        return modelMapper.map(saved, QuestionBankDTO.Info.class);
    }

    public Integer getMaxId() {
        Integer maxId = questionBankDAO.getLastCodeId();
        if (maxId != null)
            return maxId + 1;
        return 1;
    }




    @Transactional
    public Page<QuestionBank> getQuestionBankByTeacherId(Long teacherId, Integer page, Integer size) {
//        return questionBankDAO.findByTeacherId(teacherId);
        Pageable pageable = PageRequest.of(page, size, Sort.by(
                Sort.Order.desc("id")
        ));
        return questionBankDAO.findAllByTeacherId(teacherId,pageable);
    }

    @Transactional
    @Override
    public Page<QuestionBank> findAll(Integer page, Integer size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(
                Sort.Order.desc("id")
        ));
        return questionBankDAO.findAll(pageable);
    }



    @Override
    public Page<QuestionBank> getQuestionsByCategoryAndSubCategory(Teacher teacher,Integer page,Integer size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by(
                Sort.Order.asc("id")
        ));
        List<Long> categories=categoryService.findCategoryByTeacher(teacher.getId());
        List<Long> subCategories=subcategoryService.findSubCategoriesByTeacher(teacher.getId());


        Page<QuestionBank> questionBankList=  questionBankDAO.findAllWithCategoryAndSubCategory(categories,subCategories,pageable);







        return questionBankList;
    }
    @Override
    public List<QuestionBank> getQuestionListByCategoryAndSubCategory(Teacher teacher) {
        List<Long> categories=categoryService.findCategoryByTeacher(teacher.getId());
        List<Long> subCategories=subcategoryService.findSubCategoriesByTeacher(teacher.getId());
        return questionBankDAO.findAllWithCategoryAndSubList(categories,subCategories);
    }

    @Override
    @Transactional(readOnly = true)
    public PageQuestionDto getPageQuestionByTeacher(Integer page, Integer size, ElsSearchDTO elsSearchDTO,Long teacherId) throws NoSuchFieldException, IllegalAccessException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.SearchRq totalRequest = new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        list.add(makeNewCriteria("teacherId",teacherId,EOperator.equals,null));

        if (elsSearchDTO.getElsSearchList() != null && elsSearchDTO.getElsSearchList().size() > 0) {
            elsSearchDTO.getElsSearchList().stream().forEach(elsSearch -> {
                if (elsSearch.getValue() != null) {
                    list.add(makeNewCriteria(elsSearch.getFieldName(), elsSearch.getValue().toString(), EOperator.iContains, null));
                }
            });
        }

        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
        request.setCriteria(criteriaRq);
        totalRequest.setCriteria(criteriaRq);


        request.setStartIndex(size*page)
                .setSortBy("-id")
                .setCount(size);



        totalRequest.setStartIndex(0)
                .setCount(1000);
        List<QuestionBank> questionBanks=searchModels(request);
        Long totalModelsCount = (long) searchModels(totalRequest).size();


        PageQuestionDto pageQuestionDto=new PageQuestionDto();
        pageQuestionDto.setPageQuestion(questionBanks);
        pageQuestionDto.setTotalSpecCount(totalModelsCount);
        return pageQuestionDto;
    }

    @Override
    @Transactional(readOnly = true)
    public PageQuestionDto getPageQuestionByCategoryAndSub(Integer page, Integer size, ElsSearchDTO elsSearchDTO,Long teacherId) throws NoSuchFieldException, IllegalAccessException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.SearchRq TotallRequest = new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        List<SearchDTO.CriteriaRq> secondList = new ArrayList<>();
        List<SearchDTO.CriteriaRq> filterList = new ArrayList<>();
        List<Long> categories=categoryService.findCategoryByTeacher(teacherId);
        List<Long> subCategories=subcategoryService.findSubCategoriesByTeacher(teacherId);
        list.add(makeNewCriteria("categoryId", null, EOperator.isNull, null));
        list.add(makeNewCriteria("subCategoryId", null, EOperator.isNull, null));
        if(categories.size()>0)
            secondList.add(makeNewCriteria("categoryId",categories,EOperator.inSet,null));
        if(subCategories.size()>0)
            secondList.add(makeNewCriteria("subCategoryId",subCategories,EOperator.inSet,null));


        if (elsSearchDTO.getElsSearchList() != null && elsSearchDTO.getElsSearchList().size() > 0) {
            elsSearchDTO.getElsSearchList().stream().forEach(elsSearch -> {
                if (elsSearch.getValue() != null) {
                   filterList.add(makeNewCriteria(elsSearch.getFieldName(), elsSearch.getValue().toString(), EOperator.iContains, null));
                }
            });
        }
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
        SearchDTO.CriteriaRq criteriaRqFilter = makeNewCriteria(null, null, EOperator.and, filterList);

        request.setCriteria(criteriaRq);
        TotallRequest.setCriteria(criteriaRq);



        SearchDTO.CriteriaRq addCriteria = makeNewCriteria(null, null, EOperator.or, secondList);



        request.setStartIndex(size*page)
                .setSortBy("-id")
                .setCount(size);
        if(secondList.size()>0) {
            SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
            criteria.getCriteria().add(addCriteria);
            if (request.getCriteria() != null)
                criteria.getCriteria().add(request.getCriteria());

            request.setCriteria(criteria);
            TotallRequest.setCriteria(criteria);
        }
        if(filterList.size()>0){
            SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            criteria.getCriteria().add(criteriaRqFilter);
            if (TotallRequest.getCriteria() != null)
                criteria.getCriteria().add(TotallRequest.getCriteria());

            request.setCriteria(criteria);
            TotallRequest.setCriteria(criteria);
        }


        TotallRequest.setStartIndex(0)
                .setCount(1000);

        List<QuestionBank> questionBanks=searchModels(request);
        Long totalModelsCount = (long) searchModels(TotallRequest).size();


        PageQuestionDto pageQuestionDto=new PageQuestionDto();
        pageQuestionDto.setPageQuestion(questionBanks);
        pageQuestionDto.setTotalSpecCount(totalModelsCount);
        return pageQuestionDto;

    }

    @Override
    public List<QuestionBank> findAllByCreateBy(String createBy) {
        return questionBankDAO.findAllByCreatedBy(createBy);
    }

}
