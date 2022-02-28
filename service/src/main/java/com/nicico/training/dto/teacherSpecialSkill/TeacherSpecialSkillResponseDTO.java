package com.nicico.training.dto.teacherSpecialSkill;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Setter
@Getter
public class TeacherSpecialSkillResponseDTO extends BaseResponse {
    List<TeacherSpecialSkillDTO.Info> specialSkillDTOS;
}
