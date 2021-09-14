package com.nicico.training.model;


import lombok.*;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tbl_mobile_verify")
public class MobileVerify {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "mobile_verify_seq")
    @SequenceGenerator(name = "mobile_verify_seq", sequenceName = "seq_mobile_verify_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "MOBILE_NUMBER")
    private String mobileNumber;

    @Column(name = "NATIONAL_CODE")
    private String nationalCode;

    @Column(name = "NAME")
    private String name;

    @Column(name = "FAMILY")
    private String family;

    @Column(name = "VERIFY")
    private boolean verify = false;
}
