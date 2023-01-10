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

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "student_first_name")
    private String studentFirstName;

    @Column(name = "student_last_name")
    private String studentLastName;

    @Column(name = "student_national_code")
    private String studentNationalCode;

    @Column(name = "student_complex")
    private String studentComplex;

    @Column(name = "student_assistant")
    private String studentAssistant;

    @Column(name = "student_affair")
    private String studentAffairs;

    @Column(name = "student_section")
    private String studentSection;

    @Column(name = "student_unit")
    private String studentUnit;

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

    @Column(name = "evaluation_field_id")
    private Long evaluationFieldId;

    @Column(name = "evaluation_field")
    private String evaluationField;

    @Column(name = "evaluation_field_average")
    private Double evaluationFieldAverage;

}
