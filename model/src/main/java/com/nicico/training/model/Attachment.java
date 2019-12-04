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
@Table(name = "tbl_attachment",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_object_type", "f_object_id", "c_file_name"})})
public class Attachment<E> extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "attachment_seq")
    @SequenceGenerator(name = "attachment_seq", sequenceName = "seq_attachment_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_file_name", nullable = false)
    private String fileName;

    @Column(name = "f_file_type_id", nullable = false)
    private Long fileTypeId;

    @Column(name = "c_description", length = 500)
    private String description;

    @Any(
            metaColumn = @Column(name = "c_object_type", nullable = false, length = 30),
            fetch = FetchType.LAZY
    )
    @AnyMetaDef(
            idType = "long", metaType = "string",
            metaValues = {
                    @MetaValue(targetEntity = Tclass.class, value = "Tclass"),
                    @MetaValue(targetEntity = Teacher.class, value = "Teacher")

            }
    )
    @JoinColumn(name = "f_object_id", nullable = false, insertable = false, updatable = false)
    private E object;

    @Column(name = "f_object_id", nullable = false)
    private Long objectId;

    @Column(name = "c_object_type")
    private String objectType;
}
