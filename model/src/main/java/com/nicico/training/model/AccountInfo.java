package com.nicico.training.model;

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
@Table(name = "tbl_account_info")
public class AccountInfo extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "account_info_seq")
    @SequenceGenerator(name = "account_info_seq", sequenceName = "seq_account_info_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_account_number")
    private String accountNumber;

    @Column(name = "c_bank")
    private String bank;

    @Column(name = "c_bank_branch")
    private String bbranch;

    @Column(name = "c_bank_branch_code")
    private Long bcode;

    @Column(name = "c_cart_number")
    private String cartNumber;

    @Column(name = "c_shaba_number")
    private String shabaNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_company_id", insertable = false, updatable = false)
    private Company company;

    @Column(name = "f_company_id")
    private Long companyId;

}
