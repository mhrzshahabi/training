package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TeachingHistoryDTO;
import com.nicico.training.iservice.ITeachingHistoryService;
import com.nicico.training.model.TeachingHistory;
import com.nicico.training.repository.TeachingHistoryDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TeachingHistoryService implements ITeachingHistoryService {

    private final ModelMapper modelMapper;
    private final TeachingHistoryDAO teachingHistoryDAO;

    @Transactional(readOnly = true)
    @Override
    public TeachingHistoryDTO.Info get(Long id) {
        final Optional<TeachingHistory> optionalTeachingHistory = teachingHistoryDAO.findById(id);
        final TeachingHistory teachingHistory = optionalTeachingHistory.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(teachingHistory, TeachingHistoryDTO.Info.class);
    }

//    @Transactional(readOnly = true)
//    @Override
//    public List<TeachingHistoryDTO.Info> list() {
//        List<TeachingHistory> teachingHistoryList = teachingHistoryDAO.findAll();
//        return modelMapper.map(teachingHistoryList, new TypeToken<List<TeachingHistoryDTO.Info>>() {
//        }.getType());
//    }

//    @Transactional
//    @Override
//    public TeachingHistoryDTO.Info create(TeachingHistoryDTO.Create request) {
//        try {
//            return save(modelMapper.map(request, TeachingHistory.class));
//        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
//            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
//        }
//    }

    @Transactional
    @Override
    public TeachingHistoryDTO.Info update(Long id, TeachingHistoryDTO.Update request) {
        final Optional<TeachingHistory> optionalTeachingHistory = teachingHistoryDAO.findById(id);
        final TeachingHistory teachingHistory = optionalTeachingHistory.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        teachingHistory.getCategories().clear();
        teachingHistory.getSubCategories().clear();
        TeachingHistory updating = new TeachingHistory();
        modelMapper.map(teachingHistory, updating);
        modelMapper.map(request, updating);
        try {
            return save(updating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

//    @Transactional
//    @Override
//    public void delete(Long id) {
//        try {
//            teachingHistoryDAO.deleteById(id);
//        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
//            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
//        }
//    }

//    @Transactional
//    @Override
//    public void delete(TeachingHistoryDTO.Delete request) {
//        final List<TeachingHistory> teachingHistoryList = teachingHistoryDAO.findAllById(request.getIds());
//        try {
//            teachingHistoryDAO.deleteAll(teachingHistoryList);
//        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
//            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
//        }
//    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeachingHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId) {
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
        return SearchUtil.search(teachingHistoryDAO, request, teachingHistory -> modelMapper.map(teachingHistory, TeachingHistoryDTO.Info.class));
    }

    private TeachingHistoryDTO.Info save(TeachingHistory teachingHistory) {
        final TeachingHistory saved = teachingHistoryDAO.saveAndFlush(teachingHistory);
        return modelMapper.map(saved, TeachingHistoryDTO.Info.class);
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }
}
