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
@Subselect("select * VIEW_CONTINUOUS_STATUS_REPORT")

public class ContinuousStatusReportView {

    @Id
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "")
    private String EmpNo;

    @Column(name = "")
    private String PersonnelNo;

    @Column(name = "")
    private String NationalCode;

    @Column(name = "")
    private String FirstName;

    @Column(name = "")
    private String LastName;

    @Column(name = "")
    private String ClassCode;

    @Column(name = "")
    private String CourseCode;

    @Column(name = "")
    private Integer CourseTitle;

    @Column(name = "")
    private String ComplexTitle;

    @Column(name = "")
    private String CompanyName;

    @Column(name = "")
    private String Area;

    @Column(name = "")
    private String Assistant;

    @Column(name = "")
    private Integer Affairs;

    @Column(name = "")
    private String Unit;

    @Column(name = "")
    private String PostTitle;

    @Column(name = "")
    private String PostCode;

    @Column(name = "", nullable = false)
    private String StartDate;

    @Column(name = "", nullable = false)
    private String EndDate;

    @Column(name = "")
    private Long TermId;

    @Column(name = "")
    private String Year;

    @Column(name = "")
    private String RegestryState;

    @Column(name = "")
    private String EvaluationState;

    @Column(name = "")
    private String EvaluationPriority;

    @Column(name = "")
    private String ClassStatus;

}
