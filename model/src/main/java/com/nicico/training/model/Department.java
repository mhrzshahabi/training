package com.nicico.training.model;

import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Getter
@Entity
@Immutable
@Table(name = "tbl_department")
public class Department extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
    private String id;

    @Column(name = "c_area")
    private String area;

    @Column(name = "c_assistance")
    private String assistance;

    @Column(name = "c_affairs")
    private String affairs;

    @Column(name = "c_section")
    private String section;

    @Column(name = "c_unit")
    private String unit;

    @Column(name = "c_cost_center_code", nullable = false)
    private String costCenterCode;

    @Column(name = "c_cost_center_title_fa", nullable = false)
    private String costCenterTitleFa;
}
