package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_committee_of_experts")
public class CommitteeOfExperts extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "committee_of_experts_seq")
    @SequenceGenerator(name = "committee_of_experts_seq", sequenceName = "seq_committee_of_experts_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "complex")
    private String complex;

    @Column(name = "title")
    private String title;

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "fax")
    private String fax;

    @Column(name = "email")
    private String email;
    //
    @OneToMany(mappedBy = "committeeOfExperts", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CommitteePersonnel> committeePersonnels;

//    @OneToMany(mappedBy = "committeeOfExpertsForReg", cascade = CascadeType.ALL, orphanRemoval = true)
//    private List<CommitteePersonnelRegistred> committeePersonnelRegs;


//    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
//    @JoinTable(name = "tbl_committee_of_experts_personnel",
//            joinColumns = {@JoinColumn(name = "f_committee_id", referencedColumnName = "id")},
//            inverseJoinColumns = {@JoinColumn(name = "f_personnel_id", referencedColumnName = "id")})
//    private Set<Personnel> personnels;
//
//    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
//    @JoinTable(name = "tbl_committee_of_experts_registered",
//            joinColumns = {@JoinColumn(name = "f_committee_id", referencedColumnName = "id")},
//            inverseJoinColumns = {@JoinColumn(name = "f_personnel_id", referencedColumnName = "id")})
//    private Set<PersonnelRegistered> personnelRegisters;


}