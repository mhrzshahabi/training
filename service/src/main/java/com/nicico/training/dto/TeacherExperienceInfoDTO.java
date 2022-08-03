package com.nicico.training.dto;

import com.nicico.training.dto.enums.EGenderDTO;
import com.nicico.training.dto.enums.EMarriedDTO;
import com.nicico.training.dto.enums.EMilitaryDTO;
import com.nicico.training.dto.enums.TeacherRankDTO;
import com.nicico.training.model.TeacherExperienceInfo;
import com.nicico.training.model.enums.TeacherRank;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import java.util.Date;
import java.util.function.Function;

@Getter
@Setter

public class TeacherExperienceInfoDTO {

    private Long id;
    private TeacherRank teacherRank;
    private String teacherRankTitle;
    private Long salaryBase;
    private Long teachingExperience;
    private Long teacherId;


}
