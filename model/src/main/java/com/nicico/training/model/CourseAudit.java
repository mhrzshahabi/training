package com.nicico.training.model;

import com.nicico.training.model.compositeKey.AuditCourseId;
import com.nicico.training.model.enums.ETechnicalType;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from TBL_COURSE_AUD")
@DiscriminatorValue("CourseAudit")
public class CourseAudit implements Serializable {

    @EmbeddedId
    private AuditCourseId id;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "n_theory_duration")
    private Float theoryDuration;

    @Column(name = "c_description")
    private String description;

    @Column(name = "n_min_teacher_eval_score")
    private String minTeacherEvalScore;

    @Column(name = "n_min_teacher_exp_years")
    private String minTeacherExpYears;

    @Column(name = "n_min_teacher_degree")
    private String minTeacherDegree;

    @Column(name = "c_evaluation")
    private String evaluation;

    @Column(name = "c_behavioral_level")
    private String behavioralLevel;

    @Column(name = "e_technical_type")
    private ETechnicalType eTechnicalType;

    @Column(name = "scoring_method")
    private String scoringMethod;

    @Column(name = "c_acceptance_limit")
    private String acceptancelimit;

    @Column(name = "start_evaluation")
    private Integer startEvaluation;

    @Column(name = "d_created_date")
    protected Date createdDate;

    @Column(name = "C_CREATED_BY")
    private String createdBy;

    @Column(name = "d_last_modified_date")
    private Date lastModifiedDate;

    @Column(name = "C_LAST_MODIFIED_BY")
    private String lastModifiedBy;

    @Column(name = "REVTYPE")
    private Long revType;

    @Column(name = "e_deleted")
    private Long deleted;
}
