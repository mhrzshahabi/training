package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_contact_info")

public class ContactInfo extends Auditable{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "contact_info_seq")
    @SequenceGenerator(name = "contact_info_seq", sequenceName = "seq_contact_info_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name="c_email")
    private String email;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "f_home_address", insertable = false, updatable = false)
	 private Address homeAdress;

	@Column(name = "f_home_address")
	private Long homeAdressId;

    @ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "f_work_address", insertable = false, updatable = false)
    private Address workAdress;

    @Column(name = "f_work_address")
	private Long workAdressId;

    @Column(name = "c_mobile")
    private String mobile;

	@Column(name = "c_personal_web_site")
	private String personalWebSite;

//	@Column(name = "c_description")
//	private String description;
}
