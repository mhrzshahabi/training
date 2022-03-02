package com.nicico.training.iservice;

import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import response.BaseResponse;

import java.util.List;

public interface ITeacherSpecialSkillService {
    List<TeacherSpecialSkillDTO.Info> findTeacherSpecialSkills(Long teacherId);
    BaseResponse create(TeacherSpecialSkillDTO.Create teacherSpecialSkillDTO);

    TeacherSpecialSkillDTO.UpdatedInfo update(TeacherSpecialSkillDTO.Update teacherSpecialSkillDTO);

    void deleteSpecialSkill(Long id);

}
