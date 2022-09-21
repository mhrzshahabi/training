package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_calendar_prerequisite")
@DiscriminatorValue("viewCalenderPrerequisite")
public class ViewCalenderPrerequisite {
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "pishniaz")
    private String prerequisite;

    @Column(name="calendar_id")
    private Long calenderId;

    @Column(name="c_code")
    private String classCode;

    @Column(name = "course_name")
    private String courseName;

    @Column(name = "course_code")
    private String courseCode;

}
