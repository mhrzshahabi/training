package com.nicico.training.model;

import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.model.enums.UserRequestType;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.envers.AuditOverride;
import org.hibernate.envers.Audited;
import org.hibernate.envers.NotAudited;
import org.hibernate.envers.RelationTargetAuditMode;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@Entity
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
@AuditOverride(forClass = Auditable.class)
@Table(name = "tbl_Request")
public class Request extends Auditable implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "request_seq")
    @SequenceGenerator(name = "request_seq", sequenceName = "request_seq_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column
    @NotAudited
    private String text;

    @Column(name = "NATIONAL_CODE")
    @NotAudited
    private String nationalCode;

    @Column
    private String name;

    @Column
    private String response;

    @Column(name = "FMS_REFERENCE")
    @NotAudited
    private String fmsReference;

    @Column(name = "GROUP_ID")
    @NotAudited
    private String groupId;

    @Column(name = "REQUEST_TYPE")
    @Enumerated(EnumType.STRING)
    @NotAudited
    private UserRequestType type;

    @Column(name = "REQUEST_STATUS")
    @Enumerated(EnumType.STRING)
    private RequestStatus status;

    @NotAudited
    private String reference;

    @Column(name = "CLASS_ID")
    @NotAudited
    private Long classId;

    @Column(name = "process_instance_id")
    @NotAudited
    private String processInstanceId;

    @Column(name = "c_return_detail")
    @NotAudited
    private String returnDetail;

    @Transient
    private List<Attachment> requestAttachments;

    @Transient
    private List<Attachment> responseAttachments;

    @PrePersist
    @NotAudited
    public void setReference(){
        reference= UUID.randomUUID().toString();
        status=RequestStatus.ACTIVE;
    }
}
