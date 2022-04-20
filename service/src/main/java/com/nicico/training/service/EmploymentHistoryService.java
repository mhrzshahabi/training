package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.iservice.IEmploymentHistoryService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.mapper.employmentHistory.EmploymentHistoryBeanMapper;
import com.nicico.training.model.EmploymentHistory;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.EmploymentHistoryDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.employmentHistory.ElsEmploymentHistoryFindAllRespDto;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class EmploymentHistoryService implements IEmploymentHistoryService {

    private final ModelMapper modelMapper;
    private final ITeacherService teacherService;
    private final EmploymentHistoryDAO employmentHistoryDAO;
    private final EmploymentHistoryBeanMapper employmentHistoryBeanMapper;

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
    public EmploymentHistoryDTO.Info addEmploymentHistory(EmploymentHistoryDTO.Create request, Long teacherId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        EmploymentHistory employmentHistory = modelMapper.map(request, EmploymentHistory.class);
        EmploymentHistoryDTO.Info info = save(employmentHistory);
        try {
            teacher.getEmploymentHistories().add(employmentHistory);
            return info;
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
        request.setDistinct(true);
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                for (SearchDTO.CriteriaRq o : request.getCriteria().getCriteria()) {
                    if(o.getFieldName().equalsIgnoreCase("categories"))
                        o.setValue(Long.parseLong(o.getValue().get(0)+""));
                    if(o.getFieldName().equalsIgnoreCase("subCategories"))
                        o.setValue(Long.parseLong(o.getValue().get(0)+""));
                }
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }

        for (SearchDTO.CriteriaRq criteriaRq : request.getCriteria().getCriteria()) {
            if (criteriaRq.getFieldName() != null) {
                if (criteriaRq.getFieldName().equalsIgnoreCase("subCategoriesIds"))
                    criteriaRq.setFieldName("subCategories");
                if (criteriaRq.getFieldName().equalsIgnoreCase("categoriesIds"))
                    criteriaRq.setFieldName("categories");
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianStartDate"))
                    criteriaRq.setFieldName("startDate");
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianEndDate"))
                    criteriaRq.setFieldName("endDate");
            }
        }
        return SearchUtil.search(employmentHistoryDAO, request, employmentHistory -> modelMapper.map(employmentHistory, EmploymentHistoryDTO.Info.class));
    }

    @Override
    public List<ElsEmploymentHistoryFindAllRespDto> findEmploymentHistoriesByNationalCode(String nationalCode) {
        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
        List<EmploymentHistory> employmentHistoryList = employmentHistoryDAO.findAllByTeacherId(teacherId);
        return employmentHistoryBeanMapper.empHistoryListToElsFindRespList(employmentHistoryList).stream().sorted(Comparator.comparing(ElsEmploymentHistoryFindAllRespDto::getId).reversed()).collect(Collectors.toList());
    }

    @Override
    public List<ElsEmploymentHistoryFindAllRespDto.Resume> findEmploymentHistoryResumeListByNationalCode(String nationalCode) {
        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
        List<EmploymentHistory> employmentHistoryList = employmentHistoryDAO.findAllByTeacherId(teacherId);
        return employmentHistoryBeanMapper.empHistoryResumeListToElsFindRespList(employmentHistoryList.stream().sorted(Comparator.comparing(EmploymentHistory::getId)).collect(Collectors.toList()));
    }

    private EmploymentHistoryDTO.Info save(EmploymentHistory employmentHistory) {
        final EmploymentHistory saved = employmentHistoryDAO.saveAndFlush(employmentHistory);
        return modelMapper.map(saved, EmploymentHistoryDTO.Info.class);
    }

}
