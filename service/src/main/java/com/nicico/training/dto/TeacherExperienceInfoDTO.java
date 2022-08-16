package com.nicico.training.dto;

import com.nicico.training.model.enums.TeacherRank;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;


@Getter
@Setter
@Accessors(chain = true)
public class TeacherExperienceInfoDTO {

    private Long id;
    private TeacherRank teacherRank;
    private String teacherRankTitle;
    private Long salaryBase;
    private Long teachingExperience;
    private Long teacherId;
    private Integer teacherRankId;

    @Getter
    @Setter
    @Accessors(chain = true)
    public static class ExcelInfo {
        private Long id;
        private Long teacherRank;
        private String teacherRankTitle;
        private Long salaryBase;
        private Long teachingExperience;
    }

}
