package com.nicico.training.model;/*
com.nicico.training.model
@author : banifatemi
@Date : 5/28/2019
@Time :3:32 PM
    */

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"})
@Entity
@Table(name = "tbl_category", schema = "TRAINING")

public class Category extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "category_seq")
    @SequenceGenerator(name = "category_seq", sequenceName = "seq_category_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_code", length = 2, nullable = false,unique = true)
    private String code;

    @Column(name = "c_desc")
    private String description;

    @OneToMany(mappedBy = "category")
    private Set<SubCategory> subCategorySet;


}
