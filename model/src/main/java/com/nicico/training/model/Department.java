package com.nicico.training.model;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;

@Getter
@Entity
@Immutable
@Table(name = "tbl_department")
public class Department {
//
//    @Id
//    @Column(name = "id", precision = 10)
//    private String id;
//
//    @Column(name = "c_area")
//    private String area;
//
//    @Column(name = "c_assistance")
//    private String assistance;
//
//    @Column(name = "c_affairs")
//    private String affairs;
//
//    @Column(name = "c_section")
//    private String section;
//
//    @Column(name = "c_unit")
//    private String unit;
//
//    @Column(name = "c_cost_center_code")
//    private String costCenterCode;
//
//    @Column(name = "c_cost_center_title_fa")
//    private String costCenterTitleFa;


    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "department_seq")
    @SequenceGenerator(name = "department_seq", sequenceName = "seq_department_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Setter(AccessLevel.NONE)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dep_parent_id",
            foreignKey = @ForeignKey(name = "fk_department2Department"),
            insertable = false, updatable = false)
    private Department parentDepartment;

    @Column(name = "dep_parent_id")
    private Long depParrentId;

    @Column(name = "dep_departmentname", nullable = false, length = 255)
    private String departmentName;

    @Column(name = "dep_deactive")
    private String deactive;

    @Column(name = "parent_code")
    private String parentCode;

    @Column(name = "c_code")
    private String code;

    @Version
    @Column(name = "n_version")
    private Integer version;

    @Column(name = "n_tree_version")
    private String treeVersion;
}
