package com.nicico.training.service;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.iservice.ITeacherSpecialSkillService;
import com.nicico.training.mapper.teacherSpecialSkil.TeacherSpecialSkillBeanMapper;
import com.nicico.training.model.TeacherSpecialSkill;
import com.nicico.training.repository.TeacherDAO;
import com.nicico.training.repository.TeacherSpecialSkillDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TeacherSpecialSkillService implements ITeacherSpecialSkillService {
    private final TeacherSpecialSkillDAO teacherSpecialSkillDAO;
    private final TeacherSpecialSkillBeanMapper teacherSpecialSkillBeanMapper;
    private final ITeacherService iTeacherService;


    @Override
    @Transactional
    public List<TeacherSpecialSkillDTO.Info> findTeacherSpecialSkills(Long teacherId) {
        List<TeacherSpecialSkill> teacherSpecialSkills = teacherSpecialSkillDAO.findTeacherSpecialSkillByTeacherIdOrderById(teacherId);
        return  teacherSpecialSkillBeanMapper.toTeacherSpecialSkillInfoList(teacherSpecialSkills);
    }

    @Override
    public BaseResponse create(TeacherSpecialSkillDTO.Create teacherSpecialSkillDTO) {
        BaseResponse baseResponse = new BaseResponse();
        try {
            Long teacherId = iTeacherService.getTeacherIdByNationalCode(teacherSpecialSkillDTO.getNationalCode());
            if (teacherId != null) {
                teacherSpecialSkillDTO.setTeacherId(teacherId);
                TeacherSpecialSkill teacherSpecialSkill = teacherSpecialSkillBeanMapper.toTeacherSpecialSkill(teacherSpecialSkillDTO);
                teacherSpecialSkillDAO.save(teacherSpecialSkill);
                baseResponse.setStatus(HttpStatus.OK.value());
            } else {
                baseResponse.setStatus(HttpStatus.NO_CONTENT.value());
                baseResponse.setMessage("استاد با این اطلاعات یافت نشد");
            }
        }catch (Exception e){
            baseResponse.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            baseResponse.setMessage(((TrainingException) e).getMsg());
        }
        return baseResponse;
    }

}
