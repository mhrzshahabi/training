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
@Table(name = "tbl_bank_branch")
public class BankBranch extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "bank_branch_seq")
    @SequenceGenerator(name = "bank_branch_seq", sequenceName = "seq_bank_branch_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", nullable = false)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @ManyToOne
    @JoinColumn(name = "f_bank", insertable = false, updatable = false)
    private Bank bank;

    @Column(name = "f_bank")
    private Integer bankId;

    @ManyToOne
    @JoinColumn(name = "f_address", insertable = false, updatable = false)
    private Address address;

    @Column(name = "f_address")
    private Long addressId;
}
