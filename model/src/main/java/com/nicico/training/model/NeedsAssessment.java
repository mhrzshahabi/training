/*
ghazanfari_f,
1/15/2020,
1:35 PM
*/
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Any;
import org.hibernate.annotations.AnyMetaDef;
import org.hibernate.annotations.MetaValue;

import javax.persistence.*;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
@Entity
@Table(name = "tbl_needs_assessment")
public class NeedsAssessment extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_needs_assessment_id")
    @SequenceGenerator(name = "seq_needs_assessment_id", sequenceName = "seq_needs_assessment_id", allocationSize = 1)
    private Long id;

    @Any(metaColumn = @Column(name = "c_object_type"))
    @AnyMetaDef(idType = "long", metaType = "string",
            metaValues = {
                    @MetaValue(targetEntity = Job.class, value = "Job"),
                    @MetaValue(targetEntity = JobGroup.class, value = "JobGroup"),
                    @MetaValue(targetEntity = Post.class, value = "Post"),
                    @MetaValue(targetEntity = PostGroup.class, value = "PostGroup"),
                    @MetaValue(targetEntity = PostGrade.class, value = "PostGrade"),
                    @MetaValue(targetEntity = PostGradeGroup.class, value = "PostGradeGroup"),
            })
    @JoinColumn(name = "f_object", nullable = false, insertable = false, updatable = false)
    private Object object;

    @Column(name = "f_object")
    private Long objectId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_competence", nullable = false, insertable = false, updatable = false)
    private Competence competence;

    @Column(name = "f_competence")
    private Long competenceId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value_needs_assessment_domain", nullable = false, insertable = false, updatable = false)
    private ParameterValue needsAssessmentDomain;

    @Column(name = "f_parameter_value_needs_assessment_domain")
    private Long needsAssessmentDomainId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value_needs_assessment_priority", nullable = false, insertable = false, updatable = false)
    private ParameterValue needsAssessmentPriority;

    @Column(name = "f_parameter_value_needs_assessment_priority")
    private Long needsAssessmentPriorityId;
}
