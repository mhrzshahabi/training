package com.nicico.training.model;

import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;

@Getter
@Entity
@Immutable
@Table(name = "tbl_geo_work",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_code", "c_people_type"})})
public class GeoWork {

    @Id
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code")
    private Long code;

    @Column(name = "c_title")
    private String titleFa;

    @Column(name = "c_people_type", length = 50)
    private String peopleType;
}
