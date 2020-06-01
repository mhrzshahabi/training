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
        @Getter(AccessLevel.NONE)
        private Integer evaluationStatusReaction;
        @Getter(AccessLevel.NONE)
        private Integer evaluationStatusLearning;
        @Getter(AccessLevel.NONE)
        private Integer evaluationStatusBehavior;
        @Getter(AccessLevel.NONE)
        private Integer evaluationStatusResults;
        private String evaluationAudienceType;


        public Integer getEvaluationStatusReaction() {
            return evaluationStatusReaction == null ? 0 : evaluationStatusReaction;
        }

        public Integer getEvaluationStatusLearning() {
            return evaluationStatusLearning == null ? 0 : evaluationStatusLearning;
        }

        public Integer getEvaluationStatusBehavior() {
            return evaluationStatusBehavior == null ? 0 : evaluationStatusBehavior;
        }

        public Integer getEvaluationStatusResults() {
            return evaluationStatusResults == null ? 0 : evaluationStatusResults;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CoursesOfStudent - Info")
    public static class CoursesOfStudent {
        private Long id;
        private TclassDTO.CoursesOfStudent tclass;
        private StudentDTO.ClassesOfStudentInfo student;
        private Float score;
        private String scoresState;
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
    public static class AttendanceInfo {

        @Getter(AccessLevel.NONE)
        private StudentDTO.AttendanceInfo student;

        @Getter(AccessLevel.NONE)
        private Long studentId;

        public Long getStudentId() {
            return student.getId();
        }

        @Getter(AccessLevel.NONE)
        private String firstName;

        public String getFirstName() {
            return student.getFirstName();
        }

        @Getter(AccessLevel.NONE)
        private String lastName;

        public String getLastName() {
            return student.getLastName();
        }

        @Getter(AccessLevel.NONE)
        private String nationalCode;

        public String getNationalCode() {
            return student.getNationalCode();
        }

        @Getter(AccessLevel.NONE)
        private String companyName;

        public String getCompanyName() {
            return student.getCompanyName();
        }

        @Getter(AccessLevel.NONE)
        private String personnelNo;

        public String getPersonnelNo() {
            return student.getPersonnelNo();
        }

        @Getter(AccessLevel.NONE)
        private String personnelNo2;

        public String getPersonnelNo2() {
            return student.getPersonnelNo2();
        }

        private Long presenceTypeId;
        private Long id;
        private Integer evaluationStatusReaction;
        private Integer evaluationStatusLearning;
        private Integer evaluationStatusBehavior;
        private Integer evaluationStatusResults;
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

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - EvaluationInfo")
    public static class EvaluationInfo {
        private Long id;
        private Integer evaluationStatusReaction;
        private Integer evaluationStatusLearning;
        private Integer evaluationStatusBehavior;
        private Integer evaluationStatusResults;
        private StudentDTO.ClassStudentInfo student;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - PreTestScoreInfo")
    public static class PreTestScoreInfo {
        private Long id;
        private Float preTestScore;
        private Float score;
        private StudentDTO.ScoresInfo student;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - PreTestScoreUpdate")
    public static class PreTestScoreUpdate {
        private Long id;
        private Float preTestScore;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - evaluationAnalysistLearning")
    public static class evaluationAnalysistLearning {
        private Long id;
        private Float preTestScore;
        private Float score;
        private String valence;
        private StudentDTO.ScoresInfo student;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentClassList - Info")
    public static class StudentClassList {
        private TclassDTO.StudentClassList tclass;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - WeeklySchedule")
    public static class WeeklySchedule {
        private StudentDTO.AttendanceInfo student;
        private String nationalCodeStudent;
        public String getNationalCodeStudent() {
            return student.getNationalCode();
        }
//        private Long presenceTypeId;
    }

}
