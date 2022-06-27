package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.envers.AuditOverride;
import org.hibernate.envers.Audited;
import org.hibernate.envers.RelationTargetAuditMode;

import javax.persistence.*;


@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_committee_of_experts_personnel")
 public class CommitteePersonnel {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "committee_personnel_seq")
    @SequenceGenerator(name = "committee_personnel_seq", sequenceName = "seq_committee_personnel_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id ;

    @ManyToOne
    @JoinColumn(name = "f_committee_id", insertable = false, updatable = false)
    private CommitteeOfExperts committeeOfExperts;

   @Column(name = "f_committee_id")
   private Long committeeOfExpertId;

    @Column(name = "role")
    private String role;


    @Column(name = "object_type")
    private String objectType;

    @Column(name = "object_id")
    private Long objectId;


}