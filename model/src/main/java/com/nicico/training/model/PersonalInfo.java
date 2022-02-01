package com.nicico.training.model;

import com.nicico.training.model.enums.EGender;
import com.nicico.training.model.enums.EMarried;
import com.nicico.training.model.enums.EMilitary;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_personal_info")
public class PersonalInfo extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "personal_info_seq")
    @SequenceGenerator(name = "personal_info_seq", sequenceName = "seq_personal_info_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_first_name_fa", nullable = false)
    private String firstNameFa;

    @Column(name = "c_last_name_fa", nullable = false)
    private String lastNameFa;

    @Column(name = "c_first_name_en")
    private String firstNameEn;

    @Column(name = "c_last_name_en")
    private String lastNameEn;

    @Column(name = "c_national_code", length = 10, nullable = false, unique = true)
    private String nationalCode;

    @Column(name = "c_father_name")
    private String fatherName;

    @Column(name = "c_birth_date")
    private String birthDate;

    @Column(name = "c_birth_location")
    private String birthLocation;

    @Column(name = "c_birth_certificate")
    private String birthCertificate;

    @Column(name = "c_birth_certificate_location")
    private String birthCertificateLocation;

    @Column(name = "c_religion")
    private String religion;

    @Column(name = "c_nationality")
    private String nationality;

    @Column(name = "c_description", length = 500)
    private String description;

    @Column(name = "p_photo")
    private String photo;

    @Column(name = "c_job_title")
    private String jobTitle;

    @Column(name = "c_job_location")
    private String jobLocation;

    @Column(name = "e_married", insertable = false, updatable = false)
    private EMarried married;

    @Column(name = "e_married")
    private Integer marriedId;

    @Column(name = "e_military", insertable = false, updatable = false)
    private EMilitary military;

    @Column(name = "e_military")
    private Integer militaryId;

    @Column(name = "e_gender", insertable = false, updatable = false)
    private EGender gender;

    @Column(name = "e_gender")
    private Integer genderId;

    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    @JoinColumn(name = "f_contact_info")
    private ContactInfo contactInfo;

    @Column(name = "f_contact_info", insertable = false, updatable = false)
    private Long contactInfoId;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "f_account_info")
    private AccountInfo accountInfo;

    @Column(name = "f_account_info", insertable = false, updatable = false)
    private Long accountInfoId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_edu_level", insertable = false, updatable = false)
    private EducationLevel educationLevel;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_edu_major", insertable = false, updatable = false)
    private EducationMajor educationMajor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_edu_orientation", insertable = false, updatable = false)
    private EducationOrientation educationOrientation;

    @Column(name = "f_edu_level")
    private Long educationLevelId;

    @Column(name = "f_edu_major")
    private Long educationMajorId;

    @Column(name = "f_edu_orientation")
    private Long educationOrientationId;
}
