package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_class_contract")
public class ClassContract extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_contract_seq")
    @SequenceGenerator(name = "class_contract_seq", sequenceName = "seq_class_contract_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_contract_number", nullable = false, unique = true)
    private String contractNumber;

    @Column(name = "c_date", nullable = false)
    private String date;

    @OneToMany(mappedBy = "classContract", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<ClassContractCost> classSet;

    @Column(name = "b_is_signed", nullable = false)
    private Boolean isSigned = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_category_id", insertable = false, updatable = false)
    private Category category;

    @Column(name = "f_category_id")
    private Long categoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_subcategory_id", insertable = false, updatable = false)
    private Subcategory subCategory;

    @Column(name = "f_subcategory_id")
    private Long subCategoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_accountable_id", nullable = false, insertable = false, updatable = false)
    private Personnel accountable;

    @Column(name = "f_accountable_id", nullable = false)
    private Long accountableId;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "f_first_party_company_id", nullable = false, insertable = false, updatable = false)
    private Company firstPartyCompany;

    @Column(name = "f_first_party_company_id", nullable = false)
    private Long firstPartyCompanyId;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "f_second_party_institute_id", insertable = false, updatable = false)
    private Institute secondPartyInstitute;

    @Column(name = "f_second_party_institute_id")
    private Long secondPartyInstituteId;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "f_second_party_person_id", insertable = false, updatable = false)
    private PersonalInfo secondPartyPerson;

    @Column(name = "f_second_party_person_id")
    private Long secondPartyPersonId;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "f_contract_file_id", nullable = false, insertable = false, updatable = false)
    private Attachment<ClassContract> contractFile;

    @Column(name = "f_contract_file_id", nullable = false)
    private Long contractFileId;
}
