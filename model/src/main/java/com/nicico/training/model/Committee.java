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
    private SubCategory subCategory;

    @Column(name = "subcategory_id")
    private Long subCategoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_category_id", insertable = false, updatable = false)
    private Category category;

    @Column(name = "f_category_id")
    private Long categoryId;

//    @ManyToMany(fetch = FetchType.LAZY)
//	@JoinTable(name = "tbl_committee_user",
//            joinColumns = {@JoinColumn(name = "f_committee_id", referencedColumnName = "id")},
//            inverseJoinColumns = {@JoinColumn(name = "f_user_id", referencedColumnName = "id")})
//    private List<User> members;

    @Column(name = "c_tasks", length = 400)
    private String tasks;

    @Column(name = "c_description")
    private String description;

    @ManyToMany(fetch = FetchType.LAZY,cascade = {CascadeType.PERSIST})
    @JoinTable(name = "tbl_committee_personal_info",
            joinColumns = {@JoinColumn(name = "f_committee_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_personal_info_id", referencedColumnName = "id")})
    private Set<PersonalInfo> committeeMmembers;


}
