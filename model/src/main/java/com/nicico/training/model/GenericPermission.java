package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Any;
import org.hibernate.annotations.AnyMetaDef;
import org.hibernate.annotations.MetaValue;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_generic_permission")
public class GenericPermission<E> extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "generic_permission_seq")
    @SequenceGenerator(name = "generic_permission_seq", sequenceName = "seq_generic_permission_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Any(metaColumn = @Column(name = "c_object_type", nullable = false), fetch = FetchType.LAZY)
    @AnyMetaDef(idType = "long", metaType = "string",
            metaValues = {
                    @MetaValue(value = "Category", targetEntity = Category.class),
                    @MetaValue(value = "Subcategory", targetEntity = Subcategory.class),
                    @MetaValue(value = "ParameterValue", targetEntity = ParameterValue.class),
                    @MetaValue(value = "Department", targetEntity = Department.class),
            })
    @JoinColumn(name = "f_object", nullable = false, insertable = false, updatable = false)
    private E object;

    @Column(name = "f_object", nullable = false)
    private Long objectId;

    @Column(name = "c_object_type", nullable = false)
    private String objectType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_work_group", nullable = false, insertable = false, updatable = false)
    private WorkGroup workGroup;

    @Column(name = "f_work_group", nullable = false)
    private Long workGroupId;
}
