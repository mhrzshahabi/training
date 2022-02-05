package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_permission",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_entity_name", "c_attribute_name", "f_work_group"})})
public class Permission extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "permission_seq")
    @SequenceGenerator(name = "permission_seq", sequenceName = "seq_permission_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_entity_name", nullable = false)
    private String entityName;

    @Column(name = "c_attribute_name")
    private String attributeName;

    @Column(name = "c_attribute_type")
    private String attributeType;

    @ElementCollection
    @CollectionTable(name = "tbl_permission_attribute_values", joinColumns = @JoinColumn(name = "f_permission"))
    @Column(name = "attribute_values")
    private List<String> attributeValues;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_work_group", nullable = false, insertable = false, updatable = false)
    private WorkGroup workGroup;

    @Column(name = "f_work_group", nullable = false)
    private Long workGroupId;
}
