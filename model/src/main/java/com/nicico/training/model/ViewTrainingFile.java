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
@Subselect("select * from view_training_file_report")
@DiscriminatorValue("ViewTrainingFile")
public class ViewTrainingFile implements Serializable {

    /////////////////////////////////////////////student////////////////////////////////////////////

    @Column(name = "emp_no")
    private String empNo;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "national_code")
    private String nationalCode;

    @Column(name = "post_title")
    private String postTitle;

    @Column(name = "post_code")
    private String postCode;

    @Column(name = "job_title")
    private String jobTitle;

    @Column(name = "post_grade_title")
    private String postGradeTitle;

    @Column(name = "ccp_affairs")
    private String affairs;

    ///////////////////////////////////////////////////term///////////////////////////////////////

    @Column(name = "term_title")
    private String termTitleFa;

    ///////////////////////////////////////////////////classStudent///////////////////////////////////////

    @Id
    @Column(name = "class_student_id")
    private Long classStudentId;

    @Column(name = "scores_state_id")
    private Long scoresState;

    @Column(name = "score")
    private Float score;

    ///////////////////////////////////////////////////class///////////////////////////////////////

    @Column(name = "class_status")
    private String classStatus;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_start_date")
    private String startDate;

    @Column(name = "class_end_date")
    private String endDate;

    ///////////////////////////////////////////////////course///////////////////////////////////////

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title")
    private String courseTitle;
}
