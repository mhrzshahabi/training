package com.nicico.training.model;

import com.nicico.training.model.compositeKey.RequestItemAuditKey;
import com.nicico.training.model.enums.RequestItemState;
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
@EqualsAndHashCode(callSuper = false)
@Entity
@Subselect("select * from tbl_request_aud")
@DiscriminatorValue("RequestAudit")
public class RequestAudit implements Serializable {
    @EmbeddedId
    private RequestItemAuditKey auditId;

    @Column(name = "id", insertable = false, updatable = false, precision = 10)
    private Long id;

   @Column(name = "response",nullable = false,updatable = false)
   private String response;

   @Column(name="request_status",nullable = false,updatable = false)
   private String requestStatus;

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

    @Column
    private String name;
}
