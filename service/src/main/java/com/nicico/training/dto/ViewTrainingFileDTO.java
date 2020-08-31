package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewTrainingFileDTO implements Serializable {

    private String empNo;
    private String firstName;
    private String lastName;
    private String nationalCode;
    private String postTitle;
    private String postCode;
    private String jobTitle;
    private String postGradeTitle;
    private String affairs;
    private String termTitleFa;
    private Long scoresState;
    private Float score;
    private String classStatus;
    private String classCode;
    private String startDate;
    private String endDate;
    private String courseCode;
    private String courseTitle;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingFileInfo")
    public static class Info extends ViewTrainingFileDTO {

        @Getter(AccessLevel.NONE)
        private String teacher;

        public String getTeacher(){
            return this.getFirstName() + " " + this.getLastName();
        }

    }
}
