package com.nicico.training.model;

import com.nicico.training.model.compositeKey.AuditAttendanceId;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from TBL_ATTENDANCE_AUD")
@DiscriminatorValue("AttendanceAudit")
public class AttendanceAudit implements Serializable {

    @EmbeddedId
    private AuditAttendanceId id;

    @Column(name = "c_state")
    private String state;

    @Column(name = "c_description")
    private String description;

    @Column(name = "f_student", nullable = false)
    private Long studentId;

    @Column(name = "f_session", nullable = false)
    private Long sessionId;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "f_session", insertable = false, updatable = false)
    private ClassSession session;

    @Column(name = "d_created_date", nullable = false, updatable = false)
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
