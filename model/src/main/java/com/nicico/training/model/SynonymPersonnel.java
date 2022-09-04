package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_synonym_personnel")
@DiscriminatorValue("viewSynonymPersonnel")
public class SynonymPersonnel implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "personnel_no")
    private String personnelNo;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "father_name")
    private String fatherName;

    @Column(name = "birth_certificate_no")
    private String birthCertificateNo;

    @Column(name = "birth_date")
    private Date birthDate;

    @Column(name = "birth_place")
    private String birthPlace;

    @Column(name = "national_code")
    private String nationalCode;

    @Column(name = "employment_date")
    private Date employmentDate;

    @Column(name = "post_title")
    private String postTitle;

    @Column(name = "post_code")
    private String postCode;

    @Column(name = "work_place_title")
    private String workPlaceTitle;

    @Column(name = "education_level_title")
    private String educationLevelTitle;

    @Column(name = "job_title")
    private String jobTitle;

    @Column(name = "company_name")
    private String companyName;

    @Column(name = "education_field_title")
    private String educationMajorTitle;

    @Column(name = "gender_title")
    private String gender;

    @Column(name = "department_title")
    private String departmentTitle;

    @Column(name = "department_code")
    private String departmentCode;

    @Column(name = "emp_no")
    private String personnelNo2;

    @Column(name = "post_grade_title")
    private String postGradeTitle;

    @Column(name = "post_grade_code")
    private String postGradeCode;

    @Column(name = "ccp_code")
    private String ccpCode;

    @Column(name = "ccp_area")
    private String ccpArea;

    @Column(name = "ccp_assistant")
    private String ccpAssistant;

    @Column(name = "ccp_affairs")
    private String ccpAffairs;

    @Column(name = "ccp_section")
    private String ccpSection;

    @Column(name = "ccp_unit")
    private String ccpUnit;

    @Column(name = "ccp_title")
    private String ccpTitle;

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "p_type", length = 50)
    private String peopleType;

    @Column(name = "f_department_id")
    private Long departmentId;

    @Column(name = "f_geo_id")
    private Long geoWorkId;

    @Column(name = "f_post_id")
    private Long postId;

    @Column(name = "c_username")
    private String userName;

    @Column(name = "email")
    private String email;

    @Transient
    private String workYears;

    @Transient
    private Post post;

    @Transient
    private Department department;

    @Column(name = "employment_status_id")
    private Integer employmentStatusId;

    @Column(name = "employment_status_title")
    private String employmentStatus;

    @Column(name = "complex_title")
    private String complexTitle;
}