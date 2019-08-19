package com.nicico.training.model;

import com.nicico.training.model.enums.EInstituteType;
import com.nicico.training.model.enums.ELicenseType;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_institute", schema = "TRAINING")
public class Institute {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "institute_seq")
    @SequenceGenerator(name = "institute_seq", sequenceName = "seq_institute_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en", nullable = false)
    private String titleEn;

    @ManyToOne
    @JoinColumn(name = "f_contact_info", insertable = false, updatable = false)
    private ContactInfo contactInfo;

    @Column(name ="f_contact_info")
    private Long contactInfoId;

    @ManyToOne
    @JoinColumn(name = "f_account_info", insertable = false, updatable = false)
    private AccountInfo accountInfo;

    @Column(name ="f_account_info")
    private Long accountInfoId;

    @ManyToOne
    @JoinColumn(name = "f_manager", insertable = false, updatable = false)
    private Person manager;

    @Column(name ="f_manager", insertable = false, updatable = false)
    private Long managerId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_institute_teacher",schema = "training",
            joinColumns = {@JoinColumn(name = "f_institute",referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name="f_teacher",referencedColumnName = "id")})
    private Set<Teacher> teacherSet;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_institute_equipment",schema = "training",
            joinColumns = {@JoinColumn(name = "f_institute",referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name="f_equipment",referencedColumnName = "id")})
    private Set<Equipment> equipmentSet;

    @Column(name = "e_institute_type" ,  insertable = false, updatable = false)
    private EInstituteType eInstituteType;

    @Column(name = "e_institute_type")
    private Integer eInstituteTypeId;

    @Column(name = "c_institute_type")
    private String eInstituteTypeTitleFa;

    @Column(name = "e_license_type", insertable = false, updatable = false)
    private ELicenseType eLicenseType;

    @Column(name = "e_license_type")
    private Integer eLicenseTypeId;

    @Column(name = "c_license_type")
    private String eLicenseTypeTitleFa;

    @Column(name = "c_branch")
    private String branch;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.REFRESH})

    @JoinTable(name = "tbl_institute_teacher", schema = "TRAINING",
            joinColumns = {@JoinColumn(name = "f_institute", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")})
    private Set<Teacher> teachers;

}
