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
@Subselect("select * from VIEW_EVALUATION_INDEX_BY_FIELD_REPORT")
@DiscriminatorValue("VIEW_EVALUATION_INDEX_BY_FIELD_REPORT")
public class ViewEvaluationIndexByFieldReport implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "teacher_first_name")
    private String teacherFirstName;

    @Column(name = "teacher_last_name")
    private String teacherLastName;

    @Column(name = "teacher_national_code")
    private String teacherNationalCode;

    @Column(name = "evaluation_affair")
    private String evaluationAffairs;

    @Column(name = "post_title")
    private String postTitle;

    @Column(name = "post_code")
    private String postCode;

    @Column(name = "personnel_no2")
    private String personnelNo2;

    @Column(name = "student_acceptance_status")
    private String studentAcceptanceStatus;

    @Column(name = "score")
    private Double score;

    @Column(name = "evaluation_id")
    private Long evaluationId;

    @Column(name = "evaluation_average")
    private Double evaluationAverage;

    @Column(name = "evaluation_field")
    private String evaluationField;


}
