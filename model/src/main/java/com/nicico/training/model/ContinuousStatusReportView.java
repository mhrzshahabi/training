package com.nicico.training.model;

import com.nicico.training.model.compositeKey.PersonnelCourseKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("SELECT * VIEW_CONTINUOUS_STATUS_REPORT")

public class ContinuousStatusReportView {

//    @Id
//    @Column(name = "id", nullable = false)
//    private Long id;

    @EmbeddedId
    private PersonnelCourseKey id;

    @Column(name = "emp_no")
    private String empNo;

    @Column(name = "personnel_no")
    private String personnelNo;

    @Column(name = "national_code")
    private String nationalCode;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "c_code")
    private String classCode;

    @Column(name = "c_code1")
    private String courseCode;

    @Column(name = "c_title_fa")
    private Integer courseTitle;

    @Column(name = "complex_title")
    private String complexTitle;

    @Column(name = "company_name")
    private String companyName;

    @Column(name = "ccp_area")
    private String area;

    @Column(name = "ccp_assistant")
    private String assistant;

    @Column(name = "ccp_affairs")
    private Integer affairs;

    @Column(name = "ccp_unit")
    private String unit;

    @Column(name = "post_title")
    private String postTitle;

    @Column(name = "post_code")
    private String postCode;

    @Column(name = "c_start_date", nullable = false)
    private String startDate;

    @Column(name = "c_end_date", nullable = false)
    private String endDate;

    @Column(name = "c_code2")
    private Long termId;

    @Column(name = "year")
    private String year;

    @Column(name = "registry")
    private String registryState;

    @Column(name = "evaluationstate")
    private String evaluationState;

    @Column(name = "na_priority_id")
    private String evaluationPriority;

    @Column(name = "c_status")
    private String classStatus;

}
