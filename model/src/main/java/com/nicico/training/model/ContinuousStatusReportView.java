package com.nicico.training.model;

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

    @Id
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "EMP_NO")
    private String EmpNo;

    @Column(name = "PERSONNEL_NO")
    private String PersonnelNo;

    @Column(name = "NATIONAL_CODE")
    private String NationalCode;

    @Column(name = "FIRST_NAME")
    private String FirstName;

    @Column(name = "LAST_NAME")
    private String LastName;

    @Column(name = "C_CODE")
    private String ClassCode;

    @Column(name = "C_CODE1")
    private String CourseCode;

    @Column(name = "C_TITLE_FA")
    private Integer CourseTitle;

    @Column(name = "COMPLEX_TITLE")
    private String ComplexTitle;

    @Column(name = "COMPANY_NAME")
    private String CompanyName;

    @Column(name = "CCP_AREA")
    private String Area;

    @Column(name = "CCP_ASSISTANT")
    private String Assistant;

    @Column(name = "CCP_AFFAIRS")
    private Integer Affairs;

    @Column(name = "CCP_UNIT")
    private String Unit;

    @Column(name = "POST_TITLE")
    private String PostTitle;

    @Column(name = "POST_CODE")
    private String PostCode;

    @Column(name = "C_START_DATE", nullable = false)
    private String StartDate;

    @Column(name = "C_END_DATE", nullable = false)
    private String EndDate;

    @Column(name = "C_CODE2")
    private Long TermId;

    @Column(name = "YEAR")
    private String Year;

    @Column(name = "REGISTRY")
    private String RegistryState;

    @Column(name = "EVALUATIONSTATE")
    private String EvaluationState;

    @Column(name = "NA_PRIORITY_ID")
    private String EvaluationPriority;

    @Column(name = "C_STATUS")
    private String ClassStatus;

}
