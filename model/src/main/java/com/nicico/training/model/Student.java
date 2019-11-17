package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_student")
public class Student extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "student_seq")
    @SequenceGenerator(name = "student_seq", sequenceName = "seq_student_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private long id;

    @Column(name = "c_student_id", nullable = false)
    private String studentID;

    @Column(name = "c_full_name_fa", nullable = false)
    private String fullNameFa;

    @Column(name = "c_full_name_en", nullable = false)
    private String fullNameEn;

    @Column(name = "c_personal_id")
    private String personalID;

    @Column(name = "c_department")
    private String department;

    @Column(name = "c_license")
    private String license;

}
