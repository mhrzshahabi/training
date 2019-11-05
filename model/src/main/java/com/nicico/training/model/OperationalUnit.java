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
@Table(name = "tbl_operational_unit")
public class OperationalUnit extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "operational_unit_seq")
    @SequenceGenerator(name = "operational_unit_seq", sequenceName = "seq_operational_unit_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_unitcode")
    private String unitCode;

    @Column(name="c_operational_unit")
    private String operationalUnit;
}
