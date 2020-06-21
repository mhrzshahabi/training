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
@Table(name = "tbl_equipment")
public class Equipment extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "equipment_seq")
    @SequenceGenerator(name = "equipment_seq", sequenceName = "seq_equipment_id", allocationSize = 1)
    @Column(name = "id")
    private Long id;

    @Column(name = "c_code", length = 10)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_description", length = 500)
    private String description;

}
