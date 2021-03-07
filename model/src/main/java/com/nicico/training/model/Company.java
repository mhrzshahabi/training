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
@Table(name = "tbl_company")
public class Company extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "company_seq")
    @SequenceGenerator(name = "company_seq", sequenceName = "seq_company_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_email")
    private String email;

    @Column(name = "c_work_domain")
    private String workDomain;

    @Column(name = "c_company_id", length = 12)
    private String companyId;

    @Column(name = "c_economical_id", length = 12)
    private String economicalId;

    @Column(name = "c_register_id", length = 12)
    private String registerId;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "f_account_info_id")
    private AccountInfo accountInfo;
    @Column(name = "f_account_info_id", insertable = false, updatable = false)
    private Long accountInfoId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_personal_info_id", insertable = false, updatable = false)
    private PersonalInfo manager;

    @Column(name = "f_personal_info_id")
    private Long managerId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_address_id",insertable = false, updatable = false)
    private Address address;
    @Column(name = "f_address_id")
    private Long addressId;
}


