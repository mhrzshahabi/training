package com.nicico.training.model;


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
@Table(name = "tbl_teacher", schema = "TRAINING")
public class Teacher extends Auditable {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_seq")
	@SequenceGenerator(name = "teacher_seq", sequenceName = "seq_teacher_id", allocationSize = 1)
	@Column(name = "id", precision = 10)
	private Long id;

	@Column(name = "c_full_name_fa", length = 255, nullable = false)
	private String fullNameFa;

	@Column(name = "c_full_name_en", length = 255)
	private String fullNameEn;

	@Column(name = "c_national_code", length = 10, nullable = false, unique = true)
	private String nationalCode;

	@Column(name = "c_mobile")
	private String mobile;

	@Column(name = "c_phone")
	private String phone;

	@Column(name = "c_home_address")
	private String homeAddress;

	@Column(name = "c_work_address")
	private String workAddress;
}
