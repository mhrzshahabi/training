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
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Company_seq")
    @SequenceGenerator(name = "Company_seq", sequenceName = "seq_Company_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_email")
    private String email;

    @Column(name = "c_work_domain")
    private String workDomain;


    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "f_account_info_id")
    private AccountInfo accountInfo;
    @Column(name = "f_account_info_id", nullable = false, insertable = false, updatable = false)
    private Long accountInfoId;

    @OneToOne(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.REFRESH, CascadeType.MERGE})
    @JoinColumn(name = "f_personal_info_id")
    private PersonalInfo manager;
    @Column(name = "f_personal_info_id", nullable = false, insertable = false, updatable = false)
    private Long managerId;

    @OneToOne(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.REFRESH, CascadeType.MERGE})
    @JoinColumn(name = "f_address_id")
    private Address address;
    @Column(name = "f_address_id", nullable = false, insertable = false, updatable = false)
    private Long addressId;
}


