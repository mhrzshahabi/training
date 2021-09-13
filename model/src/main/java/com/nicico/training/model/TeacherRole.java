package com.nicico.training.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;


@Setter
@Getter
@Entity
@Table(name = "tbl_teacher_roles")
public class TeacherRole {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_role_seq")
    @SequenceGenerator(name = "teacher_role_seq", sequenceName = "seq_teacher_role_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;


    @ManyToOne
    @JoinColumn(name = "TEACHER_ID")
    private Teacher teacher;

    @ManyToOne
    @JoinColumn(name = "ROLE_ID")
    private Role role;

}
