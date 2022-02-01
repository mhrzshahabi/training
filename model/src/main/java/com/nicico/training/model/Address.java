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
@Table(name = "tbl_address")
public class Address extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "address_seq")
    @SequenceGenerator(name = "address_seq", sequenceName = "seq_address_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_address")
    private String restAddr;

    @Column(name = "c_postal_code", unique = true)
    private String postalCode;

    @Column(name = "n_phone")
    private String phone;

    @Column(name = "n_fax")
    private String fax;

    @Column(name = "c_website")
    private String webSite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_city", insertable = false, updatable = false)
    private City city;

    @Column(name = "f_city")
    private Long cityId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_state", insertable = false, updatable = false)
    private State state;

    @Column(name = "f_state")
    private Long stateId;

    @Column(name = "b_other_country")
    private Boolean otherCountry;
}
