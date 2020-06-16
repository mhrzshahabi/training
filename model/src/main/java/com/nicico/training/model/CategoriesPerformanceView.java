package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from categories_performance_view")
@DiscriminatorValue("CategoriesPerformanceView")
public class CategoriesPerformanceView extends Auditable{

    @Column(name = "C_INSTITUTE_TITLE")
    private String instituteTitle;

    @Column(name = "C_CATEGORY_TITLE")
    private String categoryTitle;

    @Column(name = "N_CLASS_STATE")
    private Integer classState;

    @Column(name = "N_SESSION_STATE")
    private Integer sessionState;

    @Column(name = "C_SESSION_START_HOUR")
    private Integer sessionStartHour;

    @Column(name = "C_SESSION_END_HOUR")
    private Integer sessionEndHour;

    @Column(name = "C_START_DATE")
    private Integer classStartDate;

    @Column(name = "C_END_DATE")
    private Integer classEndDate;

    @Column(name = "F_TERM")
    private String term;

    @Column(name = "F_INSTITUTE_ORGANIZER")
    private Integer instituteId;

    @Column(name = "F_COURSE")
    private Integer courseId;

    @Column(name = "F_CATEGORY")
    private Integer categoryId;

    @Column(name = "F_SUBCATEGORY")
    private Integer subCategoryId;
}
