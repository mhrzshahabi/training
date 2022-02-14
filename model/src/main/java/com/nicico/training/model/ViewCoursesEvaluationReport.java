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
@Subselect("select * from VIEW_COURSES_EVALUATION_REPORT")
@DiscriminatorValue("ViewCoursesEvaluationReport")
public class ViewCoursesEvaluationReport implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_titlefa")
    private String courseTitleFa;

    @Column(name = "category_titlefa")
    private String categoryTitleFa;

    @Column(name = "sub_category_titlefa")
    private String subCategoryTitleFa;

    @Column(name = "sub_category_id")
    private Long subCategoryId;

    @Column(name = "class_student_status_reaction")
    private Integer classStudentStatusReaction;

    @Column(name = "evaluation_analysis_reaction_grade")
    private String evaluationAnalysisReactionGrade;

    @Column(name = "evaluation_analysis_reaction_pass")
    private String evaluationAnalysisReactionPass;

    @Column(name = "evaluation_analysis_teacher_grade")
    private String evaluationAnalysisTeacherGrade;

    @Column(name = "evaluation_analysis_teacher_pass")
    private String evaluationAnalysisTeacherPass;
}
