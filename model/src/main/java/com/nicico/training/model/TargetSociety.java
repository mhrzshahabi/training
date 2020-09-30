package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_target_society")
public class TargetSociety extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_target_society_id")
    @SequenceGenerator(name = "seq_target_society_id", sequenceName = "seq_target_society_id", allocationSize = 1)
    private Long id;

    @Column(name = "f_society_id")
    private Long societyId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_society_id", insertable = false, updatable = false)
    private Department society;

    @Column(name = "c_title")
    private String title;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_class_id", insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "f_class_id")
    private Long tclassId;
}
