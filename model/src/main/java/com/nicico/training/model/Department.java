/*
ghazanfari_f, 8/29/2019, 9:11 AM
*/
package com.nicico.training.model;

import com.nicico.training.model.enums.EActive;
import com.nicico.training.model.enums.EDeleted;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import javax.persistence.*;

@Getter
@EqualsAndHashCode(of = "id")
@Entity
@Table(name = "tbl_department")
public class Department {

    @Id
    @Column(name = "id")
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

    @Column(name = "c_cost_center_code")
    private String costCenterCode;

    @Column(name = "c_cost_center_title_fa")
    private String costCenterTitleFa;

    @Column(name = "e_active")
    EActive eActive;

    @Column(name = "e_deleted")
    EDeleted eDeleted;
}
