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
@Subselect("select * from view_learning_evaluation_course_report")
@DiscriminatorValue("ViewLearningEvaluationFormulaReport")
public class ViewLearningEvaluationCourseReport implements Serializable {

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

    @Column(name = "miangin_pretest")
    private String miangin_pretest;

    @Column(name = "miangin_asli")
    private String miangin_asli;

    @Column(name = "nerkh")
    private String nerkh;

    @Column(name = "darsad_javab_dade_asli")
    private String darsad_javab_dade_asli;

    @Column(name = "darsad_javab_dade_pre")
    private String darsad_javab_dade_pre;

    @Column(name = "darsad_ghabol")
    private String darsad_ghabol;

    @Column(name = "darsad_noghabol")
    private String darsad_noghabol;

    @Column(name = "learning")
    private String learning;

    @Column(name = "max_nahaii")
    private String max_nahaii;

    @Column(name = "min_pre")
    private String min_pre;

    @Column(name = "pishraft")
    private String pishraft;
}
