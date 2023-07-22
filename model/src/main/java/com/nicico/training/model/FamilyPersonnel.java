package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_family_list")
@DiscriminatorValue("viewFamilyList")
public class FamilyPersonnel implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_national_code")
    private String familyNationalCode;


    @Column(name = "c_first_name")
    private String familyFirstName;


    @Column(name = "c_last_name")
    private String familyLastName;


    @Column(name = "c_father_name")
    private String familyFatherName;

    @Column(name = "c_mobile")
    private String familyMobile;

    @Column(name = "gen_desc")
    private String familyGen;

    @Column(name = "a_c_national_code")
    private String personnelNationalCode;


    @Column(name = "a_c_first_name")
    private String personnelFirstName;


    @Column(name = "a_c_last_name")
    private String personnelLastName;


    @Column(name = "a_c_father_name")
    private String personnelFatherName;


}