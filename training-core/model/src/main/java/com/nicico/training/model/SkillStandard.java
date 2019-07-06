package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"})
@Entity
@Table(name = "tbl_skill_standard", schema = "TRAINING")
public class SkillStandard extends Auditable {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "skill_standard_seq")
	@SequenceGenerator(name = "skill_standard_seq", sequenceName = "seq_skill_standard_id", allocationSize = 1)
	@Column(name = "id", precision = 10)
	private Long id;

	@Column(name = "c_code", length = 7, nullable = false, unique = true)
	private String code;

	@Column(name = "c_title_fa", length = 255, nullable = false)
	private String titleFa;

	@Column(name = "c_title_en", length = 255, nullable = false)
	private String titleEn;

	@Setter(AccessLevel.NONE)
	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "f_skill_level", nullable = false, insertable = false, updatable = false)
	private SkillLevel skillLevel;

	@Column(name = "f_skill_level")
	private Long skillLevelId;

	@Setter(AccessLevel.NONE)
	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "f_skill_category", nullable = false, insertable = false, updatable = false)
	private SkillStandardCategory skillStandardCategory;

	@Column(name = "f_skill_category")
	private Long skillStandardCategoryId;

	@ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
	@JoinTable(name = "tbl_skill_standard_course", schema = "TRAINING",
			joinColumns = {@JoinColumn(name = "f_skill_standard", referencedColumnName = "id")},
			inverseJoinColumns = {@JoinColumn(name = "f_course", referencedColumnName = "id")})
	private Set<Course> courses;
}
