package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;

import javax.persistence.*;
import java.util.Date;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
//@Table(name = "tbl_state")
@AttributeOverride(name="createdDate", column=@Column(name="d_created_date",nullable = true, updatable = false))
@AttributeOverride(name="createdBy", column=@Column(name="c_created_by",nullable = true, updatable = false))
@AttributeOverride(name="version", column=@Column(name="n_version",nullable = true, updatable = false))
@Subselect("select * from tbl_state")
public class State extends Auditable
{
	@Id
	private Long id;

	@Column(name = "name")
	private String name;

	@OneToMany(mappedBy = "state", fetch = FetchType.LAZY)
	private Set<City> citySet;
}
