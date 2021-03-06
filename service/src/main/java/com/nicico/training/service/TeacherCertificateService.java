package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.iservice.ITeacherCertificationService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeacherCertification;
import com.nicico.training.repository.TeacherCertificationDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TeacherCertificateService implements ITeacherCertificationService {

    private final ModelMapper modelMapper;
    private final TeacherCertificationDAO teacherCertificationDAO;
    private final ITeacherService teacherService;

    @Transactional(readOnly = true)
    @Override
    public TeacherCertificationDTO.Info get(Long id) {
        return modelMapper.map(getTeacherCertification(id), TeacherCertificationDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public TeacherCertification getTeacherCertification(Long id) {
        final Optional<TeacherCertification> optionalTeacherCertification = teacherCertificationDAO.findById(id);
        return optionalTeacherCertification.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional
    @Override
    public void deleteTeacherCertification(Long teacherId, Long teacherCertificationId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        final TeacherCertificationDTO.Info teacherCertification = get(teacherCertificationId);
        try {
            teacher.getTeacherCertifications().remove(modelMapper.map(teacherCertification, TeacherCertification.class));
            teacherCertification.setTeacherId(null);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void addTeacherCertification(TeacherCertificationDTO.Create request, Long teacherId,HttpServletResponse response) {
        final Teacher teacher = teacherService.getTeacher(teacherId);

        if (!teacherCertificationDAO.existsByCourseTitleAndTeacherId(request.getCourseTitle(),request.getTeacherId())){
            TeacherCertification teacherCertification = new TeacherCertification();
            modelMapper.map(request, teacherCertification);
            try {
                teacher.getTeacherCertifications().add(teacherCertification);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
            }
        }
        else {
            try {
                response.sendError(405,null);
            } catch (IOException e){
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }
    }

    @Transactional
    @Override
    public TeacherCertificationDTO.Info update(Long id, TeacherCertificationDTO.Update request, HttpServletResponse response) {
        final TeacherCertification teacherCertification = getTeacherCertification(id);

        if (!teacherCertificationDAO.existsByCourseTitleAndTeacherIdAndIdIsNot(request.getCourseTitle(),request.getTeacherId(),id)) {
            teacherCertification.getCategories().clear();
            teacherCertification.getSubCategories().clear();
            TeacherCertification updating = new TeacherCertification();
            modelMapper.map(teacherCertification, updating);
            modelMapper.map(request, updating);
            try {
                return save(updating);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
            }
        }
        else {
            try {
                response.sendError(405, null);
                return null;
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherCertificationDTO.Info> search(SearchDTO.SearchRq request, Long teacherId) {
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
        return SearchUtil.search(teacherCertificationDAO, request, teacherCertification -> modelMapper.map(teacherCertification, TeacherCertificationDTO.Info.class));
    }

    private TeacherCertificationDTO.Info save(TeacherCertification teacherCertification) {
        final TeacherCertification saved = teacherCertificationDAO.saveAndFlush(teacherCertification);
        return modelMapper.map(saved, TeacherCertificationDTO.Info.class);
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
