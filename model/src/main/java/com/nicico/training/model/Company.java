package com.nicico.training.model;

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
@Table(name = "tbl_company")
public class Company extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "Company_seq")
    @SequenceGenerator(name = "Company_seq", sequenceName = "seq_Company_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name="c_address")
    private String address;

    @Column(name="c_work_domain")
    private String workDomain;

    @OneToMany(mappedBy = "company")
    private Set<AccountInfo> accountInfoSet;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_personal_info_id", nullable = false, insertable = false, updatable = false)
    private PersonalInfo manager;

    @Column(name = "f_personal_info_id")
    private Long managerId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="f_contact_info_id",nullable = false,insertable = false,updatable = false)
    private ContactInfo contactInfo;

    @Column(name="f_contact_info_id")
    private Long contactInfoId;

}


