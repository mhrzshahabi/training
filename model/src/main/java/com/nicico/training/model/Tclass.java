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
@Table(name = "tbl_class")
public class Tclass extends Auditable {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_seq")
	@SequenceGenerator(name = "class_seq", sequenceName = "seq_class_id", allocationSize = 1)
	@Column(name = "id", precision = 10)
	private long id;

	@Column(name = "n_group", nullable = false)
	private Long group;

	@Column(name = "c_start_date", nullable = false)
	private String startDate;

	@Column(name = "c_end_date", nullable = false)
	private String endDate;

	@Column(name = "n_duration")
	private Long duration;

	@Column(name = "c_code", nullable = false)
	private String code;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "f_teacher", insertable = false, updatable = false)
	private Teacher teacher;

	@Column(name = "f_teacher")
	private Long teacherId;

	@ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
	@JoinColumn(name = "f_course", insertable = false, updatable = false)
	private Course course;

	@Column(name = "f_course")
	private Long courseId;

	@ManyToMany(fetch = FetchType.EAGER, cascade = {CascadeType.PERSIST})
	@JoinTable(name = "tbl_student_class",
			joinColumns = {@JoinColumn(name = "f_class", referencedColumnName = "id")},
			inverseJoinColumns = {@JoinColumn(name = "f_student", referencedColumnName = "id")})
	private List<Student> studentSet;



}
