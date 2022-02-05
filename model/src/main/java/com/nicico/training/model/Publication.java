package com.nicico.training.model;

import com.nicico.training.model.enums.EPublicationSubjectType;
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
@Table(name = "tbl_publication")
public class Publication extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "publication_seq")
    @SequenceGenerator(name = "publication_seq", sequenceName = "seq_publication_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_subject_title", nullable = false)
    private String subjectTitle;

    @Column(name = "c_publication_date")
    private String publicationDate;

    @Column(name = "c_publication_location")
    private String publicationLocation;

    @Column(name = "c_publisher")
    private String publisher;

    @Column(name = "e_subject_type", insertable = false, updatable = false)
    private EPublicationSubjectType publicationSubjectType;

    @Column(name = "e_subject_type")
    private Integer publicationSubjectTypeId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_publication_category",
            joinColumns = {@JoinColumn(name = "f_publication", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private Set<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_publication_subcategory",
            joinColumns = {@JoinColumn(name = "f_publication", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_subcategory", referencedColumnName = "id")})
    private Set<Subcategory> subCategories;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;
}
