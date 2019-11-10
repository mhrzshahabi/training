
package com.nicico.training.model;

import com.nicico.training.model.enums.ENeedAssessmentPriority;
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
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_need_assessment_skill_based", uniqueConstraints = {@UniqueConstraint(columnNames = {"f_skill_id", "c_object_type", "f_object_id"})})
public class NeedAssessmentSkillBased<E> extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_need_assessment_skill_based_id")
    @SequenceGenerator(name = "seq_need_assessment_skill_based_id", sequenceName = "seq_need_assessment_skill_based_id", allocationSize = 1)
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

    @Any(
            metaColumn = @Column(name = "c_object_type", nullable = false, length = 30),
            fetch = FetchType.LAZY
    )
    @AnyMetaDef(
            idType = "long", metaType = "string",
            metaValues = {
                    @MetaValue(targetEntity = Job.class, value = "job"),
                    @MetaValue(targetEntity = JobGroup.class, value = "job_group"),
                    @MetaValue(targetEntity = Post.class, value = "post"),
                    @MetaValue(targetEntity = PostGroup.class, value = "post_group")
            }
    )
    @JoinColumn(name = "f_object_id", nullable = false, insertable = false, updatable = false)
    private E object;

    @Column(name = "f_object_id", nullable = false)
    private Long objectId;
}
