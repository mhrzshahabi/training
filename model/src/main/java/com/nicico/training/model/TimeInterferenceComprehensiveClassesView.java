package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;


import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_time_interference_comprehensive_classes_report")
@DiscriminatorValue("viewTimeInterferenceComprehensiveClassesReport")
public class TimeInterferenceComprehensiveClassesView implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "count_time_interference")
    private String countTimeInterference;

    @Column(name = "student_full_name")
    private String studentFullName;

    @Column(name = "national_code")
    private String nationalCode;

    @Column(name = "student_work_code")
    private String studentWorkCode;

    @Column(name = "student_affairs")
    private String studentAffairs;

    @Column(name = "concurrent_courses")
    private String concurrentCourses;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "adding_user")
    private String addingUser;

    @Column(name = "last_modified_by")
    private String lastModifiedBy;

    @Column(name = "session_date")
    private String sessionDate;
    @Column(name = "session_start_hour")
    private String sessionStartHour;
    @Column(name = "session_end_hour")
    private String sessionEndHour;

    @Column(name = "session_id")
    private Long session_id;

    @Column(name = "student_id")
    private Long student_id;

    @Column(name = "class_student_d_created_date")
    private String class_student_d_created_date;

    @Column(name = "class_student_d_last_modified_date")
    private String class_student_d_last_modified_date;
}

