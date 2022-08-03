package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.iservice.ITeacherExperienceInfoService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeacherCertification;
import com.nicico.training.model.TeacherExperienceInfo;
import com.nicico.training.model.enums.TeacherRank;
import com.nicico.training.repository.ParameterValueDAO;
import com.nicico.training.repository.TeacherExperienceInfoDAO;
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
public class TeacherExperienceInfoService  implements ITeacherExperienceInfoService {
    private final TeacherExperienceInfoDAO teacherExperienceInfoDAO;
    private final ModelMapper modelMapper;
    private final ITeacherService teacherService;

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherExperienceInfoDTO> search(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        request.setSortBy("id");
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        request.setDistinct(true);
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

        return SearchUtil.search(teacherExperienceInfoDAO, request, teacherExInfo -> modelMapper.map(teacherExInfo, TeacherExperienceInfoDTO.class));

    }
    @Transactional
    @Override
    public void addTeacherExperienceInfo(TeacherExperienceInfoDTO teacherExperienceInfoDTO, HttpServletResponse response) {
        final Teacher teacher = teacherService.getTeacher(teacherExperienceInfoDTO.getTeacherId());

        if (!teacherExperienceInfoDAO.existsByTeacherRankIdAndTeacherIdAndSalaryBaseAndTeachingExperience(teacherExperienceInfoDTO.getTeacherRank().ordinal(),teacher.getId(),teacherExperienceInfoDTO.getSalaryBase(),teacherExperienceInfoDTO.getTeachingExperience())){
            TeacherExperienceInfo teacherExperienceInfo = new TeacherExperienceInfo();
            teacherExperienceInfo.setTeacherId(teacherExperienceInfoDTO.getTeacherId());
            teacherExperienceInfo.setTeachingExperience(teacherExperienceInfoDTO.getTeachingExperience());

            teacherExperienceInfo.setTeacherRankId((teacherExperienceInfoDTO.getTeacherRank()).ordinal());

            teacherExperienceInfo.setSalaryBase(teacherExperienceInfoDTO.getSalaryBase());
            try {
                teacher.getTeacherExperienceInfos().add(teacherExperienceInfo);
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

    @Override
    public TeacherExperienceInfoDTO update(Long id, TeacherExperienceInfoDTO update, HttpServletResponse response) {
        final TeacherExperienceInfo teacherExperienceInfo = getTeacherExperienceInfo(id);

        if (!teacherExperienceInfoDAO.existsByTeacherRankIdAndTeacherIdAndSalaryBaseAndTeachingExperience(update.getTeacherRank().ordinal(),teacherExperienceInfo.getTeacherId(),update.getSalaryBase(),update.getTeachingExperience())) {


            teacherExperienceInfo.setTeachingExperience(update.getTeachingExperience());
            teacherExperienceInfo.setTeacherRankId(update.getTeacherRank().ordinal());

            teacherExperienceInfo.setSalaryBase(update.getSalaryBase());
            try {
                return save(teacherExperienceInfo);
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
    public TeacherExperienceInfoDTO get(Long id) {
        return modelMapper.map(getTeacherExperienceInfo(id), TeacherExperienceInfoDTO.class);
    }


    @Override
    public void deleteTeacherExperienceInfo(Long teacherId, Long id) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
            TeacherExperienceInfo teacherExperienceInfo=getTeacherExperienceInfo(id);
        try {
           teacherExperienceInfoDAO.delete(teacherExperienceInfo);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    private TeacherExperienceInfoDTO save(TeacherExperienceInfo teacherExperienceInfo) {
        final TeacherExperienceInfo saved = teacherExperienceInfoDAO.saveAndFlush(teacherExperienceInfo);
        return modelMapper.map(saved, TeacherExperienceInfoDTO.class);
    }

    @Transactional(readOnly = true)
    @Override
    public TeacherExperienceInfo getTeacherExperienceInfo(Long id) {
        final Optional<TeacherExperienceInfo> optionalTeacherExperienceInfo = teacherExperienceInfoDAO.findById(id);
        return optionalTeacherExperienceInfo.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }
    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        return BaseService.makeNewCriteria(fieldName, value, operator, criteriaRqList);
    }

}
