package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.DynamicUpdate;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@DynamicUpdate
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_student")
public class Student extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_student_id")
    @SequenceGenerator(name = "seq_student_id", sequenceName = "seq_student_id", allocationSize = 1)
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
    private String complexTitle;

    @Column(name = "operational_unit_title")
    private String operationalUnitTitle;

    @Column(name = "employment_type_title")
    private String employmentTypeTitle;

    @Column(name = "marital_status_title")
    private String maritalStatusTitle;

    @Column(name = "work_place_title")
    private String workPlaceTitle;

    @Column(name = "work_turn_title")
    private String workTurnTitle;

    @Column(name = "education_level_title")
    private String educationLevelTitle;

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
    private String educationMajorTitle;

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

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "mobile")
    private String mobile;

    @Column(name = "email")
    private String email;

    @Column(name = "religion_title")
    private String religion;

    @Column(name = "nationality_title")
    private String nationality;

    @Column(name = "fax")
    private String fax;

    @Column(name = "account_number")
    private String accountNumber;

    @OneToMany(mappedBy = "student", fetch = FetchType.LAZY, cascade = CascadeType.REMOVE, orphanRemoval = true)
    private Set<ClassStudent> classStudents;

    @Column(name = "p_type", length = 50)
    private String peopleType;

    @Column(name = "f_department_id")
    private Long departmentId;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "f_department_id", insertable = false, updatable = false)
//    private Department department;
}
