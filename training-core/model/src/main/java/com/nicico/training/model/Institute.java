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

    @Column(name = "c_code", nullable = false)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en", nullable = false)
    private String titleEn;

    @Column(name = "c_phone", nullable = false)
    private String telephone;

    @Column(name = "c_address", nullable = false)
    private String address;

    @Column(name = "c_email", nullable = false)
    private String email;

    @Column(name = "c_postalCode", nullable = false)
    private String postalCode;

    @Column(name = "e_institute_type")
    private EInstituteType eInstituteType;

    @Column(name = "c_institute_type")
    private String eInstituteTypeTitleFa;

    @Column(name = "e_license_type")
    private ELicenseType eLicenseType;

    @Column(name = "c_license_type")
    private String eLicenseTypeTitleFa;

    @Column(name = "c_branch", nullable = false)
    private String branch;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @JoinTable(name = "tbl_institute_teacher", schema = "TRAINING",
            joinColumns = {@JoinColumn(name = "f_institute", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")})
    private Set<Teacher> teachers;


}
