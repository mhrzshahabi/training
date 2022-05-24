package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TeachingHistoryDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.iservice.ITeachingHistoryService;
import com.nicico.training.mapper.teachingHistory.TeachingHistoryBeanMapper;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeachingHistory;
import com.nicico.training.repository.TeachingHistoryDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.teachingHistory.ElsTeachingHistoryFindAllRespDto;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TeachingHistoryService implements ITeachingHistoryService {

    private final ModelMapper modelMapper;
    private final ITeacherService teacherService;
    private final TeachingHistoryDAO teachingHistoryDAO;
    private final TeachingHistoryBeanMapper teachingHistoryBeanMapper;

    @Transactional(readOnly = true)
    @Override
    public TeachingHistoryDTO.Info get(Long id) {
        return modelMapper.map(getTeachingHistory(id), TeachingHistoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public TeachingHistory getTeachingHistory(Long id) {
        final Optional<TeachingHistory> optionalTeachingHistory = teachingHistoryDAO.findById(id);
        return optionalTeachingHistory.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional
    @Override
    public void deleteTeachingHistory(Long teacherId, Long teachingHistoryId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        final TeachingHistoryDTO.Info teachingHistory = get(teachingHistoryId);
        try {
            teacher.getTeachingHistories().remove(modelMapper.map(teachingHistory, TeachingHistory.class));
            teachingHistory.setTeacherId(null);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public TeachingHistoryDTO.Info addTeachingHistory(TeachingHistoryDTO.Create request, Long teacherId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        TeachingHistory teachingHistory = modelMapper.map(request, TeachingHistory.class);
        TeachingHistoryDTO.Info info = save(teachingHistory);
        try {
            teacher.getTeachingHistories().add(teachingHistory);
            return info;
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public TeachingHistoryDTO.Info update(Long id, TeachingHistoryDTO.Update request) {
        final TeachingHistory teachingHistory = getTeachingHistory(id);
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

    @Override
    public List<ElsTeachingHistoryFindAllRespDto> findTeachingHistoriesByNationalCode(String nationalCode) {
        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
        List<TeachingHistory> teachingHistoryList = teachingHistoryDAO.findAllByTeacherId(teacherId);
        return teachingHistoryBeanMapper.teachHistoryListToElsFindRespList(teachingHistoryList).stream().sorted(Comparator.comparing(ElsTeachingHistoryFindAllRespDto::getId).reversed()).collect(Collectors.toList());
    }

    @Override
    public List<ElsTeachingHistoryFindAllRespDto.TeachingHistoryResume> findTeachingHistoriesResumeByNationalCode(String nationalCode) {
        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
        List<TeachingHistory> teachingHistoryList = teachingHistoryDAO.findAllByTeacherId(teacherId);
        return teachingHistoryBeanMapper.teachHistoryListToElsResumeRespList(teachingHistoryList.stream().sorted(Comparator.comparing(TeachingHistory::getDuration).reversed()).collect(Collectors.toList()));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeachingHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId) {
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
        for (SearchDTO.CriteriaRq  criteriaRq : request.getCriteria().getCriteria()) {
            if(criteriaRq.getFieldName() != null) {
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
        return SearchUtil.search(teachingHistoryDAO, request, teachingHistory -> modelMapper.map(teachingHistory, TeachingHistoryDTO.Info.class));
    }

    private TeachingHistoryDTO.Info save(TeachingHistory teachingHistory) {
        final TeachingHistory saved = teachingHistoryDAO.saveAndFlush(teachingHistory);
        return modelMapper.map(saved, TeachingHistoryDTO.Info.class);
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        return BaseService.makeNewCriteria(fieldName, value, operator, criteriaRqList);
    }
}
