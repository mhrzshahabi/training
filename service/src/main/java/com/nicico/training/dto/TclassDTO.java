package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.IQuestionnaireQuestionService;
import com.nicico.training.model.*;
import com.nicico.training.repository.QuestionnaireQuestionDAO;
import com.nicico.training.service.EvaluationService;
import com.nicico.training.service.ParameterService;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;
import lombok.experimental.Accessors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.validation.constraints.NotNull;
import java.util.*;

@Getter
@Setter
@Accessors(chain = true)
public class TclassDTO {

    //    @ApiModelProperty(required = true)
    //    private Long courseId;

    private Long minCapacity;
    private Long maxCapacity;
    @ApiModelProperty(required = true)
    private String code;
    private Long teacherId;
    private Long instituteId;
    private Long organizerId;
    private String titleClass;
    private String teachingType;//روش آموزش
    private Long hDuration;
    //    private Long dDuration;
    private Long supervisor;
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
    private Integer startEvaluation;
    private Boolean preCourseTest;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassInfo")
    public static class Info extends TclassDTO {

        private Long courseId;
        private InstituteDTO.InstituteInfoTuple institute;
        //        private Date createdDate;
        //        private String createdBy;
        //        @Getter(AccessLevel.NONE)
        //        private Date lastModifiedDate;
        //        public String getLastModifiedDate(){
        //            if(lastModifiedDate == null){
        //                return createdDate.toString();
        //            }
        //            return lastModifiedDate.toString();
        //        }
        private String lastModifiedBy;
        private Long id;
        private CourseDTO.CourseInfoTuple course;
        private TermDTO term;
        //        private List<Student> studentSet;
        @Getter(AccessLevel.NONE)
        private TeacherDTO.TeacherFullNameTuple teacher;
        private String hasWarning;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else
                return " ";
        }

        private Set<ClassStudentDTO.AttendanceInfo> classStudents;

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
                    if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) != 0 ||
                            Optional.ofNullable(classStudent.getEvaluationStatusLearning()).orElse(0) != 0 ||
                            Optional.ofNullable(classStudent.getEvaluationStatusBehavior()).orElse(0) != 0 ||
                            Optional.ofNullable(classStudent.getEvaluationStatusResults()).orElse(0) != 0) {
                        studentEvaluations++;
                    }
                }

                return studentEvaluations + "/" + classStudents.size();
            } else
                return "0";
        }

        public Integer getStudentCount() {
            if (classStudents != null)
                return classStudents.size();
            else
                return 0;
        }
    }

    // ------------------------------

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
    @ApiModel("TclassCreateRq")
    public static class Create extends TclassDTO {
        private Long courseId;
//        private List<Long> studentSet;
    }
//----------------------------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassTeachingHistory")
    public static class TeachingHistory {
        private Long id;
        private String code;
        private String titleClass;
        private String startDate;
        private String endDate;
        private Double evaluationGrade;
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

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassUpdateRq")
    public static class Update extends TclassDTO {
        private Long courseId;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class TclassSpecRs {
        private SpecRs response;
    }

    // ------------------------------

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

    // ------------------------------

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
        private TermDTO term;
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

    //-------------------------------
    //--------------------------------

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
        private String evaluationStatus;
        private String titleClass;
        private String scoringMethod;

        public String getTeacher() {
            if (teacher != null)
                return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
            else
                return " ";
        }

        public Integer getStudentCount() {
            if (classStudents != null)
                return classStudents.size();
            else
                return 0;
        }

        public Integer getNumberOfStudentCompletedEvaluation() {
            int studentEvaluations = 0;
            for (ClassStudentDTO.EvaluationInfo classStudent : classStudents) {
                if (Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 2 ||
                        Optional.ofNullable(classStudent.getEvaluationStatusLearning()).orElse(0) == 2 ||
                        Optional.ofNullable(classStudent.getEvaluationStatusBehavior()).orElse(0) == 2 ||
                        Optional.ofNullable(classStudent.getEvaluationStatusResults()).orElse(0) == 2) {
                    studentEvaluations++;
                }
            }
            return studentEvaluations;
        }

        //        public Set<ClassStudentDTO.AttendanceInfo> getClassStudentsForEvaluation(Long studentId) {
//            if (studentId == -1) {
//                return classStudents;
//            } else {
//
//                Set<ClassStudentDTO.AttendanceInfo> findStudent = new HashSet<>();
//                for (ClassStudentDTO.AttendanceInfo student : classStudents) {
//                    if (student.getStudentId().equals(studentId)) {
//                        findStudent.add(student);
//                        break;
//                    }
//                }
//
//                return findStudent;
//            }
//        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ReactionEvaluationResult")
    public static class ReactionEvaluationResult {
        boolean FERPass;
        boolean FETPass;
        boolean FECRPass;
        Integer studentCount;
        double FERGrade;
        double FETGrade;
        double FECRGrade;
        Integer numberOfFilledReactionEvaluationForms;
        Integer numberOfInCompletedReactionEvaluationForms;
        Integer numberOfEmptyReactionEvaluationForms;
        Integer numberOfExportedReactionEvaluationForms;
        double percenetOfFilledReactionEvaluationForms;
        double minScore_ER;
        double minScore_ET;
        double minScoreFECR;
        double teacherGradeToClass;
        double studentsGradeToTeacher;
        double studentsGradeToFacility;
        double studentsGradeToGoals;
        double trainingGradeToTeacher;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BehavioralEvaluationResult")
    public static class BehavioralEvaluationResult {
        double classPassedTime;
        Integer numberOfFilledFormsBySuperviosers;
        Integer numberOfFilledFormsByStudents;
        double supervisorsMeanGrade;
        double studentsMeanGrade;
        double FEBGrade;
        boolean FEBPass;
        double FECBGrade;
        boolean FECBPass;
        private Set<ClassStudentDTO.EvaluationInfo> classStudents;
        List<Double> studentsGrade = new ArrayList<>();
        List<Double> supervisorsGrade = new ArrayList<>();
        List<String> classStudentsName = new ArrayList<>();
        public void setClassStudentsName(){
            for (ClassStudentDTO.EvaluationInfo classStudent : classStudents) {
                classStudentsName.add(classStudent.getStudent().getFirstName() + " " + classStudent.getStudent().getLastName());
            }
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassEvaluatedSpecRs")
    public static class TclassEvaluatedSpecRs {
        private EvaluatedSpecRs response;
    }

    // ------------------------------

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

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class PersonnelClassInfo_TclassSpecRs {
        private PersonnelClassInfo_SpecRs response;
    }

    // ------------------------------

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

    // ------------------------------

    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("PersonnelClassInfo")
    public static class PersonnelClassInfo
    {
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
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("AllStudentsGradeToTeacher")
    public static class AllStudentsGradeToTeacher
    {
        private Long id;
        private String code;
        private String titleClass;
        private String startDate;
        private String endDate;
        private String term;
        private String grade;
    }

    // ------------------------------

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
        private CourseDTO.CourseInfoTuple course;
    }

}
