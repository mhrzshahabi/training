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
@Table(name = "tbl_skill_sub_category", schema = "TRAINING")
public class SkillStandardSubCategory extends Auditable {

	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "skill_sub_category_seq")
	@SequenceGenerator(name = "skill_sub_category_seq", sequenceName = "seq_skill_sub_category_id",  allocationSize = 1)
	@Column(name = "id", precision = 10)
	private Long id;

	@Column(name = "c_title_fa", length = 255, nullable = false)
	private String titleFa;

	@Column(name = "c_title_en", length = 255, nullable = false)
	private String titleEn;

	@Setter(AccessLevel.NONE)
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "f_skill_category", insertable = false, updatable = false)
	private SkillStandardCategory skillStandardCategory;

	@Column(name = "f_skill_category")
	private Long skillStandardCategoryId;
}
