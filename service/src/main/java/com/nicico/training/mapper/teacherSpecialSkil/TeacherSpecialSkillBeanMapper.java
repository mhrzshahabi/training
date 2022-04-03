package com.nicico.training.mapper.teacherSpecialSkil;

import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.dto.teacherSpecialSkill.TeacherSpecialSkillDTO;
import com.nicico.training.iservice.IParameterValueService;

import com.nicico.training.model.TeacherSpecialSkill;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TeacherSpecialSkillBeanMapper {
    @Autowired
    protected IParameterValueService iParameterValueService;

    public abstract TeacherSpecialSkillDTO.Info toTeacherSpecialSkillInfoDTO(TeacherSpecialSkill teacherSpecialSkill);

    public abstract List<TeacherSpecialSkillDTO.Info> toTeacherSpecialSkillInfoList(List<TeacherSpecialSkill> teacherSpecialSkillList);

    public abstract TeacherSpecialSkill toTeacherSpecialSkill(TeacherSpecialSkillDTO.Create teacherSpecialSkillDTO);

    public abstract TeacherSpecialSkill toTeacherUpdatedSpecialSkill(TeacherSpecialSkillDTO.Update teacherSpecialSkillDTO);

    @Mapping(source = "fieldId", target = "field", qualifiedByName = "toParameterTupleInfo")
    @Mapping(source = "typeId", target = "type", qualifiedByName = "toParameterTupleInfo")
    @Mapping(source = "levelId", target = "level", qualifiedByName = "toParameterTupleInfo")
    public abstract TeacherSpecialSkillDTO.UpdatedInfo toTeacherUpdatedInfoDto(TeacherSpecialSkill teacherSpecialSkill);

    @Named("toParameterTupleInfo")
    ParameterValueDTO.TupleInfo toParameterTupleInfo(Long parameterValueId) {
        ParameterValueDTO.TupleInfo info = new ParameterValueDTO.TupleInfo();
        info = iParameterValueService.getInfo(parameterValueId);
        return info;
    }

    @Mapping(source = "fieldId", target = "fieldTitle", qualifiedByName = "toParameterTitle")
    @Mapping(source = "typeId", target = "typeTitle", qualifiedByName = "toParameterTitle")
    @Mapping(source = "levelId", target = "levelTitle", qualifiedByName = "toParameterTitle")
    public abstract TeacherSpecialSkillDTO.Resume toTeacherSpecialSkillResume(TeacherSpecialSkill teacherSpecialSkills);

    public abstract List<TeacherSpecialSkillDTO.Resume> toTeacherSpecialSkillResumeList(List<TeacherSpecialSkill> teacherSpecialSkills);

    @Named("toParameterTitle")
    String toParameterTitle(Long parameterValueId) {
        ParameterValueDTO.TupleInfo info = iParameterValueService.getInfo(parameterValueId);
        return info.getTitle();
    }

}
