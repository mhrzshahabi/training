package com.nicico.training.model;

import com.nicico.training.model.compositeKey.PresenceReportKey;
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
@Subselect("select * from view_presence_report")
public class PresenceReportView implements Serializable {

    @EmbeddedId
    private PresenceReportKey id;

    ///////////////////////////////////////////////////time///////////////////////////////////////
    @Column(name = "presence_hour")
    private Float presenceHour;

    @Column(name = "presence_minute")
    private Float presenceMinute;

    @Column(name = "absence_hour")
    private Float absenceHour;

    @Column(name = "absence_minute")
    private Float absenceMinute;

    ///////////////////////////////////////////////////class///////////////////////////////////////
    @Column(name = "class_id", insertable = false, updatable = false)
    private long classId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

//    @Column(name = "class_teaching_type")
//    private String classTeachingType;

    @Column(name = "holding_class_type_id")
    private String holdingClassTypeId;

    @Column(name = "holding_class_type_title")
    private String holdingClassTypeTitle;

    @Column(name = "teaching_method_id")
    private String teachingMethodId;

    @Column(name = "teaching_method_title")
    private String teachingMethodTitle;
    ///////////////////////////////////////////////////session///////////////////////////////////////
    @Column(name = "session_session_date", insertable = false, updatable = false)
    private String sessionDate;

    ///////////////////////////////////////////////////student///////////////////////////////////////
    @Column(name = "student_id", insertable = false, updatable = false)
    private Long studentId;

    @Column(name = "student_personnel_no")
    private String studentPersonnelNo;

    @Column(name = "student_emp_no")
    private String studentPersonnelNo2;

    @Column(name = "student_first_name")
    private String studentFirstName;

    @Column(name = "student_last_name")
    private String studentLastName;

    @Column(name = "student_national_code")
    private String studentNationalCode;

    @Column(name = "student_ccp_assistant")
    private String studentCcpAssistant;

    @Column(name = "student_ccp_affairs")
    private String studentCcpAffairs;

    @Column(name = "student_ccp_section")
    private String studentCcpSection;

    @Column(name = "student_ccp_unit")
    private String studentCcpUnit;

    ///////////////////////////////////////////////////classStudent///////////////////////////////////////
    @Column(name = "class_student_applicant_company_name")
    private String classStudentApplicantCompanyName;

    ///////////////////////////////////////////////////personnel/////////////////////////////////////////
    @Column(name = "personnel_complex_title")
    private String personnelComplexTitle;

    ///////////////////////////////////////////////////course/////////////////////////////////////////////
    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "course_category_id")
    private Long categoryId;

    @Column(name = "course_run_type")
    private String courseRunType;

    @Column(name = "course_theo_type")
    private String courseTheoType;

    @Column(name = "course_level_type")
    private String courseLevelType;

    @Column(name = "course_technical_type")
    private String courseTechnicalType;

    ///////////////////////////////////////////////////institute///////////////////////////////////////
    @Column(name = "institute_id")
    private Long instituteId;

    @Column(name = "institute_c_title_fa")
    private String instituteTitleFa;
}
