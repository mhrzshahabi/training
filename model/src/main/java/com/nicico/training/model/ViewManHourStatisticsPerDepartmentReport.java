
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
@Subselect("select * from view_man_hour_statistics_per_department_report ")
public class ViewManHourStatisticsPerDepartmentReport implements Serializable {

    @EmbeddedId
    private ViewStatisticsUnitReportKey id;

    //////////////////////Session - Attendance
    @Column(name = "session_session_date", insertable = false, updatable = false)
    private String sessionDate;

    @Column(name = "presence_man_hour")
    private Float presenceManHour;


    @Column(name = "absence_man_hour")
    private Float absenceManHour;

    @Column(name = "present_student_numbers")
    private Long presentStudentNumbers;

    @Column(name = "absent_student_numbers")
    private Long absentStudentNumbers;

    @Column(name = "participation_percentage")
    private Float participationPercentage;

    @Column(name = "per_capita")
    private Float PerCapita;



    /////////////////////////////////////////

    ///////////////////////////department

    @Column(name = "applicant_company_name")
    private String applicantCompanyName;

    @Column(name = "complex_title")
    private String complexTitle;

    @Column(name = "ccp_assistant")
    private String ccpAssistant;

    @Column(name = "ccp_affairs")
    private String ccpAffairs;

    ///////////////////////////Term
    @Column(name = "term_id")
    private Long termId;

}
