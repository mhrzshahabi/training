package com.nicico.training.model;/*
com.nicico.training.model
@author : banifatemi
@Date : 5/28/2019
@Time :3:39 PM
    */

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"})
@Entity
@Table(name = "tbl_skill_type", schema = "TRAINING")

public class SkillType extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "skill_type_seq")
    @SequenceGenerator(name = "skill_type_seq", sequenceName = "seq_skill_type_id", allocationSize = 1)
    @Column(name = "id", precision = 0)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_desc", length = 500)
    private String description;
}
