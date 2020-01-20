package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_permission")
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

    @Column(name = "c_values")
    private String values;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_work_group", nullable = false, insertable = false, updatable = false)
    private WorkGroup workGroup;

    @Column(name = "f_work_group", nullable = false)
    private Long workGroupId;




}
