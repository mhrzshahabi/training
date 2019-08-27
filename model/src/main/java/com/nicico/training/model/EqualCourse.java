package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_equal_course")
public class EqualCourse extends Auditable {
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "equal_course_seq")
	@SequenceGenerator(name = "equal_course_seq", sequenceName = "seq_equal_course_id", allocationSize = 1)
	@Column(name = "equal_course_id", precision = 10)
	private Long id;

	//TODO
	@ElementCollection
	@CollectionTable(name = "tbl_equal_and_course", joinColumns = @JoinColumn(name = "f_equal_course_id"))
	@Column(name = "list_equal_and_course")
	private List<Long> equalAndList = new ArrayList<>();

	@Column(name = "f_course")
	private Long courseId;
}
