//package com.nicico.training.model;
//
//import com.nicico.training.model.enums.ELevelType;
//import com.nicico.training.model.enums.ERunType;
//import com.nicico.training.model.enums.ETechnicalType;
//import com.nicico.training.model.enums.ETheoType;
//import lombok.*;
//import lombok.experimental.Accessors;
//import org.hibernate.envers.AuditOverride;
//import org.hibernate.envers.Audited;
//import org.hibernate.envers.NotAudited;
//import org.hibernate.envers.RelationTargetAuditMode;
//
//import javax.persistence.*;
//import java.io.Serializable;
//import java.util.List;
//import java.util.Objects;
//import java.util.Set;
//
//@Getter
//@Setter
//
//@AllArgsConstructor
//@Accessors(chain = true)
//@EqualsAndHashCode(of = {"id"}, callSuper = false)
//@Entity
//@NoArgsConstructor
//@Table(name = "tbl_committee_of_experts_registered")
//@Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
//@AuditOverride(forClass =Auditable.class )
//public class CommitteePersonnelRegistred  {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "committee_reg_seq")
//    @SequenceGenerator(name = "committee_reg_seq", sequenceName = "seq_committee_reg_id", allocationSize = 1)
//    @Column(name = "id", precision = 10)
//    private Long id ;
//
//    @ManyToOne(fetch = FetchType.LAZY)
////    @Column("f_committee_id")
//    @JoinColumn(name = "f_committee_id", insertable = false, updatable = false)
//    private CommitteeOfExperts committeeOfExpertsForReg;
//
//    @ManyToOne(fetch = FetchType.LAZY)
////    @Column("f_personnel_id")
//    @JoinColumn(name = "f_personnel_id", insertable = false, updatable = false)
//    private PersonnelRegistered personnelReg;
//
//
//    @Column(name = "role")
//    private String role;
//
//
//}
