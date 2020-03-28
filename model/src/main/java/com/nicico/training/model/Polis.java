package com.nicico.training.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"},callSuper = false)
@Entity
@Table(name = "tbl_polis")
public class Polis extends Auditable{

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE,generator = "polis_seq")
    @SequenceGenerator(name = "polis_seq",sequenceName = "seq_polis_id",allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_name_fa", nullable = false)
    private String nameFa;

    @Column(name = "f_province_id")
    private Long provinceId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_province_id",insertable = false,updatable = false)
    private Province province;
}
