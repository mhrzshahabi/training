package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_fee_item")
public class FeeItem extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "fee_item_seq")
    @SequenceGenerator(name = "fee_item_seq", sequenceName = "seq_fee_item_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title", nullable = false)
    private String title;

    @Column(name = "n_cost", nullable = false)
    private Double cost;

    @Column(name = "f_class_id")
    private Long classId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", insertable = false, updatable = false)
    private Tclass tclass;


}
