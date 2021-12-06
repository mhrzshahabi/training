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

    @Column(name = "C_CREATED_BY")
    private String createdBy;

    @Column(name = "C_LAST_MODIFIED_BY")
    private String modifiedBy;
}
