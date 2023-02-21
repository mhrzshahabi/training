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
@Table(name = "tbl_sub_category", uniqueConstraints = {@UniqueConstraint(columnNames = {"f_category_id", "c_title_fa"})}
)
public class Subcategory extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_sub_category")
    @SequenceGenerator(name = "seq_sub_category", sequenceName = "seq_sub_category_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", length = 7, nullable = false, unique = true)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_category_id", insertable = false, updatable = false)
    private Category category;

    @Column(name = "f_category_id")
    private Long categoryId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_sub_category_parameter_value",
            joinColumns = {@JoinColumn(name = "f_sub_category_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_parameter_value_id", referencedColumnName = "id")})
    private Set<ParameterValue> classifications;

    @Column(name = "b_need_to_classification")
    private Boolean needToClassification;

}
