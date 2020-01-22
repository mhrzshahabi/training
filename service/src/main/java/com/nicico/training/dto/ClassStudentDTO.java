package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)

public class ClassStudentDTO implements Serializable {

    private String scoresState;

    private String failureReason;

    private Float score;

    private String valence;

    private String applicantCompanyName;

    private Long presenceTypeId;

    @ApiModelProperty(required = true)
    private Long studentId;

    @ApiModelProperty(required = true)
    private Long tclassId;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Info")
    public static class ClassStudentInfo {
        private Long id;
        private StudentDTO.ClassStudentInfo student;
        private String applicantCompanyName;
        private Long presenceTypeId;
        private Integer evaluationStatusReaction;
        private Integer evaluationStatusLearning;
        private Integer evaluationStatusBehavior;
        private Integer evaluationStatusResults;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Create")
    public static class Create {
        @ApiModelProperty(required = true)
        private String personnelNo;
        private Integer registerTypeId;
        private String applicantCompanyName;
        private Long presenceTypeId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Update")
    public static class Update {
        private String applicantCompanyName;
        private Long presenceTypeId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TClassStudent - Update_Score")
    public static class Update_Score {
        private String scoresState;
        private String failureReason;
        private Float score;
        private String valence;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @ApiModel("ClassStudent - Attendance")
//    public static class AttendanceInfo {
//        private Long id;
//        private StudentDTO.AttendanceInfo student;
//        private String applicantCompanyName;
//        private Long presenceTypeId;
//    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - AttendanceInfo")
    public static class AttendanceInfo{

        @Getter(AccessLevel.NONE)
        private StudentDTO.AttendanceInfo student;

        @Getter(AccessLevel.NONE)
        private Long studentId;
        public Long getStudentId(){
            return student.getId();
        }
        @Getter(AccessLevel.NONE)
        private String firstName;
        public String getFirstName(){
            return student.getFirstName();
        }
        @Getter(AccessLevel.NONE)
        private String lastName;
        public String getLastName(){
            return student.getLastName();
        }
        @Getter(AccessLevel.NONE)
        private String nationalCode;
        public String getNationalCode(){
            return student.getNationalCode();
        }
        @Getter(AccessLevel.NONE)
        private String companyName;
        public String getCompanyName(){
            return student.getCompanyName();
        }
        @Getter(AccessLevel.NONE)
        private String personnelNo;
        public String getPersonnelNo(){
            return student.getPersonnelNo();
        }
        @Getter(AccessLevel.NONE)
        private String personnelNo2;
        public String getPersonnelNo2(){
            return student.getPersonnelNo2();
        }
        private Long presenceTypeId;
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Scores")
    public static class ScoresInfo {
        private Long id;
        private StudentDTO.ScoresInfo student;
        private TclassDTO.ScoreInfo tclass;
        private String scoresState;
        private String failureReason;
        private Float score;
        private String valence;
    }

    @Getter
    @Setter
    @ApiModel("ClassStudentCountId")
    public static class ClassStudentCountId {
        private Long id;
    }

}
