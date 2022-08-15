package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_educational_decision")
public class EducationalDecision extends Auditable{

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "educational_decision_seq")
    @SequenceGenerator(name = "educational_decision_seq", sequenceName = "seq_educational_decision_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "ref")
    private String ref;

    @Column(name = "item_from_date")
    private String itemFromDate;

    @Column(name = "item_to_date")
    private String itemToDate;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_educational_decision_header", insertable = false, updatable = false)
    private EducationalDecisionHeader educationalDecisionHeader;

    @Column(name = "f_educational_decision_header")
    private Long educationalDecisionHeaderId;

    // Educational_history fields

    @Column(name = "educational_history_coefficient")
    private Double educationalHistoryCoefficient;

    @Column(name = "Educational_history_from")
    private String educationalHistoryFrom;

    @Column(name = "Educational_history_to")
    private String educationalHistoryTo;

    // Basic tuition fee fields

    @Column(name = "base_tuition_fee")
    private String baseTuitionFee;

    @Column(name = "professor_tuition_fee")
    private String professorTuitionFee;

    @Column(name = "knowledge_assistant_tuition_fee")
    private String knowledgeAssistantTuitionFee;

    @Column(name = "teacher_assistant_tuition_fee")
    private String teacherAssistantTuitionFee;

    @Column(name = "instructor_tuition_fee")
    private String instructorTuitionFee;

    @Column(name = "educational_assistant_tuition_fee")
    private String educationalAssistantTuitionFee;

    //teaching Method

    @Column(name = "teaching_method")
    private String teachingMethod;

    @Column(name = "course_type_teaching_method")
    private String courseTypeTeachingMethod;

    @Column(name = "coefficient_of_teaching_method")
    private String coefficientOfTeachingMethod;

    //course type

    @Column(name = "type_of_specialization_course_type")
    private String typeOfSpecializationCourseType;

    @Column(name = "course_level_course_type")
    private String courseLevelCourseType;

    @Column(name = "course_for_course_type")
    private String courseForCourseType;

    @Column(name = "coefficient_of_course_type")
    private String coefficientOfCourseType;

    //distance

    @Column(name = "distance")
    private String distance;

    @Column(name = "residence")
    private String residence;

}
