package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.IEmploymentHistoryService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.EmploymentHistory;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.EmploymentHistoryDAO;
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
public class EmploymentHistoryService implements IEmploymentHistoryService {

    private final ModelMapper modelMapper;
    private final EmploymentHistoryDAO employmentHistoryDAO;
    private final ITeacherService teacherService;

    @Transactional(readOnly = true)
    @Override
    public EmploymentHistoryDTO.Info get(Long id) {
        return modelMapper.map(getEmploymentHistory(id), EmploymentHistoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public EmploymentHistory getEmploymentHistory(Long id) {
        final Optional<EmploymentHistory> optionalEmploymentHistory = employmentHistoryDAO.findById(id);
        return optionalEmploymentHistory.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional
    @Override
    public void deleteEmploymentHistory(Long teacherId, Long employmentHistoryId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        final EmploymentHistoryDTO.Info employmentHistory = get(employmentHistoryId);
        try {
            teacher.getEmploymentHistories().remove(modelMapper.map(employmentHistory, EmploymentHistory.class));
            employmentHistory.setTeacherId(null);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void addEmploymentHistory(EmploymentHistoryDTO.Create request, Long teacherId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        EmploymentHistory employmentHistory = new EmploymentHistory();
        modelMapper.map(request, employmentHistory);
        try {
            teacher.getEmploymentHistories().add(employmentHistory);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public EmploymentHistoryDTO.Info update(Long id, EmploymentHistoryDTO.Update request) {
        final EmploymentHistory employmentHistory = getEmploymentHistory(id);
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

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<EmploymentHistoryDTO.Grid> deepSearchGrid(SearchDTO.SearchRq request, Long teacherId) {

        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria("teacherId", teacherId, EOperator.equals, null);

        List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
        if (request.getCriteria() != null) {
            if (request.getCriteria().getCriteria() != null)
                request.getCriteria().getCriteria().add(criteriaRq);
            else {
                criteriaRqList.add(criteriaRq);
                request.getCriteria().setCriteria(criteriaRqList);
            }
        } else
            request.setCriteria(criteriaRq);


        SearchDTO.SearchRs<EmploymentHistoryDTO.Grid> searchRs = SearchUtil.search(employmentHistoryDAO, request, needAssessment -> modelMapper.map(needAssessment,
                EmploymentHistoryDTO.Grid.class));

        return searchRs;
    }


}
