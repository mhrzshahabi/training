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
    @JoinColumn(name = "f_address", insertable = false, updatable = false)
    private Address address;

    @Column(name ="f_address")
    private Long addressId;

    @ManyToOne
    @JoinColumn(name = "f_account_info", insertable = false, updatable = false)
    private AccountInfo accountInfo;

    @Column(name ="f_account_info")
    private Long accountInfoId;

    @ManyToOne
    @JoinColumn(name = "f_manager", insertable = false, updatable = false)
    private PersonalInfo manager;

    @Column(name ="f_manager")
    private Long managerId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_institute_teacher",
            joinColumns = {@JoinColumn(name = "f_institute",referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name="f_teacher",referencedColumnName = "id")})
    private Set<Teacher> teacherSet;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_institute_equipment",
            joinColumns = {@JoinColumn(name = "f_institute",referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name="f_equipment",referencedColumnName = "id")})
    private Set<Equipment> equipmentSet;

    @OneToMany(fetch = FetchType.LAZY,mappedBy = "institute")
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

    @Column(name = "e_institute_type" ,  insertable = false, updatable = false)
    private EInstituteType eInstituteType;

    @Column(name = "e_institute_type")
    private Integer einstituteTypeId;

    @Column(name = "e_license_type", insertable = false, updatable = false)
    private ELicenseType eLicenseType;

    @Column(name = "e_license_type")
    private Integer elicenseTypeId;


    @ManyToOne
    @JoinColumn(name = "f_institute_parent", insertable = false, updatable = false)
    private Institute parentInstitute;

    @Column(name ="f_institute_parent")
    private Long parentInstituteId;

}
