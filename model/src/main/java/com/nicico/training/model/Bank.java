package com.nicico.training.model;

import com.nicico.training.model.enums.EBankType;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_bank")
public class Bank extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "bank_seq")
    @SequenceGenerator(name = "bank_seq", sequenceName = "seq_bank_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "e_bank_type", insertable = false, updatable = false)
    private EBankType eBankType;

    @Column(name = "e_bank_type")
    private Integer eBankTypeId;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "bank")
    private Set<BankBranch> bankBranchSet;
}
