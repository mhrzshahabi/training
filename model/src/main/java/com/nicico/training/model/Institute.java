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
@Table(name = "tbl_institute")
public class Institute extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "institute_seq")
    @SequenceGenerator(name = "institute_seq", sequenceName = "seq_institute_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_address")
    private String restAddress;

    @Column(name = "c_post_code", length = 12)
    private String postalCode;

    @Column(name = "c_phone", length = 50)
    private String phone;

    @Column(name = "c_mobile", length = 50)
    private String mobile;

    @Column(name = "c_fax", length = 50)
    private String fax;

    @Column(name = "c_website", length = 50)
    private String webSite;

    @Column(name = "c_email", length = 50)
    private String e_mail;

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

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "institute", cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    private Set<InstituteAccount> instituteAccountSet;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.REFRESH)
    @JoinColumn(name = "f_manager", insertable = false, updatable = false)
    private PersonalInfo manager;

    @Column(name = "f_manager")
    private Long managerId;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @JoinTable(name = "tbl_institute_teacher",
            joinColumns = {@JoinColumn(name = "f_institute", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_teacher", referencedColumnName = "id")})
    private Set<Teacher> teacherSet;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @JoinTable(name = "tbl_institute_equipment",
            joinColumns = {@JoinColumn(name = "f_institute", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_equipment", referencedColumnName = "id")})
    private Set<Equipment> equipmentSet;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "institute", cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    private Set<TrainingPlace> trainingPlaceSet;


    @Column(name = "n_teacher_phd_number")
    private Integer teacherNumPHD;

    @Column(name = "n_emp_phd_number")
    private Integer empNumPHD;

    @Column(name = "n_teacher_licentiate_number")
    private Integer teacherNumLicentiate;

    @Column(name = "n_emp_licentiate_number")
    private Integer empNumLicentiate;

    @Column(name = "n_teacher_master_number")
    private Integer teacherNumMaster;

    @Column(name = "n_emp_master_number")
    private Integer empNumMaster;

    @Column(name = "n_teacher_associate_number")
    private Integer teacherNumAssociate;

    @Column(name = "n_emp_associate_number")
    private Integer empNumAssociate;

    @Column(name = "n_teacher_diploma_number")
    private Integer teacherNumDiploma;

    @Column(name = "n_emp_diploma_number")
    private Integer empNumDiploma;

    @Column(name = "e_institute_type", insertable = false, updatable = false)
    private EInstituteType eInstituteType;

    @Column(name = "e_institute_type")
    private Integer einstituteTypeId;

    @Column(name = "e_license_type", insertable = false, updatable = false)
    private ELicenseType eLicenseType;

    @Column(name = "e_license_type")
    private Integer elicenseTypeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_institute_parent", insertable = false, updatable = false)
    private Institute parentInstitute;

    @Column(name = "f_institute_parent")
    private Long parentInstituteId;

}
