package com.nicico.training.model;

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
@Table(name = "tbl_need_assessment_skill_post", uniqueConstraints = {@UniqueConstraint(columnNames = {"f_skill_id", "f_post_id"})})
public class NeedAssessmentSkillToPost extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_need_assessment_skill_post_id")
    @SequenceGenerator(name = "seq_need_assessment_skill_post_id", sequenceName = "seq_need_assessment_skill_post_id", allocationSize = 1)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_skill_id", insertable = false, updatable = false)
    private Skill skill;

    @Column(name = "f_skill_id", nullable = false)
    private Long skillId;

    @Column(name = "e_need_assessment_priority", insertable = false, updatable = false, nullable = false)
    private ENeedAssessmentPriority eNeedAssessmentPriority;

    @Column(name = "e_need_assessment_priority", nullable = false)
    private Integer eNeedAssessmentPriorityId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_post_id", insertable = false, updatable = false)
    private Post post;

    @Column(name = "f_post_id", nullable = false)
    private Long postId;

}
