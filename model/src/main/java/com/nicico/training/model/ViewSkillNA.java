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
@Subselect("select * from view_skill_na")
@DiscriminatorValue("ViewSkillNA")
public class ViewSkillNA {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "object_type")
    private String objectType;

    @Column(name = "object_id")
    private Long objectId;

    @Column(name = "object_code")
    private String objectCode;

    @Column(name = "object_name")
    private String objectName;

    @Column(name = "object_people_type")
    private String peopleType;

    @Column(name = "object_enabled")
    private Long enabled;

    @Column(name = "skill_id")
    private Long skillId;

    @Column(name = "skill_code")
    private String skillCode;

    @Column(name = "skill_title_fa")
    private String skillTitleFa;

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "course_code")
    private String courseCode;

    @Column(name = "course_title_fa")
    private String courseTitleFa;

    @Column(name = "post_cpp_affairs")
    private String affairs;

    @Column(name = "post_cpp_area")
    private String area;

    @Column(name = "post_cpp_assistant")
    private String assistance;

    @Column(name = "post_cpp_section")
    private String section;

    @Column(name = "post_cpp_title")
    private String departmentTitle;

    @Column(name = "post_cpp_unit")
    private String unit;

    @Column(name = "post_complex_title")
    private String complexTitle;

    @Column(name = "post_department_id")
    private Long departmentId;
}