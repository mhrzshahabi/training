/*
ghazanfari_f, 9/12/2019, 2:20 PM
*/
package com.nicico.training.model;

import com.nicico.training.model.enums.EDomainType;
import com.nicico.training.model.enums.ENeedAssessmentPriority;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_need_assessment", uniqueConstraints = {@UniqueConstraint(columnNames = {"f_post_id", "f_competence_id", "e_domain_type", "e_need_assessment_priority"})})
public class NeedAssessment extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_need_assessment_id")
    @SequenceGenerator(name = "seq_need_assessment_id", sequenceName = "seq_need_assessment_id", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_post_id", insertable = false, updatable = false)
    private Post post;

    @Column(name = "f_post_id")
    private Long postId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_competence_id", insertable = false, updatable = false)
    private CompetenceOld competence;

    @Column(name = "f_competence_id")
    private Long competenceId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_skill_id", insertable = false, updatable = false)
    private Skill skill;

    @Column(name = "f_skill_id")
    private Long skillId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_skill_group_id", insertable = false, updatable = false)
    private SkillGroup skillgroup;

    @Column(name = "f_skill_group_id")
    private Long skillGroupId;

    @Column(name = "e_domain_type", insertable = false, updatable = false)
    private EDomainType eDomainType;

    @Column(name = "e_domain_type")
    private Integer edomainTypeId;

    @Column(name = "e_need_assessment_priority", insertable = false, updatable = false)
    private ENeedAssessmentPriority eNeedAssessmentPriority;

    @Column(name = "e_need_assessment_priority")
    private Integer eneedAssessmentPriorityId;

    @Column(name = "c_description")
    private String description;
}
