package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;

import javax.persistence.*;
import javax.validation.OverridesAttribute;
import java.util.Date;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_city")
@AttributeOverride(name="createdDate", column=@Column(name="d_created_date",nullable = true, updatable = false))
@AttributeOverride(name="createdBy", column=@Column(name="c_created_by",nullable = true, updatable = false))
@AttributeOverride(name="version", column=@Column(name="n_version",nullable = true, updatable = false))
//@Subselect("select * from tbl_city")
public class City extends Auditable{
	@Id
	private Long id;

	@Column(name = "name")
	private String name;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "f_state")
	private State state;
}
