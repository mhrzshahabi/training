/*
ghazanfari_f,
1/14/2020,
1:32 PM
*/
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.Constraint;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_competence",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_title", "category_id", "subcategory_id"})})
public class Competence extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_competence_id")
    @SequenceGenerator(name = "seq_competence_id", sequenceName = "seq_competence_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title")
    private String title;

    @Column(name = "c_description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value", nullable = false, insertable = false, updatable = false)
    private ParameterValue competenceType;

    @Column(name = "f_parameter_value")
    private Long competenceTypeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", insertable = false, updatable = false)
    private Category category;

    @Column(name = "category_id")
    private Long categoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subcategory_id", insertable = false, updatable = false)
    private Subcategory subCategory;

    @Column(name = "subcategory_id")
    private Long subCategoryId;

    @Column(name = "c_code", unique = true, nullable = false)
    private String code;

    @Column(name = "n_work_flow_code")
    private Long workFlowStatusCode;

    @Column(name = "process_instance_id")
    private String processInstanceId;


    @Column(name = "return_detail")
    private String returnDetail;
}
