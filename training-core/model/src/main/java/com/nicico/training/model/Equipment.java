package com.nicico.training.model;
/* com.nicico.training.model
@Author:jafari-h
@Date:5/28/2019
@Time:11:13 AM
*/

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_equipment", schema = "TRAINING")
public class Equipment extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Equipment_seq")
    @SequenceGenerator(name = "Equipment_seq", sequenceName = "seq_Equipment_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", length = 255, nullable = false)
    private String titleFa;

    @Column(name = "c_title_en", length = 255, nullable = false)
    private String titleEn;

    @Column(name = "c_description", length = 255, nullable = false)
    private String description;

    @Column(name = "c_code", length = 255, nullable = false)
    private String code;
}
