package com.nicico.training.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;

import javax.persistence.*;
import java.util.Date;

@Getter
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@MappedSuperclass
public class DepartmentSuperClass extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_l")
    private String titleL;

    @Column(name = "c_title")
    private String title;

    @Column(name = "c_type")
    private String type;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parent", insertable = false, updatable = false)
    private Department parentDepartment;

    @Column(name = "f_parent")
    private Long parentId;

    @Column(name = "c_nature")
    private String nature;

    @Column(name = "c_start_date")
    private Date startDate;

    @Column(name = "c_end_date")
    private Date endDate;

    @Column(name = "c_legacy_create_date")
    private Date legacyCreateDate;

    @Column(name = "c_legacy_change_date")
    private Date legacyChangeDate;

    @Column(name = "c_user")
    private String user;

    @Column(name = "c_issuable")
    private Boolean issuable;

    @Column(name = "c_correction")
    private Boolean correction;

    @Column(name = "c_alignment")
    private Boolean alignment;

    @Column(name = "c_people_type", length = 50)
    private String peopleType;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_old_code")
    private String oldCode;

    @Column(name = "c_new_code")
    private String newCode;

    @Column(name = "c_parent_code", length = 50)
    private String parentCode;

    @Column(name = "c_hoze_code")
    private String hozeCode;

    @Column(name = "c_hoze_title")
    private String hozeTitle;

    @Column(name = "c_moavenat_code")
    private String moavenatCode;

    @Column(name = "c_moavenat_title")
    private String moavenatTitle;

    @Column(name = "c_omor_code")
    private String omorCode;

    @Column(name = "c_omor_title")
    private String omorTitle;

    @Column(name = "c_ghesmat_code")
    private String ghesmatCode;

    @Column(name = "c_ghesmat_title")
    private String ghesmatTitle;

    @Column(name = "c_vahed_code")
    private String vahedCode;

    @Column(name = "c_vahed_title")
    private String vahedTitle;

    @Column(name = "c_mojtame_code")
    private String mojtameCode;

    @Column(name = "c_mojtame_title")
    private String mojtameTitle;
}