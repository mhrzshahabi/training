package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;


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
@Subselect("select * from view_timeInterference-comprehensive-classes-report")
public class TimeInterferenceComprehensiveClassesView implements Serializable {

    private Long id;

    private Integer count_TimeInterference;
    private String studentFullName;
    private String nationalCode;
    private String studentWorkCode;
    private String studentAffairs;
    private String concurrentCourses;
    private String classCode;
    private String addingUser;
    private String lastModifiedBy;
    private String sessionDate;
    private String sessionStartHour;
    private String sessionEndHour;

    private Long session_id;
    private Long student_id;
    private String class_student_d_created_date;
    private String class_student_d_last_modified_date;


    public void setId(Long id) {
        this.id = id;
    }

    @Id
    public Long getId() {
        return id;
    }
}
