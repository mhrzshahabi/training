package com.nicico.training.service;
/* com.nicico.training.service
@Author:Mehran Golrokhi
*/


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IQuestionBankService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;


@Service
@RequiredArgsConstructor
public class QuestionBankService implements IQuestionBankService {

    private final ModelMapper modelMapper;
    private final QuestionBankDAO questionBankDAO;
    private final CategoryDAO categoryDAO;
    private final SubcategoryDAO subcategoryDAO;
    private final EnumsConverter.EQuestionLevelConverter eQuestionLevelConverter = new EnumsConverter.EQuestionLevelConverter();


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
        return save(model);
    }


    @Transactional
    @Override
    public QuestionBankDTO.Info update(Long id, QuestionBankDTO.Update request) {
        final Optional<QuestionBank> cById = questionBankDAO.findById(id);
        final QuestionBank model = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.QuestionBankNotFound));

        model.setCategoryId(request.getCategoryId());
        model.setSubCategoryId(request.getSubCategoryId());
        model.setEQuestionLevel(eQuestionLevelConverter.convertToEntityAttribute(request.getQuestionLevelId()));

        QuestionBank updating = new QuestionBank();
        modelMapper.map(model, updating);
        modelMapper.map(request, updating);


        QuestionBank save = questionBankDAO.save(updating);

        return modelMapper.map(save, QuestionBankDTO.Info.class);
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
    public List<QuestionBank> getQuestionBankByTeacherId(Long teacherId) {
        return questionBankDAO.findByTeacherId(teacherId);
    }

}
