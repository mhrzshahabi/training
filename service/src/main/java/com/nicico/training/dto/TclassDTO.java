package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.*;

@Getter
@Setter
@Accessors(chain = true)
public class TclassDTO {
    private Long minCapacity;
    private Long maxCapacity;
    @ApiModelProperty(required = true)
    private String code;
    private Long teacherId;
    private Long instituteId;
    private Date createdDate;
    private Long organizerId;
    private String titleClass;
    private String teachingType;//روش آموزش
    private Long hDuration;
    private Long supervisorId;
    private Long plannerId;
    private String reason;
    private String classStatus;
    private Date classStatusDate;
    @ApiModelProperty(required = true)
    private Long group;
    @ApiModelProperty(required = true)
    private Long termId;
    private String teachingBrand;//نحوه آموزش
    @ApiModelProperty(required = true)
    private String startDate;
    @ApiModelProperty(required = true)
    private String endDate;
    private Boolean saturday;
    private Boolean sunday;
    private Boolean monday;
    private Boolean tuesday;
    private Boolean wednesday;
    private Boolean thursday;
    private Boolean friday;
    private Boolean first;
    private Boolean second;
    private Boolean third;
    private Boolean fourth;
    private Boolean fifth;
    private String topology;//چیدمان
    private List<Long> trainingPlaceIds;
    private String workflowEndingStatus;
    private Integer workflowEndingStatusCode;
    private String scoringMethod;
    private String acceptancelimit;
    private Boolean preCourseTest;
    private String hasWarning;
    private Integer evaluationStatusReactionTraining;
    private Integer evaluationStatusReactionTeacher;
    private Integer startEvaluation;
    private String evaluation;
    private String behavioralLevel;
    private Long classCancelReasonId;
    private Long alternativeClassId;
    private String postponeStartDate;
    private String studentCost;
    private Long studentCostCurrency;
    private Boolean teacherOnlineEvalStatus;
    private Boolean studentOnlineEvalStatus;
    private Boolean hasTest;
    private String courseCode;
    private Long targetPopulationTypeId;
    private Long holdingClassTypeId;
    private Long teachingMethodId;
    private Boolean classToOnlineStatus;
    private Long complexId;
    private Long assistantId;
    private Long affairsId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InfoForQB")
    public static class InfoForQB extends TclassDTO {
        private Long courseId;
        private String lastModifiedBy;
        private Long id;
        private CourseDTO.CourseInfoTuple course;
        @Getter(AccessLevel.NONE)
        private TeacherDTO.TeacherFullNameTuple teacher;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else return " ";
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InfoForAudit")
    public static class InfoForAudit extends TclassDTO {
        private String teacher;
        private String createdBy;
        private String modifiedBy;
        private String modifiedDate;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassInfo")
    public static class Info extends TclassDTO {
        private Long courseId;
        private InstituteDTO.InstituteInfoTuple institute;
        private String lastModifiedBy;
        private ParameterValueDTO classCancelReason;
        private Long id;
        private CourseDTO.CourseInfoTuple course;
        private TermDTO.TermDTOTuple term;
        @Getter(AccessLevel.NONE)
        private TeacherDTO.TeacherFullNameTuple teacher;
        private String plannerFullName;
        private PersonnelDTO.InfoTuple planner;
        private PersonnelDTO.InfoTuple supervisor;
        private String supervisorFullName;
        private String organizerName;
        private InstituteDTO.InstituteInfoTuple organizer;
        private List<TclassDTO.InfoTuple> canceledClasses;
        private String isSentMessage;
        private ParameterValueDTO targetPopulationType;
        private ParameterValueDTO holdingClassType;
        private ParameterValueDTO teachingMethod;
        private Long hDuration;
        private Set<ClassStudentDTO.AttendanceInfo> classStudents;
        private Long educationalCalenderId;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else return " ";
        }

        public Set<ClassStudentDTO.AttendanceInfo> getClassStudentsForEvaluation(Long studentId) {
            if (studentId == -1) {
                return classStudents;
            } else {

                Set<ClassStudentDTO.AttendanceInfo> findStudent = new HashSet<>();
                for (ClassStudentDTO.AttendanceInfo student : classStudents) {
                    if (student.getStudentId().equals(studentId)) {
                        findStudent.add(student);
                        break;
                    }
                }

                return findStudent;
            }
        }

        public String getNumberOfStudentEvaluation() {

            if (classStudents != null) {
                int studentEvaluations = 0;
                for (ClassStudentDTO.AttendanceInfo classStudent : classStudents) {
                    if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) != 0 || Optional.ofNullable(classStudent.getEvaluationStatusLearning()).orElse(0) != 0 || Optional.ofNullable(classStudent.getEvaluationStatusBehavior()).orElse(0) != 0 || Optional.ofNullable(classStudent.getEvaluationStatusResults()).orElse(0) != 0) {
                        studentEvaluations++;
                    }
                }

                return studentEvaluations + "/" + classStudents.size();
            } else return "0";
        }

        public Integer getStudentCount() {
            if (classStudents != null) return classStudents.size();
            else return 0;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassExamInfo")
    public static class ExamInfo {
        private Long courseId;
        private Long id;
        private CourseDTO.CourseInfoTuple course;
        private String code;
        private Long teacherId;
        private String titleClass;
        private String teachingType;//روش آموزش
        @ApiModelProperty(required = true)
        private String startDate;
        @ApiModelProperty(required = true)
        private String endDate;
        private String scoringMethod;
        private String acceptancelimit;
        private Boolean preCourseTest;
        private String evaluation;
        private String behavioralLevel;
        private Boolean teacherOnlineEvalStatus;
        private Boolean studentOnlineEvalStatus;
        private Boolean hasTest;
        private String courseCode;
//        private Integer evaluationStatusReactionTraining;
//        private Integer evaluationStatusReactionTeacher;
//        private Integer startEvaluation;
        //        private Long minCapacity;
//        private Long maxCapacity;
        //        private String teachingBrand;//نحوه آموزش
        //        @Getter(AccessLevel.NONE)
//        private TeacherDTO.TeacherFullNameTuple teacher;
//        private List<TclassDTO.InfoTuple> canceledClasses;
//        public String getTeacher() {
//            if (teacher != null)
//                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
//            else return " ";
//        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("list")
    @AllArgsConstructor
    public static class list {
        private String firstname;
        private String lastName;
        private String nationalCode;
        private String phone;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherInfo")
    public static class teacherInfo {
        private TeacherDTO.TeacherInformation teacher;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("teacherInfoCustom")
    public static class teacherInfoCustom {
        private String firstName;
        private String lastName;
        private String nationalCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassScore")
    public static class ScoreInfo {
        private String scoringMethod;
        private String acceptancelimit;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("FinalTestTclassInfo")
    public static class FinalTestInfo {
        private Long id;
        private Long teacherId;
        private TeacherDTO.FinalTestInfo teacher;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassCreateRq")
    public static class Create extends TclassDTO {
        private Long courseId;
        private Long targetSocietyTypeId;
        @Getter(AccessLevel.NONE)
        private List<Object> targetSocieties;

        public List<Object> getTargetSocieties() {
            if (targetSocieties == null) return new ArrayList<>(0);
            boolean accept = true;
            for (Object society : targetSocieties) {
                if (targetSocietyTypeId == 371 && society instanceof Integer) continue;
                else if (targetSocietyTypeId == 372 && society instanceof String) continue;
                accept = false;
                break;
            }
            return accept ? targetSocieties : new ArrayList<>(0);
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassTeachingHistory")
    public static class TeachingHistory {
        private Long id;
        private String startDate;
        private String endDate;
        private Double evaluationGrade;
        private CourseDTO.CourseClassReport course;
        private String code;
        private InstituteDTO.InstituteInfoTuple organizer;
        private String teacherEvalGrade;



    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassTeachingHistorySpecRs")
    public static class TclassTeachingHistorySpecRs {
        private TeachingHistorySpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class TeachingHistorySpecRs {
        private List<TclassDTO.TeachingHistory> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassUpdateRq")
    public static class Update extends TclassDTO {
        private Long courseId;
        private Long targetSocietyTypeId;
        @Getter(AccessLevel.NONE)
        private List<Object> targetSocieties;

        public List<Object> getTargetSocieties() {
            if (targetSocieties == null) return new ArrayList<>(0);
            boolean accept = true;
            for (Object society : targetSocieties) {
                if (targetSocietyTypeId == 371 && society instanceof Integer) continue;
                else if (targetSocietyTypeId == 372 && society instanceof String) continue;
                accept = false;
                break;
            }
            return accept ? targetSocieties : new ArrayList<>(0);
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class TclassSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class TclassAuditSpecRs {
        private SpecAuditRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<TclassDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecAuditRs {
        private List<TclassDTO.InfoForAudit> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CoursesOfStudent")
    public static class CoursesOfStudent {
        private Long id;
        private CourseDTO.CourseInfoTupleLite course;
        private String code;
        private String classStatus;
        private String startDate;
        private String endDate;
        private Long hDuration;
        private TermDTO term;
        private Long supervisorId;
        private Long plannerId;
        @Getter(AccessLevel.NONE)
        private TeacherDTO.TeacherFullNameTuple teacher;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else return " ";
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentClassList")
    public static class StudentClassList {
        private Long id;
        private String code;
        private String titleClass;
        private Long courseId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassEvaluatedInfoGrid")
    public static class EvaluatedInfoGrid {
        private Long id;
        private String code;
        private CourseDTO.CourseInfoTuple course;
        private String startDate;
        private String endDate;
        private TermDTO term;
        private Long termId;
        private TeacherDTO.TeacherFullNameTuple teacher;
        private Long teacherId;
        private Set<ClassStudentDTO.EvaluationInfo> classStudents;
        private InstituteDTO.InstituteInfoTuple institute;
        private Long instituteId;
        private String classStatus;
        private String titleClass;
        private String scoringMethod;
        private Integer startEvaluation;
        private String evaluation;
        private String behavioralLevel;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else return " ";
        }

        public Integer getStudentCount() {
            if (classStudents != null) return classStudents.size();
            else return 0;
        }

        public Integer getNumberOfStudentCompletedEvaluation() {
            int studentEvaluations = 0;
            for (ClassStudentDTO.EvaluationInfo classStudent : classStudents) {
                if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 || Optional.ofNullable(classStudent.getEvaluationStatusLearning()).orElse(0) == 2 || Optional.ofNullable(classStudent.getEvaluationStatusBehavior()).orElse(0) == 2 || Optional.ofNullable(classStudent.getEvaluationStatusResults()).orElse(0) == 2) {
                    studentEvaluations++;
                }
            }
            return studentEvaluations;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ReactionEvaluationResult")
    public static class ReactionEvaluationResult {
        Boolean FERPass;
        Boolean FETPass;
        Boolean FECRPass;
        Integer studentCount;
        Double FERGrade;
        Double FETGrade;
        Double FECRGrade;
        Integer numberOfFilledReactionEvaluationForms;
        Integer numberOfAbsentForm;
        Integer numberOfInCompletedReactionEvaluationForms;
        Integer numberOfEmptyReactionEvaluationForms;
        Integer numberOfExportedReactionEvaluationForms;
        Double percenetOfFilledReactionEvaluationForms;
        Double minScore_ER;
        Double minScore_ET;
        Double minScoreFECR;
        Double teacherGradeToClass;
        Double studentsGradeToTeacher;
        Double studentsGradeToFacility;
        Double studentsGradeToGoals;
        Double trainingGradeToTeacher;
        Double z1;
        Double z2;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ExecutionEvaluationResult")
    public static class ExecutionEvaluationResult {
        Boolean FEEPass;
        Integer studentCount;
        Double FEEGrade;
        Integer numberOfFilledExecutionEvaluationForms;
        Integer numberOfInCompletedExecutionEvaluationForms;
        Integer numberOfEmptyExecutionEvaluationForms;
        Integer numberOfExportedExecutionEvaluationForms;
        Double percentOfFilledExecutionEvaluationForms;
        Double studentsGradeToTeacher;
        Double studentsGradeToFacility;
        Double studentsGradeToGoals;
        Double z9;
        String executionEvaluationStatus;
        List<QuestionnaireQuestionDTO.ExecutionInfo> questionnaireQuestions;
        String QuestionnaireTitle;
        Double differ;

    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BehavioralEvaluationResult")
    public static class BehavioralEvaluationResult {
        String classPassedTime;
        Integer numberOfFilledFormsBySuperviosers;
        Integer numberOfFilledFormsByStudents;
        double supervisorsMeanGrade;
        double studentsMeanGrade;
        double FEBGrade;
        boolean FEBPass;
        double FECBGrade;
        boolean FECBPass;
        Double[] studentsGrade;
        Double[] supervisorsGrade;
        String[] classStudentsName;
        private Set<ClassStudentDTO.EvaluationInfo> classStudents;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassEvaluatedSpecRs")
    public static class TclassEvaluatedSpecRs {
        private EvaluatedSpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class EvaluatedSpecRs {
        private List<TclassDTO.EvaluatedInfoGrid> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class PersonnelClassInfo_TclassSpecRs {
        private PersonnelClassInfo_SpecRs response;
        private Boolean isInPersonnelTbl;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class PersonnelClassInfo_SpecRs {
        private List<TclassDTO.PersonnelClassInfo> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("PersonnelClassInfo")
    public static class PersonnelClassInfo {
        private Long id;
        private String code;
        private String titleClass;
        private Long hDuration;
        private String startDate;
        private String endDate;
        private Long classStatusId;
        private String classStatus;
        private Long scoreStateId;
        private String scoreState;
        private String ERunType;
        private Long courseId;
        private String courseTitle;
        private Long failureReasonId;
        private String failureReason;
        private String courseCode;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("AllStudentsGradeToTeacher")
    public static class AllStudentsGradeToTeacher {
        private Long id;
        private String code;
        private String titleClass;
        private String startDate;
        private String endDate;
        private String term;
        private String grade;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassDetailInfo")
    public static class ClassDetailInfo extends Info {
        private String classSessionTimes;
        private String classDays;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassWeeklySchedule")
    public static class WeeklySchedule {
        private Long id;
        private String code;
        private CourseDTO.CourseWeeklySchedule course;
        private Set<ClassStudentDTO.WeeklySchedule> classStudents;
        private Integer startEvaluation;
        private String evaluation;
        private String behavioralLevel;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TClassReport")
    public static class TClassReport {
        private Long id;
        private String code;
        private CourseDTO.CourseClassReport course;
        private TeacherDTO.TeacherFullNameTuple teacher;
        private Long teacherId;
        private Set<ClassStudentDTO.AttendanceInfo> classStudents;
        private Integer studentsCount;
        private Long hDuration;
        private String startDate;
        private String endDate;
        private String classStatus;
        private String scoringMethod;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else return " ";
        }

        public Integer getStudentsCount() {
            if (classStudents != null) return classStudents.size();
            else return 0;
        }

        public String getYear() {
            return startDate.substring(0, 4);
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassReportSpecRs")
    public static class TclassReportSpecRs {
        private ReportSpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class ReportSpecRs {
        private List<TclassDTO.TClassReport> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassTerm")
    public static class TclassTerm {
        private Long id;
        private CourseDTO.CourseInfoTuple course;
        private TermDTO.TermDTOTuple term;
        private Integer startEvaluation;
        private String evaluation;
        private String behavioralLevel;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassTeacherReport")
    public static class TclassTeacherReport {
        private TermDTO.TermDTOTuple term;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassHistory")
    public static class TclassHistory {
        private Long id;
        private String titleClass;
        private String startDate;
        private String endDate;
        private String code;
        private TermDTO.TermDTOTuple term;
        private CourseDTO.CourseInfoTuple course;
        private InstituteDTO.InstituteInfoTuple institute;
        private Set<ClassStudentDTO.AttendanceInfo> classStudents;
        private Integer startEvaluation;
        private String evaluation;
        private String behavioralLevel;
        private String classStatus;
        private List<Long> trainingPlaceIds;
        private Long instituteId;
        private String workflowEndingStatus;
        private Integer workflowEndingStatusCode;

        public Integer getStudentCount() {
            if (classStudents != null) return classStudents.size();
            else return 0;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsHistory {
        private List<TclassDTO.TclassHistory> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRsHistory")
    public static class TclassSpecRsHistory {
        private SpecRsHistory response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassInfoTuple")
    public static class InfoTuple {
        private Long id;
        private String titleClass;
        private String code;
        private CourseDTO.InfoTuple course;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassInfoTupleSpecRs")
    public static class TclassInfoTupleSpecRs {
        private InfoTupleSpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class InfoTupleSpecRs {
        private List<TclassDTO.InfoTuple> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TClassScoreEval")
    public static class TClassScoreEval {
        private Long id;
        private String code;
        private String classStatus;
        private String scoringMethod;
        private String acceptancelimit;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TClassCurrentTerm")
    public static class TClassCurrentTerm {
        private String code;
        private String titleClass;
        private String startDate;
        private String endDate;
        private TeacherDTO.TeacherCurrentTerm teacher;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TClassTimeDetails")
    public static class TClassTimeDetails {
        private String classCode;
        private String courseCode;
        private String courseTitleFa;
        private String termTitleFa;
        private String startDate;
        private String endDate;
        private Long group;
        private Set<ClassSessionDTO.AttendanceClearForm> classSessions;
        private Long studentsCount;
        private TeacherDTO.TeacherInfo teacherInfo;
        private String supervisorName;
        private String plannerName;
        private String organizer;
        private String classStatus;
        private String classType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TClassDataService")
    public static class TClassDataService {
        private String classStatus;
        private String classType;
        private String classCode;
        private String courseCode;
        private String courseTitle;
        private Long group;
        private Long studentsCount;
        private String supervisorName;
        private String organizerName;
        private TeacherDTO.TeacherInfo teacherInfo;
        private Set<ClassSessionDTO.AttendanceClearForm> sessions;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InfoForEvalAudit")
    public static class InfoForEvalAudit {
        private String code;
        private String titleClass;
        private Boolean teacherOnlineEvalStatus;
        private Boolean studentOnlineEvalStatus;
        private String createdBy;
        private String modifiedBy;
        private String modifiedDate;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecAuditEvalRs {
        private List<TclassDTO.InfoForEvalAudit> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TClassAuditEvalSpecRs")
    public static class TClassAuditEvalSpecRs {
        private SpecAuditEvalRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TClassForAgreement")
    public static class TClassForAgreement {
        private Long id;
        private String code;
        private String titleClass;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PassedClasses")
    public static class PassedClasses {
        private Long classId;
        private String courseCode;
        private String courseTitle;
        private Float courseTheoryDuration;
        private String termTitle;
        private String teacherName;
        private String startDate;
        private String endDate;
        private String scoresState;
        private String fileAddress;
        private Float score;

        public PassedClasses(Long classId, String courseCode, String courseTitle, Float courseTheoryDuration, String termTitle, String teacherName, String startDate, String endDate, String scoresState, Float score,String fileAddress) {
            this.classId = classId;
            this.courseCode = courseCode;
            this.courseTitle = courseTitle;
            this.courseTheoryDuration = courseTheoryDuration;
            this.termTitle = termTitle;
            this.teacherName = teacherName;
            this.startDate = startDate;
            this.endDate = endDate;
            this.scoresState = scoresState;
            this.score = score;
            this.fileAddress = fileAddress;
        }
    }
}
