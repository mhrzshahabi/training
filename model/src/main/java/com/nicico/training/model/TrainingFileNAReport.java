
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
@Subselect("select * from view_training_file_na_report")
public class TrainingFileNAReport implements Serializable {

    @Id
    private Long id;

    ///////////////////////////////////////////////////na/////////////////////////////////////////////

    @Column(name = "na_priority_id")
    private Long priorityId;

    @Column(name = "na_priority_title")
    private String priority;

    @Column(name = "is_in_na")
    private Boolean isInNA;

    ///////////////////////////////////////////////////personnel///////////////////////////////////////

    @Column(name = "personnel_id")
    private long personnelId;

    ///////////////////////////////////////////////////course///////////////////////////////////////

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "course_theory_duration")
    private Float theoryDuration;

    @Column(name = "course_technical_type")
    private Integer technicalType;

    ///////////////////////////////////////////////////skill///////////////////////////////////////

    @Column(name = "skill_id")
    private Long skillId;

    @Column(name = "skill_code")
    private String skillCode;

    @Column(name = "skill_title_fa")
    private String skillTitleFa;

    ///////////////////////////////////////////////////class///////////////////////////////////////

    @Column(name = "class_id")
    private Long classId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_start_date")
    private String classStartDate;

    @Column(name = "class_end_date")
    private String classEndDate;

    @Column(name = "class_location")
    private String location;

    ///////////////////////////////////////////////////class-student///////////////////////////////////////

    @Column(name = "class_student_score")
    private Float score;

    @Column(name = "class_student_scores_state_id")
    private Long scoreStateId;

    @Column(name = "class_student_scores_state_title")
    private String scoreState;
}
