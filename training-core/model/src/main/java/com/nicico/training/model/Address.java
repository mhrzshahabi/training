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

    @Column(name = "c_street")
    private String street;

    @Column(name = "c_alley")
    private String alley;

    @Column(name = "n_post_code")
    private Long postCode;

    @Column(name = "c_phone")
    private String phoneNumber;

    @Column(name = "c_mobile")
    private String mobile;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_state")
    private State state;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_city")
    private City city;
}
