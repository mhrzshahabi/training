package com.nicico.training.dto;

import com.nicico.training.dto.enums.EGenderDTO;
import com.nicico.training.dto.enums.EMarriedDTO;
import com.nicico.training.dto.enums.EMilitaryDTO;
import com.nicico.training.dto.enums.TeacherRankDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import java.util.Date;

@Getter
@Setter
public class TeacherExperienceInfoDTO {

    private Long id;
    private TeacherRankDTO teacherRank;
    private String salaryBase;
    private String teachingExperience;





}
