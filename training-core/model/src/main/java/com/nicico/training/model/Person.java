package com.nicico.training.model;

import com.nicico.training.model.enums.EGender;
import com.nicico.training.model.enums.EMarried;
import com.nicico.training.model.enums.EMilitary;
import lombok.*;
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

	@Column(name = "e_gender")
	private EGender gender;

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

	@Column(name = "e_married")
	private EMarried married;

	@Column(name = "c_email")
	private String email;

	@Column(name = "e_military")
	private EMilitary military;

	@Column(name = "c_mobile")
	private String mobile;

	@Column(name = "c_description",  length = 500)
	private String description;

	/////////////////////////////////////////////////////////////

	@Column(name = "c_work_name")
	private String workName;

	@Column(name = "c_work_address")
	private String workAddress;

	@Column(name = "c_work_phone")
	private String workPhone;

	@Column(name = "c_work_postal_code")
	private String workPostalCode;

	@Column(name = "c_work_job")
	private String workJob;

	@Column(name = "c_work_telefax")
	private String workTeleFax;

	@Column(name = "c_work_webSite")
	private String workWebSite;

	////////////////////////////////////////////////////////////////

    @Column(name = "c_home_address")
	private String homeAddress;

    @Column(name = "c_home_phone")
	private String homePhone;

    @Column(name = "c_home_postal_code")
	private String homePostalCode;

	//////////////////////////////////////////////////////////////////

    @Column(name = "c_attach_photo")
    private String attachPhoto;

    @Column(name = "c_attach_extension")
    private String attachExtension;

}
