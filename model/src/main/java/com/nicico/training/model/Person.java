package com.nicico.training.model;

import com.nicico.training.model.enums.EGender;
import com.nicico.training.model.enums.EMarried;
import com.nicico.training.model.enums.EMilitary;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@Accessors(chain = true)
@MappedSuperclass
public abstract class Person extends Auditable {

	@Column(name = "c_full_name_fa", length = 255, nullable = false)
	private String fullNameFa;

	@Column(name = "c_full_name_en", length = 255, nullable = false)
	private String fullNameEn;

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


	@Column(name = "c_description",  length = 500)
	private String description;

	@Column(name = "c_work_name")
	private String workName;


//	@Column(name = "c_email")
//	private String email;
//
//	@Column(name = "c_mobile")
//	private String mobile;

//	@Column(name = "c_work_address")
//	private String workAddress;
//
//	@Column(name = "c_work_phone")
//	private String workPhone;
//
//	@Column(name = "c_work_postal_code")
//	private String workPostalCode;

	@Column(name = "c_work_job")
	private String workJob;

//	@Column(name = "c_work_telefax")
//	private String workTeleFax;
//
//	@Column(name = "c_work_webSite")
//	private String workWebSite;

//    @Column(name = "c_home_address")
//	private String homeAddress;
//
//    @Column(name = "c_home_phone")
//	private String homePhone;
//
//    @Column(name = "c_home_postal_code")
//	private String homePostalCode;

    @Column(name = "c_attach_photo")
    private String attachPhoto;

    @Column(name = "e_married" ,insertable = false, updatable = false)
	private EMarried eMarried;

    @Column(name = "e_married")
	private Integer eMarriedId;

	@Column(name = "e_military" ,insertable = false, updatable = false)
	private EMilitary eMilitary;

	@Column(name = "e_military")
	private Integer eMilitaryId;

	@Column(name = "e_gender" ,insertable = false, updatable = false)
	private EGender eGender;

	@Column(name = "e_gender")
	private Integer eGenderId;

	@Column(name = "c_married")
	private String eMarriedTitleFa;

	@Column(name = "c_military")
	private String eMilitaryTitleFa;

	@Column(name = "c_gender")
	private String eGenderTitleFa;

	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "f_contact_info", nullable = false, insertable = false, updatable = false)
	private ContactInfo contactInfo;

	@Column(name = "f_contact_info")
	private Long contactInfoId;

	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "f_account_info", nullable = false, insertable = false, updatable = false)
	private AccountInfo accountInfo;

	@Column(name = "f_account_info")
	private Long accountInfoId;
}
