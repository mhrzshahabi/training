package com.nicico.training.mapper.teacherSpecialSkil;

import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.model.TeacherSpecialSkill;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import com.nicico.training.mapper.tclass.TclassBeanMapper;
import com.nicico.training.model.TeacherSpecialSkill;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN,uses = {TclassBeanMapper.class})
public interface TeacherSpecialSkillBeanMapper {
    TeacherSpecialSkillDTO.Info toTeacherSpecialSkillInfoDTO(TeacherSpecialSkill teacherSpecialSkill);

    List<TeacherSpecialSkillDTO.Info> toTeacherSpecialSkillInfoList(List<TeacherSpecialSkill> teacherSpecialSkillList);

    TeacherSpecialSkill toTeacherSpecialSkill(TeacherSpecialSkillDTO.Create teacherSpecialSkillDTO);

}
