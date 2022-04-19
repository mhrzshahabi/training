package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ForeignLangKnowledgeDTO;
import com.nicico.training.iservice.IForeignLangKnowledgeService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.mapper.ForeignLanguage.ForeignLanguageBeenMapper;
import com.nicico.training.model.ForeignLangKnowledge;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.ForeignLangKnowledgeDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ForeignLangKnowledgeService implements IForeignLangKnowledgeService {

    private final ModelMapper modelMapper;
    private final ForeignLangKnowledgeDAO foreignLangKnowledgeDAO;
    private final ITeacherService teacherService;
    private final ForeignLanguageBeenMapper foreignLanguageBeenMapper;

    @Transactional(readOnly = true)
    @Override
    public ForeignLangKnowledgeDTO.Info get(Long id) {
        return modelMapper.map(getForeignLangKnowledge(id), ForeignLangKnowledgeDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public ForeignLangKnowledge getForeignLangKnowledge(Long id) {
        final Optional<ForeignLangKnowledge> optionalForeignLangKnowledge = foreignLangKnowledgeDAO.findById(id);
        return optionalForeignLangKnowledge.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }


    @Transactional
    @Override
    public ForeignLangKnowledgeDTO.Info update(Long id, ForeignLangKnowledgeDTO.Update request) {
        final ForeignLangKnowledge foreignLangKnowledge = getForeignLangKnowledge(id);
        ForeignLangKnowledge updating = new ForeignLangKnowledge();
        modelMapper.map(foreignLangKnowledge, updating);
        modelMapper.map(request, updating);
        try {
            return save(updating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ForeignLangKnowledgeDTO.Info> search(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        return SearchUtil.search(foreignLangKnowledgeDAO, request, foreignLangKnowledge -> modelMapper.map(foreignLangKnowledge, ForeignLangKnowledgeDTO.Info.class));
    }

    private ForeignLangKnowledgeDTO.Info save(ForeignLangKnowledge foreignLangKnowledge) {
        final ForeignLangKnowledge saved = foreignLangKnowledgeDAO.saveAndFlush(foreignLangKnowledge);
        return modelMapper.map(saved, ForeignLangKnowledgeDTO.Info.class);
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

    @Transactional
    @Override
    public void addForeignLangKnowledge(ForeignLangKnowledgeDTO.Create request, Long teacherId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        Set<ForeignLangKnowledge> foreignLangKnowledgeSet = teacher.getForeignLangKnowledges();
        for (ForeignLangKnowledge foreignLangKnowledge : foreignLangKnowledgeSet) {
            if (foreignLangKnowledge.getLangName().equals(request.getLangName()))
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        ForeignLangKnowledge foreignLangKnowledge = new ForeignLangKnowledge();
        modelMapper.map(request, foreignLangKnowledge);
        try {
            teacher.getForeignLangKnowledges().add(foreignLangKnowledge);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void deleteForeignLangKnowledge(Long teacherId, Long foreignLangKnowledgeId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        final ForeignLangKnowledgeDTO.Info foreignLangKnowledge = get(foreignLangKnowledgeId);
        try {
            teacher.getForeignLangKnowledges().remove(modelMapper.map(foreignLangKnowledge, ForeignLangKnowledge.class));
            foreignLangKnowledge.setTeacherId(null);
            foreignLangKnowledgeDAO.delete(modelMapper.map(foreignLangKnowledge, ForeignLangKnowledge.class));
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }
    @Transactional
    @Override
    public List<ForeignLangKnowledgeDTO.Resume> getListByTeacherId(String nationalCode) {
        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
      List<ForeignLangKnowledge>  foreignLangKnowledgeList= foreignLangKnowledgeDAO.findAllByTeacherId(teacherId);
      List<ForeignLangKnowledgeDTO.Resume> dtos=foreignLanguageBeenMapper.toDTOs(foreignLangKnowledgeList.stream().sorted(Comparator.comparing(ForeignLangKnowledge::getId)).collect(Collectors.toList()));
       return dtos;
    }


}
