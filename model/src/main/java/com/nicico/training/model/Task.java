package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.*;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"},callSuper = false)
@Entity
@Table(name = "tbl_task")
public class Task extends Auditable{

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Task_seq")
    @SequenceGenerator(name = "Task_seq", sequenceName = "seq_Task_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_title_En")
    private String titleEn;

    @Column(name = "c_task_description")
    private String taskDescription;


    @Column(name = "c_attach_photo")
    private String attachPhoto;
}
