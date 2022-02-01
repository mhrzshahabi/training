package com.nicico.training.model;

import lombok.*;

import javax.persistence.*;
import java.sql.Timestamp;

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

    @Column(name = "VERIFY")
    private boolean verify = false;

    @Column(name = "CREATE_DATE")
    private Timestamp createDate;

    @Column(name = "VERIFIED_BY")
    private String verifiedBy;

    @PrePersist
    public void setCreateTime(){
        createDate=new Timestamp(System.currentTimeMillis());
    }
}
