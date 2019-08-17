package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_state")
public class State extends Auditable
{
	@Id
	private Long id;

	@Column(name = "name")
	private String name;

	@OneToMany(mappedBy = "state", fetch = FetchType.LAZY)
	private Set<City> citySet;

//	@ManyToOne(fetch = FetchType.LAZY)
//	@JoinColumn(name = "f_country")
//	private Country country;
}
