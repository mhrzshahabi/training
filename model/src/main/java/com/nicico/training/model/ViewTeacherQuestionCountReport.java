package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
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
@Subselect("select * from VIEW_TEACHER_QUESTION_COUNT_REPORT")
public class ViewTeacherQuestionCountReport implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_title")
    private String courseTitle;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "teacher_id")
    private Long teacherId;

    @Column(name = "teacher_code")
    private String teacherCode;

    @Column(name = "teacher_first_name")
    private String teacherFirstName;

    @Column(name = "teacher_last_name")
    private String teacherLastName;

    @Column(name = "teacher_national_code")
    private String teacherNationalCode;

    @Column(name = "year_of_question")
    private Long yearOfQuestion;

    @Column(name = "question_count")
    private Long questionCount;

}
