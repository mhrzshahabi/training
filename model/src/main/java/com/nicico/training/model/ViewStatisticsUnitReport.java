
package com.nicico.training.model;

import com.nicico.training.model.compositeKey.ViewStatisticsUnitReportKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_statistics_unit_report")
public class ViewStatisticsUnitReport implements Serializable {

    @EmbeddedId
    private ViewStatisticsUnitReportKey id;

    //////////////////////Session - Attendance
    @Column(name = "session_session_date", insertable = false, updatable = false)
    private String sessionDate;

    @Column(name = "presence_hour")
    private Float presenceHour;

    @Column(name = "presence_minute")
    private Float presenceMinute;

    @Column(name = "absence_hour")
    private Float absenceHour;

    @Column(name = "absence_minute")
    private Float absenceMinute;
    //////////////////////////////////////////

    ///////////////////////Class
    @Column(name = "class_id", insertable = false, updatable = false)
    private Long classId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_c_teaching_type")
    private String classTeachingType;

    @Column(name = "class_year")
    private String classYear;

    @Column(name = "tclass_planner")
    private Long classPlanner;

    @Column(name = "tclass_supervisor")
    private Long classSupervisor;
    //////////////////////////////////////////

    //////////////////////////Course
    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "course_duration")
    private Long courseDuration;

    @Column(name = "course_theo_type")
    private String courseTheoType;

    @Column(name = "course_category_id")
    private Long categoryId;

    @Column(name = "course_sub_category_id")
    private Long subCategoryId;
    /////////////////////////////////////////

    ///////////////////////////Student
    @Column(name = "student_id", insertable = false, updatable = false)
    private long studentId;

    @Column(name = "student_emp_no")
    private String studentPersonnelNo2;

    @Column(name = "student_personnel_no")
    private String studentPersonnelNo;

    @Column(name = "student_national_code")
    private String studentNationalCode;

    @Column(name = "student_first_name")
    private String studentFirstName;

    @Column(name = "student_last_name")
    private String studentLastName;

    @Column(name = "student_ccp_assistant")
    private String studentCcpAssistant;

    @Column(name = "student_ccp_affairs")
    private String studentCcpAffairs;

    @Column(name = "student_ccp_section")
    private String studentCcpSection;

    @Column(name = "student_ccp_unit")
    private String studentCcpUnit;

    @Column(name = "class_student_applicant_company_name")
    private String classStudentApplicantCompanyName;

    @Column(name = "personnel_complex_title")
    private String personnelComplexTitle;

    @Column(name = "student_work_place_title")
    private String studentWorkPlaceTitle;

    @Column(name = "student_post_grade_title")
    private String studentPostGradeTitle;

    @Column(name = "student_job_title")
    private String studentJobTitle;
    /////////////////////////////////////////

    ///////////////////////////Teacher
    @Column(name = "teacher_FirstName")
    private String teacherFirstName;

    @Column(name = "teacher_LastName")
    private String teacherLastName;

    @Column(name = "course_teacher_status")
    private Long courseTeacherStatus;

    @Column(name = "course_teacher_id")
    private Long courseTeacherId;
    ////////////////////////////////////////

    ///////////////////////////Institute
    @Column(name = "institute_id")
    private Long instituteId;

    @Column(name = "institute_c_title_fa")
    private String instituteTitleFa;
    ///////////////////////////////////////

    ///////////////////////////Term
    @Column(name = "term_id")
    private Long termId;
    //////////////////////////////////////

    ///////////////////////////Evalution
    @Column(name = "evaluationanalysis_id", insertable = false, updatable = false)
    private Long evaluationAnalysisId;

    @Column(name = "EVALUATIONANALYSIS_C_BEHAVIORAL_GRADE")
    private String evaluationBehavioralGrade;

    @Column(name = "EVALUATIONANALYSIS_C_BEHAVIORAL_PASS")
    private Boolean evaluationBehavioralPass;

    @Column(name = "EVALUATIONANALYSIS_B_BEHAVIORAL_STATUS")
    private Boolean evaluationBehavioralStatus;

    @Column(name = "EVALUATIONANALYSIS_B_EFFECTIVENESS_STATUS")
    private Boolean evaluationEffectivenessStatus;

    @Column(name = "EVALUATIONANALYSIS_C_EFFECTIVENESS_GRADE")
    private String evaluationEffectivenessGrade;

    @Column(name = "EVALUATIONANALYSIS_C_EFFECTIVENESS_PASS")
    private Boolean evaluationEffectivenessPass;

    @Column(name = "EVALUATIONANALYSIS_C_LEARNING_GRADE")
    private String evaluationLearningGrade;

    @Column(name = "EVALUATIONANALYSIS_C_LEARNING_PASS")
    private Boolean evaluationLearningPass;

    @Column(name = "EVALUATIONANALYSIS_B_LEARNING_STATUS")
    private Boolean evaluationLearningStatus;

    @Column(name = "EVALUATIONANALYSIS_C_REACTION_GRADE")
    private String evaluationReactionGrade;

    @Column(name = "EVALUATIONANALYSIS_C_REACTION_PASS")
    private Boolean evaluationReactionPass;

    @Column(name = "EVALUATIONANALYSIS_B_REACTION_STATUS")
    private Boolean evaluationReactionStatus;

    @Column(name = "EVALUATIONANALYSIS_C_RESULTS_GRADE")
    private String evaluationResultsGrade;

    @Column(name = "EVALUATIONANALYSIS_C_RESULTS_PASS")
    private Boolean evaluationResultsPass;

    @Column(name = "EVALUATIONANALYSIS_B_RESULTS_STATUS")
    private Boolean evaluationResultsStatus;

    @Column(name = "EVALUATIONANALYSIS_C_TEACHER_GRADE")
    private String evaluationTeacherGrade;

    @Column(name = "EVALUATIONANALYSIS_C_TEACHER_PASS")
    private Boolean evaluationTeacherPass;

    @Column(name = "EVALUATIONANALYSIS_B_TEACHER_STATUS")
    private Boolean evaluationTeacherStatus;
    //////////////////////////////////////////
}
