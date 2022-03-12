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
@Subselect("select * from view_learning_evaluation_student_report")
@DiscriminatorValue("ViewLearningEvaluationStudentReport")
public class ViewLearningEvaluationStudentReport implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "class_code")
    private String class_code;

    @Column(name = "class_status")
    private String class_status;

    @Column(name = "class_start_date")
    private String startDate;

    @Column(name = "class_end_date")
    private String endDate;

    @Column(name = "course_code")
    private String course_code;

    @Column(name = "course_titlefa")
    private String course_titlefa;

    @Column(name = "category_titlefa")
    private String category_titlefa;

    @Column(name = "sub_category_titlefa")
    private String sub_category_titlefa;

    @Column(name = "sub_category_id")
    private Long sub_category_id;

    @Column(name = "complex")
    private String complex;

    @Column(name = "is_personnel")
    private String is_personnel;

    @Column(name = "teacher_national_code")
    private String teacher_national_code;

    @Column(name = "teacher")
    private String teacher;

    @Column(name = "total_std")
    private String total_std;

    @Column(name = "student")
    private String student;

    @Column(name = "student_national_code")
    private String student_per_number;

    @Column(name = "emp_no")
    private String emp_no;

    @Column(name = "personnel_no")
    private String personnel_no;

    @Column(name = "student_hoze")
    private String student_hoze;

    @Column(name = "student_omor")
    private String student_omor;

    @Column(name = "student_post_code")
    private String student_post_code;

    @Column(name = "student_post_title")
    private String student_post_title;

    @Column(name = "nore_pish")
    private String nore_pish;

    @Column(name = "nore_nahaii")
    private String nore_nahaii;

    @Column(name = "learning")
    private String learning;
}
