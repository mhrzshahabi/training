package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.iservice.IEmploymentHistoryService;
import com.nicico.training.model.EmploymentHistory;
import com.nicico.training.repository.EmploymentHistoryDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class EmploymentHistoryService implements IEmploymentHistoryService {

    private final ModelMapper modelMapper;
    private final EmploymentHistoryDAO employmentHistoryDAO;

    @Transactional(readOnly = true)
    @Override
    public EmploymentHistoryDTO.Info get(Long id) {
        final Optional<EmploymentHistory> optionalEmploymentHistory = employmentHistoryDAO.findById(id);
        final EmploymentHistory employmentHistory = optionalEmploymentHistory.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(employmentHistory, EmploymentHistoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<EmploymentHistoryDTO.Info> list() {
        List<EmploymentHistory> employmentHistoryList = employmentHistoryDAO.findAll();
        return modelMapper.map(employmentHistoryList, new TypeToken<List<EmploymentHistoryDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public EmploymentHistoryDTO.Info create(EmploymentHistoryDTO.Create request) {
        try {
            return save(modelMapper.map(request, EmploymentHistory.class));
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public EmploymentHistoryDTO.Info update(Long id, EmploymentHistoryDTO.Update request) {
        final Optional<EmploymentHistory> optionalEmploymentHistory = employmentHistoryDAO.findById(id);
        final EmploymentHistory employmentHistory = optionalEmploymentHistory.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        employmentHistory.getCategories().clear();
        employmentHistory.getSubCategories().clear();
        EmploymentHistory updating = new EmploymentHistory();
        modelMapper.map(employmentHistory, updating);
        modelMapper.map(request, updating);
        try {
            return save(updating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            employmentHistoryDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void delete(EmploymentHistoryDTO.Delete request) {
        final List<EmploymentHistory> employmentHistoryList = employmentHistoryDAO.findAllById(request.getIds());
        try {
            employmentHistoryDAO.deleteAll(employmentHistoryList);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EmploymentHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId) {
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
        return SearchUtil.search(employmentHistoryDAO, request, employmentHistory -> modelMapper.map(employmentHistory, EmploymentHistoryDTO.Info.class));
    }

    private EmploymentHistoryDTO.Info save(EmploymentHistory employmentHistory) {
        final EmploymentHistory saved = employmentHistoryDAO.saveAndFlush(employmentHistory);
        return modelMapper.map(saved, EmploymentHistoryDTO.Info.class);
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
