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
        private Float preTestScore;
        private String warning;
        @Getter(AccessLevel.NONE)
        private Integer evaluationStatusReaction;
        @Getter(AccessLevel.NONE)
        private Integer evaluationStatusLearning;
        @Getter(AccessLevel.NONE)
        private Integer evaluationStatusBehavior;
        @Getter(AccessLevel.NONE)
        private Integer evaluationStatusResults;
        private Long tclassId;
        private TclassDTO.CoursesOfStudent tclass;
        private Integer numberOfSendedBehavioralForms;
        private Integer numberOfRegisteredBehavioralForms;

        public String getFullName(){
            return student.getFirstName()+" "+student.getLastName();
        }


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
        private ParameterValueDTO.MinInfo scoresState;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Create")
    public static class Create {
        @ApiModelProperty(required = true)
        private Long id;
        private String nationalCode;
        private String personnelNo;
        private String postCode;
        private String departmentCode;
        private Long postId;
        private Long departmentId;
        private String firstName;
        private String lastName;
        private Integer registerTypeId;
        private String applicantCompanyName;
        private Long presenceTypeId;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - CheckRegister")
    public static class RegisterInClass {
        @ApiModelProperty(required = true)
        private String personnelNo;
        private String nationalCode;
        private Integer registerTypeId;
        private String applicantCompanyName;
        private Long presenceTypeId;
        private Long id;
        private Boolean isNeedsAssessment;
        private Boolean isPassed;
        private Boolean isRunning;
        private Integer isPersonnel;
        private String firstName;
        private String lastName;
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
        private Integer numberOfSendedBehavioralForms;
        private Integer numberOfRegisteredBehavioralForms;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Scores")
    public static class ScoresInfo {
        private Long id;
        private StudentDTO.ScoresInfo student;
        private TclassDTO.ScoreInfo tclass;
       // private ParameterValueDTO.TupleInfo scoresState;
       // private ParameterValueDTO.TupleInfo failureReason;
        Long scoresStateId;
        Long failureReasonId;
        private Float score;
        private String valence;
        private String scoreStateTitle;
        private String failureReasonTitle;
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
        private Integer numberOfSendedBehavioralForms;
        private Integer numberOfRegisteredBehavioralForms;
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
