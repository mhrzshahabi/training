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
@Table(name = "tbl_attachment",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_entity_name", "n_object_id", "c_file_name", "c_file_type"})})
public class Attachment extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "attachment_seq")
    @SequenceGenerator(name = "attachment_seq", sequenceName = "seq_attachment_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_entity_name", nullable = false)
    private String entityName;

    @Column(name = "n_object_id", nullable = false)
    private Long objectId;

    @Column(name = "c_file_name", nullable = false)
    private String fileName;

    @Column(name = "c_file_type", nullable = false)
    private String fileType;

    @Column(name = "c_description", length = 500)
    private String description;
}
