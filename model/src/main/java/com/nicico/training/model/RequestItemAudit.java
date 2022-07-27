package com.nicico.training.model;

import com.nicico.training.model.compositeKey.RequestItemAuditKey;
import com.nicico.training.model.enums.RequestItemState;
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
@EqualsAndHashCode(callSuper = false)
@Entity
@Subselect("select * from tbl_request_item_aud")
@DiscriminatorValue("RequestItemAudit")
public class RequestItemAudit implements Serializable {

    @EmbeddedId
    private RequestItemAuditKey auditId;

    @Column(name = "id", insertable = false, updatable = false, precision = 10)
    private Long id;

    @Column(name = "personnel_number")
    private String personnelNumber;

    @Column(name = "emp_no")
    private String personnelNo2;

    @Column(name = "name")
    private String name;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "affairs")
    private String affairs;

    @Column(name = "post")
    private String post;

    @Column(name = "national_code")
    private String nationalCode;

    @Column(name = "state")
    private RequestItemState state;

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
