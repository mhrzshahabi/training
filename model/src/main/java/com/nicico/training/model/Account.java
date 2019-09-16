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
@Table(name = "tbl_account")
public class Account extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "account_seq")
    @SequenceGenerator(name = "account_seq", sequenceName = "seq_account_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_account_number",length = 20)
    private String accountNumber;

    @Column(name = "c_cart_number",length = 20)
    private String cartNumber;

    @Column(name = "c_shaba_number",length = 100)
    private String shabaNumber;

    @Column(name = "c_account_owner_name",length = 255)
    private String accountOwnerName;

    @ManyToOne
    @JoinColumn(name = "c_bank",insertable = false,updatable = false)
    private Bank bank;

    @Column(name = "c_bank")
    private Long bankId;

    @ManyToOne
    @Column(name = "c_bank_branch",insertable = false,updatable = false)
    private BankBranch bankBranch;

    @Column(name = "c_bank_branch")
    private Long bankBranchId;

    @Column(name = "c_description")
    private Long description;


}
