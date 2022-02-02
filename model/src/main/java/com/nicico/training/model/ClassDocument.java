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
@Table(name = "tbl_class_document")
public class ClassDocument extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "class_document_seq")
    @SequenceGenerator(name = "class_document_seq", sequenceName = "seq_class_document_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "f_class_id")
    private Long classId;

    @Column(name = "c_letter_num", nullable = false)
    private String letterNum;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_letter_type", nullable = false, insertable = false, updatable = false)
    private ParameterValue letterType;

    @Column(name = "f_letter_type")
    private Long letterTypeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_reference", nullable = false, insertable = false, updatable = false)
    private ParameterValue reference;

    @Column(name = "f_reference")
    private Long referenceId;

    @Column(name = "c_description")
    private String description;
}
