package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;


@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_class_with_permission")
public class ViewClass {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "user_id")
    private Long user_id;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_class")
    private String titleClass;

    @Column(name = "c_start_date")
    private String startDate;

    @Column(name = "c_end_date")
    private String endDate;

    @Column(name = "c_student_count")
    private String studentCount;

    @Column(name = "n_group")
    private Long group;

    @Column(name = "c_teacher")
    private String teacher;

    @Column(name = "f_teacher")
    private Long teacherId;

    @Column(name = "c_planner")
    private String planner;

    @Column(name = "f_planner")
    private Long plannerId;

    @Column(name = "c_supervisor")
    private String supervisor;

    @Column(name = "c_organizer")
    private String organizer;

    @Column(name = "f_term")
    private Long termId;

    @Column(name = "c_topology")
    private String topology;

    @Column(name = "c_status")
    private String classStatus;

    @Column(name = "c_reason")
    private String reason;

    @Column(name = "c_workflow_ending_status")
    private String workflowEndingStatus;

    @Column(name = "f_course_category")
    private Long courseCategoryId;

    @Column(name = "b_class_to_online_status")
    private Boolean classToOnlineStatus;

    @Column(name = "c_cancel_class_reason")
    private String classCancelReason;

}
