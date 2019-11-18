package com.nicico.training.model;

import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;

@Getter
@Entity
@Immutable
@Table(name = "tbl_personnel")
public class Personnel {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_personnel_auto_id")
    @SequenceGenerator(name = "seq_personnel_auto_id", sequenceName = "seq_personnel_auto_id", allocationSize = 1)
    @Column(name = "autoId", precision = 10)
    private Long autoId;

    @Column(name = "ID")
    private Long id;

    @Column(name = "PersonnelNo")
    private String personnelNo;

    @Column(name = "FirstName")
    private String firstName;

    @Column(name = "LastName")
    private String lastName;

    @Column(name = "FatherName")
    private String fatherName;

    @Column(name = "IDNumber")
    private String birthCertificateNo;

    @Column(name = "BirthDate")
    private String birthDate;

    @Column(name = "sen")
    private Integer age;

    @Column(name = "BirthPlace")
    private String birthPlace;

    @Column(name = "SSN")
    private String nationalCode;

    @Column(name = "Active")
    private Integer active;

    @Column(name = "Deleted")
    private Integer deleted;

    @Column(name = "EmploymentDate")
    private String employmentDate;

    @Column(name = "postTitle")
    private String postTitle;

    @Column(name = "PostCode")
    private String postCode;

    @Column(name = "AssignmentDate")
    private String postAssignmentDate;

    @Column(name = "FirstWorkPlaceTitle")
    private String complexTitle;

    @Column(name = "OperationalUnitTitles")
    private String operationalUnitTitle;

    @Column(name = "EmploymentTypeTitle")
    private String employmentTypeTitle;

    @Column(name = "MaritalStatusTitle")
    private String maritalStatusTitle;

    @Column(name = "WorkPlaceTitle")
    private String workPlaceTitle;

    @Column(name = "WorkTurnTitle")
    private String workTurnTitle;

    @Column(name = "EducationLevelTitle")
    private String educationLevelTitle;

    @Column(name = "JobNo")
    private String jobNo;

    @Column(name = "jobTitle")
    private String jobTitle;

    @Column(name = "EmploymentStatusTitle")
    private String employmentStatusTitle;

    @Column(name = "SherkatName")
    private String companyName;

    @Column(name = "ShomareGharardad")
    private String contractNo;

    @Column(name = "FieldTitle")
    private String educationFieldTitle;

    @Column(name = "GenderTitle")
    private String genderTitle;

    @Column(name = "MilitaryStatusTitle")
    private String militaryStatusTitle;

    @Column(name = "EducationLicenseTypeTitle")
    private String educationLicenseTypeTitle;

    @Column(name = "JobEducationLevelTitle")
    private String jobEducationLevelTitle;

    @Column(name = "DepartmentTitle")
    private String departmentTitle;

    @Column(name = "DepartmentCode")
    private String departmentCode;

    @Column(name = "SharhGharardad")
    private String contractDescription;

    @Column(name = "Sanavatkol_sal")
    private String workYears;

    @Column(name = "Sanavatkol_mah")
    private String workMonths;

    @Column(name = "Sanavatkol_rooz")
    private String workDays;

    @Column(name = "EmpNo")
    private String empNo;

    @Column(name = "BimeCode")
    private String insuranceCode;

    @Column(name = "PostGradeTitle")
    private String postGradeTitle;

    @Column(name = "PostGradeCode")
    private String postGradeCode;

    @Column(name = "ccp_Code")
    private String ccpCode;

    @Column(name = "ccp_Hozae")
    private String ccpArea;

    @Column(name = "ccp_Moavenat")
    private String ccpAssistant;

    @Column(name = "ccp_Omur")
    private String ccpAffairs;

    @Column(name = "ccp_Ghesmat")
    private String ccpSection;

    @Column(name = "ccp_Vahed")
    private String ccpUnit;

    @Column(name = "ccp_title")
    private String ccpTitle;
}

