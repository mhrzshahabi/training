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

    @Column(name = "class_code")
    private String class_code;
    @Column(name = "class_status")
    private String class_status;
    @Column(name = "class_start_date")
    private String class_start_date;
    @Column(name = "class_end_date")
    private String class_end_date;
    @Column(name = "course_code")
    private String course_code;
    @Column(name = "course_titlefa")
    private String course_titlefa;
    @Column(name = "category_titlefa")
    private String category_titlefa;
    @Column(name = "sub_category_titlefa")
    private String sub_category_titlefa;
    @Column(name = "class_id")
    private String class_id;
    @Column(name = "course_id")
    private String course_id;
    @Column(name = "complex")
    private String complex;
    @Column(name = "is_personnel")
    private String is_personnel;
    @Column(name = "teacher_national_code")
    private String teacher_national_code;
    @Column(name = "teacher")
    private String teacher;
    @Column(name = "student")
    private String student;
    @Column(name = "student_per_number")
    private String student_per_number;
    @Column(name = "student_hoze")
    private String student_hoze;
    @Column(name = "student_omor")
    private String student_omor;
    @Column(name = "student_post_code")
    private String student_post_code;
    @Column(name = "student_post_title")
    private String student_post_title;
    @Column(name = "final_teacher")
    private String final_teacher;
    @Column(name = "reactione_evaluation_grade")
    private String reactione_evaluation_grade;
    @Column(name = "teacher_grade_to_class")
    private String teacher_grade_to_class;
    @Column(name = "training_grade_to_teacher")
    private String training_grade_to_teacher;
    @Column(name = "total_std")
    private String total_std;
}
