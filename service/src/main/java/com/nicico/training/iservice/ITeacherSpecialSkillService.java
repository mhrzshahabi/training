package com.nicico.training.iservice;

import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import com.nicico.training.model.TeacherSpecialSkill;

import java.util.List;

public interface ITeacherSpecialSkillService {
    List<TeacherSpecialSkillDTO.Info> findTeacherSpecialSkills(Long teacherId);

}
