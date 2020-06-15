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
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_institute", nullable = false)
    private String institute;

    @Column(name = "f_planing_classes", nullable = false)
    private Integer planingClasses;

    @Column(name = "f_processing_classes")
    private Integer processingClasses;

    @Column(name = "f_ended_classes")
    private Integer endedClasses;

    @Column(name = "f_finished_classes")
    private Integer finishedClasses;

    @Column(name = "f_present_students")
    private Integer presentStudents;

    @Column(name = "f_overtimed_students")
    private Integer overtimedStudents;

    @Column(name = "f_f_absence_students")
    private Integer absentStudents;

    @Column(name = "f_unjustified_students")
    private Integer unjustifiedStudents;
}
