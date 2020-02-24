/*
ghazanfari_f,
1/26/2020,
5:24 PM
*/
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
@Table(name = "tbl_needs_assessment")
public class NeedsAssessment<E> extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_needs_assessment_id")
    @SequenceGenerator(name = "seq_needs_assessment_id", sequenceName = "seq_needs_assessment_id", allocationSize = 1)
    private Long id;

    @Any(metaColumn = @Column(name = "c_object_type", nullable = false), fetch = FetchType.LAZY)
    @AnyMetaDef(idType = "long", metaType = "string",
            metaValues = {
                    @MetaValue(value = "Job", targetEntity = Job.class),
                    @MetaValue(value = "JobGroup", targetEntity = JobGroup.class),
                    @MetaValue(value = "Post", targetEntity = Post.class),
                    @MetaValue(value = "PostGroup", targetEntity = PostGroup.class),
                    @MetaValue(value = "PostGrade", targetEntity = PostGrade.class),
                    @MetaValue(value = "PostGradeGroup", targetEntity = PostGradeGroup.class),
            })
    @JoinColumn(name = "f_object", nullable = false, insertable = false, updatable = false)
    private E object;

    @Column(name = "f_object")
    private Long objectId;

    @Column(name = "c_object_type")
    private String objectType;

    @Column(name = "c_object_name")
    private String objectName;

    @Column(name = "c_object_code")
    private String objectCode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_competence", nullable = false, insertable = false, updatable = false)
    private Competence competence;

    @Column(name = "f_competence")
    private Long competenceId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_skill", nullable = false, insertable = false, updatable = false)
    private Skill skill;

    @Column(name = "f_skill")
    private Long skillId;

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

    public static List<String> priorityList = new ArrayList<String>() {
        {
            add("Post");
            add("PostGroup");
            add("Job");
            add("JobGroup");
            add("PostGrade");
            add("PostGradeGroup");
        }
    };

    @Column(name = "c_workflow_status")
    private String workflowStatus;

    @Column(name = "n_workflow_status_code")
    private Integer workflowStatusCode;

    @Column(name = "c_main_workflow_status")
    private String mainWorkflowStatus;

    @Column(name = "n_main_workflow_status_code")
    private Integer mainWorkflowStatusCode;
}
