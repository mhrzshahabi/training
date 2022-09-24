package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;
import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;

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

    @Column(name = "hadebesab_vakoneshi")
    private Integer hadebesabVakoneshi;

    @Column(name = "mojtame_title")
    private String mojtameTitle;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title")
    private String courseTitle;

    @Column(name = "teacher_Name")
    private String teacherName;

    @Column(name = "class_StartDate")
    private String classStartDate;

    @Column(name = "class_EndDate")
    private String classEndDate;

    @Column(name = "class_Duration")
    private Integer classDuration;

    @Column(name = "supervisor_Name")
    private String supervisorName;

}
