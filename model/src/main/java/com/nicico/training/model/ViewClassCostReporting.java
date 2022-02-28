package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_class_cost_reporting")
@DiscriminatorValue("viewClassCostReporting")
public class ViewClassCostReporting {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "C_ACCEPTANCE_LIMIT")
    private String acceptanceLimit;

    @Column(name = "CLASS_STATUS")
    private String classStatus;


    @Column(name = "c_code", insertable = false, updatable = false)
    private String classCode;



    @Column(name = "C_START_DATE")
    private String startDate;

    @Column(name = "C_END_DATE")
    private String endDate;

    @Column(name = "C_TITLE_CLASS")
    private String classTitle;


    @Column(name = "C_STUDENT_COST")
    private String studentCost;

    @Column(name = "F_STUDENT_COST_CURRENCY")
    private String currency;

    @Column(name = "C_CODE1")
    private String courseCode;


    @Column(name = "C_TITLE_FA")
    private String courseTitle;


    @Column(name = "TEACHER_FULLNAME")
    private String teacher;


    @Column(name = "C_NATIONAL_CODE")
    private String teacherNationalCode;


    @Column(name = "COMPLEX")
    private String complex;

    @Column(name = "IS_PERSONNEL")
    private String isPersonnel;

    @Column(name = "TOTAL_STD")
    private String totalStudent;

    @Column(name = "HAZINE")
    private String cost;

    @Column(name = "moavenat")
    private String moavenat;


    @Column(name = "omor")
    private String omor;


}