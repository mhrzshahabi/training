package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_calender_of_main_goals")
public class ViewCalenderOfMainGoals {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "ahdafasli")
    private String mainGoal;

    @Column(name="calender_id")
    private Long calenderId;

    @Column(name="c_code")
    private String classCode;




}
