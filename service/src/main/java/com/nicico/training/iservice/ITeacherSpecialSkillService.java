package com.nicico.training.iservice;

import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;

import java.util.List;

public interface ITeacherSpecialSkillService {
    List<TeacherSpecialSkillDTO.Info> findTeacherSpecialSkills(Long teacherId);
    TeacherSpecialSkillDTO.UpdatedInfo create(TeacherSpecialSkillDTO.Create teacherSpecialSkillDTO);

    TeacherSpecialSkillDTO.UpdatedInfo update(TeacherSpecialSkillDTO.Update teacherSpecialSkillDTO);

    void deleteSpecialSkill(Long id);

    TeacherSpecialSkillDTO.UpdatedInfo get(Long id);

    List<TeacherSpecialSkillDTO.Resume> findTeacherSpecialSkillsByNationalCode(String nationalCode);

}
