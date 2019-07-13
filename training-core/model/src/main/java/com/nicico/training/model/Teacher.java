package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_teacher", schema = "TRAINING")
public class Teacher extends Person {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_seq")
	@SequenceGenerator(name = "teacher_seq", sequenceName = "seq_teacher_id", allocationSize = 1)
	@Column(name = "id", precision = 10)
	private Long id;


    @Column(name = "c_teacher_code", nullable = false, unique = true)
	private String teacherCode;

	@Column(name = "b_enabled")
	private Boolean enabled;

	@ManyToMany(fetch = FetchType.EAGER, cascade = {CascadeType.PERSIST})
	@JoinTable(name = "tbl_teacher_category", schema = "TRAINING",
			joinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")},
			inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
	private List<Category> categories;

	@Column(name = "c_economical_code")
	private String economicalCode;

	@Column(name = "c_economical_record_number")
	private String economicalRecordNumber;

	///////////////////////////////////////////
	@Column(name = "c_edu_level")
	private String eduLevel;

	@Column(name = "c_edu_major")
	private String eduMajor;

	@Column(name = "c_edu_orientation")
	private String eduOrientation;
	/////////////////////////////////////////

    @Column(name = "c_account_number")
	private String accountNember;

    @Column(name = "c_bank")
	private String bank;

    @Column(name = "c_bank_branch")
	private String bankBranch;

    @Column(name = "c_cart_number")
	private String cartNumber;

    @Column(name = "c_shaba_number")
	private String shabaNumber;

}
