package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_fms")
public class FmsFiles extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "fms_seq")
    @SequenceGenerator(name = "fms_seq", sequenceName = "seq_fms_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @NotNull
    @Column(name = "group_id")
    private String group_id;

    @NotNull
    @Column(name = "key")
    private String key;

    @Column(name = "class_id")
    private Long classId;

    @Column(name = "type")
    private String type;

}
