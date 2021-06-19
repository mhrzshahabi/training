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
@Subselect("select * from view_reaction_evaluation_formula_report")
@DiscriminatorValue("ViewCoursesEvaluationReport")
public class ViewReactionEvaluationFormulaReport implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "class_id")
    private Long classId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_titlefa")
    private String courseTitleFa;

    @Column(name = "category_titlefa")
    private String categoryTitleFa;

    @Column(name = "sub_category_titlefa")
    private String subCategoryTitleFa;

}
