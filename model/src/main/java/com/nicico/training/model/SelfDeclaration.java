package com.nicico.training.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.sql.Timestamp;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tbl_self_declaration")
public class SelfDeclaration {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "self_declaration_seq")
    @SequenceGenerator(name = "self_declaration_seq", sequenceName = "self_declaration_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "MOBILE_NUMBER")
    private String mobileNumber;

    @Column(name = "NATIONAL_CODE")
    private String nationalCode;

    @Column(name = "CREATE_DATE")
    private Timestamp createDate;

    @PrePersist
    public void setCreateTime(){
        createDate=new Timestamp(System.currentTimeMillis());
    }
}
