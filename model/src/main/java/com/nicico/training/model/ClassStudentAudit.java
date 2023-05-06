package com.nicico.training.model;

import com.nicico.training.model.compositeKey.AuditClassStudentId;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from tbl_class_student_aud")
@DiscriminatorValue("ClassStudentAudit")
public class ClassStudentAudit implements Serializable {

    @EmbeddedId
    private AuditClassStudentId id;

    @Column(name = "student_id")
    private Long studentId;

    @Column(name = "class_id")
    private Long tclassId;

    @Column(name = "failure_reason_id")
    private Long failureReasonId;

    @Column(name = "score")
    private Float score;

    @Column(name = "scores_state_id")
    private Long scoresStateId;

    @Column(name = "TEST_SCORE")
    private Float testScore;

    @Column(name = "DESCRIPTIVEـSCORE")
    private Float descriptiveScore;

    @Column(name = "C_CREATED_BY")
    private String createdBy;

    @Column(name = "C_LAST_MODIFIED_BY")
    private String modifiedBy;

    @Column(name = "class_score")
    private Double classScore;

    @Column(name = "practical_score")
    private Double practicalScore;

    @Column(name = "els_status")
    private Boolean elsStatus;
}
