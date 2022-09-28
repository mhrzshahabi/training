package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from VIEW_CLASSES_REACTIVEASSESSMENT_HASNOTREACHED_QUORUM_REPORT")
@DiscriminatorValue("classesReactiveAssessmentHasNotReachedQuorum")
public class ClassesReactiveAssessmentHasNotReachedQuorum implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "answered_reaction_eval_percent")
    private Integer reactionPercent;

    @Column(name = "reactive_limit")
    private Integer reactiveLimit;

    @Column(name = "mojtame_title")
    private String mojtameTitle;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title")
    private String courseTitle;

    @Column(name = "teacher_name")
    private String teacherName;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_duration")
    private Integer classDuration;

    @Column(name = "supervisor_name")
    private String supervisorName;

}
