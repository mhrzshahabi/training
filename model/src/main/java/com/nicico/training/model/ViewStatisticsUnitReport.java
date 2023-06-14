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

    ///////////////////////Class
    @Column(name = "class_id", insertable = false, updatable = false)
    private Long classId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_creator")
    private String classCreator;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_c_teaching_type")
    private String classTeachingType;

    @Column(name = "class_reason")
    private String classReason;

    @Column(name = "class_target_population_type_id")
    private Long classTargetPopulationTypeId;

    @Column(name = "class_holding_class_type_id")
    private Long classHoldingClassTypeId;

    @Column(name = "class_year")
    private String classYear;

    @Column(name = "tclass_planner")
    private Long classPlanner;

    @Column(name = "tclass_supervisor")
    private Long classSupervisor;

    //////////////////////////Course
    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "course_e_technical_type")
    private String courseETechnicalType;

    @Column(name = "course_duration")
    private Long courseDuration;

    @Column(name = "course_theo_type")
    private String courseTheoType;

    @Column(name = "coursecategory")
    private Long courseCategory;

    @Column(name = "coursesubcategory")
    private Long courseSubCategory;

    ///////////////////////////Student
    @Column(name = "student_id", insertable = false, updatable = false)
    private Long studentId;

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

    ///////////////////////////Teacher
    @Column(name = "teacher_firstname")
    private String teacherFirstName;

    @Column(name = "teacher_lastname")
    private String teacherLastName;

    @Column(name = "course_teacher_status")
    private Long courseTeacherStatus;

    @Column(name = "course_teacher_id")
    private Long courseTeacherId;

    ///////////////////////////Institute
    @Column(name = "institute_id")
    private Long instituteId;

    @Column(name = "institute_c_title_fa")
    private String instituteTitleFa;

    ///////////////////////////Term
    @Column(name = "term_id")
    private Long termId;

    ///////////////////////////Evalution
    @Column(name = "evaluationanalysis_c_behavioral_grade")
    private String evaluationBehavioralGrade;

    @Column(name = "evaluationanalysis_c_behavioral_pass")
    private Boolean evaluationBehavioralPass;

    @Column(name = "evaluationanalysis_b_behavioral_status")
    private Boolean evaluationBehavioralStatus;

    @Column(name = "evaluationanalysis_c_effectiveness_grade")
    private String evaluationEffectivenessGrade;

    @Column(name = "evaluationanalysis_c_effectiveness_pass")
    private Boolean evaluationEffectivenessPass;

    @Column(name = "evaluationanalysis_b_effectiveness_status")
    private Boolean evaluationEffectivenessStatus;

    @Column(name = "evaluationanalysis_c_learning_grade")
    private String evaluationLearningGrade;

    @Column(name = "evaluationanalysis_c_learning_pass")
    private Long evaluationLearningPass;

    @Column(name = "evaluationanalysis_b_learning_status")
    private Long evaluationLearningStatus;

    @Column(name = "evaluationanalysis_c_reaction_grade")
    private String evaluationReactionGrade;

    @Column(name = "evaluationanalysis_c_reaction_pass")
    private Boolean evaluationReactionPass;

    @Column(name = "evaluationanalysis_b_reaction_status")
    private Boolean evaluationReactionStatus;

    @Column(name = "evaluationanalysis_c_results_grade")
    private String evaluationResultsGrade;

    @Column(name = "evaluationanalysis_c_results_pass")
    private Boolean evaluationResultsPass;

    @Column(name = "evaluationanalysis_b_results_status")
    private Boolean evaluationResultsStatus;

    @Column(name = "evaluationanalysis_c_teacher_grade")
    private String evaluationTeacherGrade;

    @Column(name = "evaluationanalysis_c_teacher_pass")
    private Boolean evaluationTeacherPass;

    @Column(name = "evaluationanalysis_b_teacher_status")
    private Boolean evaluationTeacherStatus;

    @Column(name = "teaching_method_title")
    private String teachingMethodTitle;

    @Column(name = "ANSWERED_REACTION_EVAL_PERCENT")
    private String answeredReactionEvalPercent;

    @Column(name = "ANSWERED_BEHAVIORAL_EVAL_PERCENT")
    private String answeredBehavioralEvalPercent;

    @Column(name = "class_student_score")
    private String classStudentScore;

    @Column(name = "status")
    private String status;

}
