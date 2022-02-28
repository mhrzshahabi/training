package com.nicico.training.service;

import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import com.nicico.training.iservice.ITeacherSpecialSkillService;
import com.nicico.training.mapper.teacherSpecialSkil.TeacherSpecialSkillBeanMapper;
import com.nicico.training.model.TeacherSpecialSkill;
import com.nicico.training.repository.TeacherDAO;
import com.nicico.training.repository.TeacherSpecialSkillDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TeacherSpecialSkillService implements ITeacherSpecialSkillService {
    private final TeacherSpecialSkillDAO teacherSpecialSkillDAO;
    private final TeacherDAO teacherDAO;
    private final TeacherSpecialSkillBeanMapper teacherSpecialSkillBeanMapper;


    @Override
    @Transactional
    public List<TeacherSpecialSkillDTO.Info> findTeacherSpecialSkills(Long teacherId) {
        List<TeacherSpecialSkill> teacherSpecialSkills = teacherSpecialSkillDAO.findTeacherSpecialSkillByTeacherIdOrderById(teacherId);
        return  teacherSpecialSkillBeanMapper.toTeacherSpecialSkillInfoList(teacherSpecialSkills);
    }
}
