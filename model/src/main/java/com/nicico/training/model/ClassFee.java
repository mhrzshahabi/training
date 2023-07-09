package com.nicico.training.model;

import com.nicico.training.model.enums.ClassFeeStatus;
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
@Table(name = "tbl_class_fee")
public class ClassFee extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_fee_seq")
    @SequenceGenerator(name = "class_fee_seq", sequenceName = "seq_class_fee_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_date", nullable = false)
    private String date;

    @Column(name = "f_class_id")
    private Long classId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "c_class_title")
    private String classTitle;

    @Column(name = "complex_id", nullable = false)
    private Long complexId;

    @Column(name = "class_fee_status")
    private ClassFeeStatus classFeeStatus;

}
