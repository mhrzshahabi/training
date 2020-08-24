package com.nicico.training.model;

import com.nicico.training.model.compositeKey.ViewUnfinishedClassesReportKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_unfinished_classes_report")
public class ViewUnfinishedClassesReport implements Serializable {
    @EmbeddedId
    private ViewUnfinishedClassesReportKey id;

    @Column(name = "id", insertable = false, updatable = false)
    private Long classId;

    @Column(name = "f_course", insertable = false, updatable = false)
    private Long courseId;

    @Column(name = "student_id", insertable = false, updatable = false)
    private Long studentId;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "c_title_fa")
    private String courseName;

    @Column(name = "duration")
    private Long duration;

    @Column(name = "c_start_date")
    private String startDate;

    @Column(name = "c_end_date")
    private String endDate;

    @Column(name = "first_session")
    private String firstSession;

    @Column(name = "institutename")
    private String instituteName;

    @Column(name = "session_count")
    private Integer sessionCount;

    @Column(name = "held_sessions")
    private Integer heldSessions;

    @Column(name = "teacher")
    private String teacher;

    @Column(name = "national_code")
    private String nationalCode;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;
}
