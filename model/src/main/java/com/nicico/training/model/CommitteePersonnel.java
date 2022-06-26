package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.envers.AuditOverride;
import org.hibernate.envers.Audited;
import org.hibernate.envers.RelationTargetAuditMode;

import javax.persistence.*;


@Getter
@Setter
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@NoArgsConstructor
@Table(name = "tbl_committee_of_experts_personnel")
@Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
public class CommitteePersonnel {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "committee_personnel_seq")
    @SequenceGenerator(name = "committee_personnel_seq", sequenceName = "seq_committee_personnel_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id ;

    @ManyToOne(fetch = FetchType.LAZY)
//    @Column("f_committee_id")
    @JoinColumn(name = "f_committee_id", insertable = false, updatable = false)
    private CommitteeOfExperts committeeOfExperts;

    @ManyToOne(fetch = FetchType.LAZY)
//    @Column("f_personnel_id")
    @JoinColumn(name = "f_personnel_id", insertable = false, updatable = false)
    private Personnel personnel;


    @Column(name = "role")
    private String role;


}