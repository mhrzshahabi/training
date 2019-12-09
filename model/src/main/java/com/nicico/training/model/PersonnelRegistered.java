package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_personnel_registered")
public class PersonnelRegistered extends Auditable {



    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_personnel_registered_id")
    @SequenceGenerator(name = "seq_personnel_registered_id", sequenceName = "seq_personnel_registered_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private long id;


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
    private String birthDate;

    @Column(name = "age")
    private Integer age;

    @Column(name = "birth_place")
    private String birthPlace;

    @Column(name = "national_code")
    private String nationalCode;

    @Column(name = "active")
    private Integer active;

    @Column(name = "deleted")
    private Integer deleted;

    @Column(name = "employment_date")
    private String employmentDate;

    @Column(name = "post_title")
    private String postTitle;

    @Column(name = "post_code")
    private String postCode;

    @Column(name = "post_assignment_date")
    private String postAssignmentDate;

    @Column(name = "complex_title")
    private String complex;

    @Column(name = "operational_unit_title")
    private String operationalUnit;

    @Column(name = "employment_type_title")
    private String employmentType;

    @Column(name = "marital_status_title")
    private String maritalStatus;

    @Column(name = "work_place_title")
    private String workPlace;

    @Column(name = "work_turn_title")
    private String workTurn;

    @Column(name = "education_level_title")
    private String educationLevel;

    @Column(name = "job_no")
    private String jobNo;

    @Column(name = "job_title")
    private String jobTitle;

    @Column(name = "employment_status_id")
    private Integer employmentStatusId;

    @Column(name = "employment_status_title")
    private String employmentStatus;

    @Column(name = "company_name")
    private String companyName;

    @Column(name = "contract_no")
    private String contractNo;

    @Column(name = "education_field_title")
    private String educationMajor;

    @Column(name = "gender_title")
    private String gender;

    @Column(name = "military_status_title")
    private String militaryStatus;

    @Column(name = "education_license_type_title")
    private String educationLicenseType;

    @Column(name = "department_title")
    private String departmentTitle;

    @Column(name = "department_code")
    private String departmentCode;

    @Column(name = "contract_description")
    private String contractDescription;

    @Column(name = "work_years")
    private String workYears;

    @Column(name = "work_months")
    private String workMonths;

    @Column(name = "work_days")
    private String workDays;

    @Column(name = "emp_no")
    private String personnelNo2;

    @Column(name = "insurance_code")
    private String insuranceCode;

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

    @Column(name = "religion_title")
    private String religion;

    @Column(name = "nationality_title")
    private String nationality;

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "fax")
    private String fax;

    @Column(name = "mobile")
    private String mobile;

    @Column(name = "email")
    private String email;

    @Column(name = "accountNumber")
    private String accountNumber;

}
