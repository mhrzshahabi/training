package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Any;
import org.hibernate.annotations.AnyMetaDef;
import org.hibernate.annotations.MetaValue;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@DiscriminatorValue("NeedsAssessmentWithGap")
@Table(name = "tbl_needs_assessment_with_gap")
public class NeedsAssessmentWithGap<E> extends Auditable {


    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "needs_assessment_with_gap_seq")
    @SequenceGenerator(name = "needs_assessment_with_gap_seq", sequenceName = "seq_needs_assessment_with_gap_id", allocationSize = 1)
    private Long id;

    @Any(metaColumn = @Column(name = "c_object_type", nullable = false), fetch = FetchType.LAZY)
    @AnyMetaDef(idType = "long", metaType = "string",
            metaValues = {
                    @MetaValue(value = "Job", targetEntity = Job.class),
                    @MetaValue(value = "JobGroup", targetEntity = JobGroup.class),
                    @MetaValue(value = "Post", targetEntity = Post.class),
                    @MetaValue(value = "TrainingPost", targetEntity = TrainingPost.class),
                    @MetaValue(value = "PostGroup", targetEntity = PostGroup.class),
                    @MetaValue(value = "PostGrade", targetEntity = PostGrade.class),
                    @MetaValue(value = "PostGradeGroup", targetEntity = PostGradeGroup.class),
            })
    @JoinColumn(name = "f_object", nullable = false, insertable = false, updatable = false)
    private E object;

    @Column(name = "f_object", nullable = false)
    private Long objectId;

    @Column(name = "c_object_type", nullable = false)
    private String objectType;

    @Column(name = "c_object_name")
    private String objectName;

    @Column(name = "c_object_code")
    private String objectCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_competence", nullable = false, insertable = false, updatable = false)
    private Competence competence;

    @Column(name = "f_competence", nullable = false)
    private Long competenceId;

    @Column(name = "limit_sufficiency")
    private Float limitSufficiency;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_skill", nullable = false, insertable = false, updatable = false)
    private Skill skill;

    @Column(name = "f_skill", nullable = false)
    private Long skillId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value_needs_assessment_domain", nullable = false, insertable = false, updatable = false)
    private ParameterValue needsAssessmentDomain;

    @Column(name = "f_parameter_value_needs_assessment_domain", nullable = false)
    private Long needsAssessmentDomainId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value_needs_assessment_priority", nullable = false, insertable = false, updatable = false)
    private ParameterValue needsAssessmentPriority;

    @Column(name = "f_parameter_value_needs_assessment_priority", nullable = false)
    private Long needsAssessmentPriorityId;


    @Column(name = "c_main_workflow_status")
    private String mainWorkflowStatus;

    @Column(name = "n_main_workflow_status_code")
    private Integer mainWorkflowStatusCode;


    @Column(name = "process_instance_id")
    private String processInstanceId;


    @Column(name = "return_detail")
    private String returnDetail;


}
