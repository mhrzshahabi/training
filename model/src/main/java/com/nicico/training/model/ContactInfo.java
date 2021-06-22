package com.nicico.training.model;

import com.nicico.training.model.enums.EMobileForSMS;
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
@Table(name = "tbl_contact_info")

public class ContactInfo extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "contact_info_seq")
    @SequenceGenerator(name = "contact_info_seq", sequenceName = "seq_contact_info_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_email")
    private String email;

    @ManyToOne(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.REFRESH, CascadeType.MERGE})
    @JoinColumn(name = "f_home_address")
    private Address homeAddress;

    @Column(name = "f_home_address", insertable = false, updatable = false)
    private Long homeAddressId;

    @ManyToOne(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.REFRESH, CascadeType.MERGE})
    @JoinColumn(name = "f_work_address")
    private Address workAddress;

    @Column(name = "f_work_address", insertable = false, updatable = false)
    private Long workAddressId;

    @Column(name = "c_mobile")
    private String mobile;

    @Column(name = "c_personal_web_site")
    private String personalWebSite;

    @Column(name = "c_mdms_mobile")
    private String mdmsMobile;

    @Column(name = "c_hr_mobile")
    private String hrMobile;

    @Column(name = "c_mobile2")
    private String mobile2;

    @Column(name = "n_mobile_for_sms")
    private EMobileForSMS eMobileForSMS;

}
