package com.nicico.training.model;

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
@Table(name = "tbl_committee")
public class Committee extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "committee_seq")
    @SequenceGenerator(name = "committee_seq", sequenceName = "seq_committee_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subcategory_id", nullable = false, insertable = false, updatable = false)
    private Subcategory subCategory;

    @Column(name = "subcategory_id")
    private Long subCategoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_category_id", insertable = false, updatable = false)
    private Category category;

    @Column(name = "f_category_id")
    private Long categoryId;

    @Column(name = "c_tasks", length = 400)
    private String tasks;

    @Column(name = "c_description")
    private String description;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
    @JoinTable(name = "tbl_committee_personal_info",
            joinColumns = {@JoinColumn(name = "f_committee_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_personal_info_id", referencedColumnName = "id")})
    private Set<PersonalInfo> committeeMmembers1;

    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST})
    @JoinTable(name = "tbl_committee_personnel",
            joinColumns = {@JoinColumn(name = "f_committee_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_personnel_id", referencedColumnName = "id")})
    private Set<Personnel> committeeMmembers;
}
