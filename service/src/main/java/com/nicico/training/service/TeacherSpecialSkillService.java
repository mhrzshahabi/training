package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.iservice.ITeacherSpecialSkillService;
import com.nicico.training.mapper.teacherSpecialSkil.TeacherSpecialSkillBeanMapper;
import com.nicico.training.model.TeacherSpecialSkill;
import com.nicico.training.repository.TeacherSpecialSkillDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TeacherSpecialSkillService implements ITeacherSpecialSkillService {
    private final TeacherSpecialSkillDAO teacherSpecialSkillDAO;
    private final TeacherSpecialSkillBeanMapper teacherSpecialSkillBeanMapper;
    private final ITeacherService iTeacherService;


    @Override
    @Transactional
    public List<TeacherSpecialSkillDTO.Info> findTeacherSpecialSkills(Long teacherId) {
        List<TeacherSpecialSkill> teacherSpecialSkills = teacherSpecialSkillDAO.findTeacherSpecialSkillByTeacherIdOrderByIdDesc(teacherId);
        return  teacherSpecialSkillBeanMapper.toTeacherSpecialSkillInfoList(teacherSpecialSkills);
    }

    @Override
    @Transactional
    public TeacherSpecialSkillDTO.UpdatedInfo create(TeacherSpecialSkillDTO.Create teacherSpecialSkillDTO) {
        TeacherSpecialSkillDTO.UpdatedInfo response = new TeacherSpecialSkillDTO.UpdatedInfo();
        try {
            Long teacherId = iTeacherService.getTeacherIdByNationalCode(teacherSpecialSkillDTO.getNationalCode());
            if (teacherId != null) {
                teacherSpecialSkillDTO.setTeacherId(teacherId);
                TeacherSpecialSkill teacherSpecialSkill = teacherSpecialSkillBeanMapper.toTeacherSpecialSkill(teacherSpecialSkillDTO);
                TeacherSpecialSkill finalSpecialSkill = teacherSpecialSkillDAO.save(teacherSpecialSkill);
                response = teacherSpecialSkillBeanMapper.toTeacherUpdatedInfoDto(finalSpecialSkill);
                response.setStatus(HttpStatus.OK.value());
            } else {
                response.setStatus(HttpStatus.NO_CONTENT.value());
                response.setMessage("استاد با این اطلاعات یافت نشد");
            }
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage(((TrainingException) e).getMsg());
        }
        return response;
    }

    @Override
    @Transactional
    public TeacherSpecialSkillDTO.UpdatedInfo update(TeacherSpecialSkillDTO.Update teacherSpecialSkillDTO) {
        TeacherSpecialSkillDTO.UpdatedInfo response = new TeacherSpecialSkillDTO.UpdatedInfo();
        try {
            Optional<TeacherSpecialSkill> mainTeacherSpecialSkill = teacherSpecialSkillDAO.findById(teacherSpecialSkillDTO.getId());
            if (mainTeacherSpecialSkill.isPresent()) {
                TeacherSpecialSkill finalTeacherSpecialSkill = mainTeacherSpecialSkill.get();
                TeacherSpecialSkill teacherSpecialSkill = teacherSpecialSkillBeanMapper.toTeacherUpdatedSpecialSkill(teacherSpecialSkillDTO);
                teacherSpecialSkill.setTeacherId(finalTeacherSpecialSkill.getTeacherId());
                TeacherSpecialSkill teacherSpecialSkill2 = teacherSpecialSkillDAO.save(teacherSpecialSkill);
                response = teacherSpecialSkillBeanMapper.toTeacherUpdatedInfoDto(teacherSpecialSkill2);
                response.setStatus(HttpStatus.OK.value());
            } else {
                response.setStatus(HttpStatus.NO_CONTENT.value());
                response.setMessage("مهارت مورد نظر یافت نشد");
            }
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage(((TrainingException) e).getMsg());
        }
        return response;
    }

    @Override
    public void deleteSpecialSkill(Long id) {
        teacherSpecialSkillDAO.deleteById(id);
    }

    @Transactional(readOnly = true)
    @Override
    public TeacherSpecialSkillDTO.UpdatedInfo get(Long id) {
        TeacherSpecialSkillDTO.UpdatedInfo response = new TeacherSpecialSkillDTO.UpdatedInfo();
        try {
            Optional<TeacherSpecialSkill> teacherSpecialSkill = teacherSpecialSkillDAO.findById(id);
            if (teacherSpecialSkill.isPresent()) {
                response = teacherSpecialSkillBeanMapper.toTeacherUpdatedInfoDto(teacherSpecialSkill.get());
                response.setStatus(HttpStatus.OK.value());
            } else {
                response.setStatus(HttpStatus.NO_CONTENT.value());
                response.setMessage("مهارت مورد نظر یافت نشد");
            }
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage(((TrainingException) e).getMsg());
        }
        return response;

    }

}
