package com.nicico.training.model;

import com.nicico.training.model.enums.EDeleted;
import com.nicico.training.model.enums.EEnabled;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.Column;
import javax.persistence.EntityListeners;
import javax.persistence.MappedSuperclass;
import javax.persistence.Version;
import java.util.Date;

@Getter
@Setter
@Accessors(chain = true)
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class Auditable {
    @CreatedDate
    @Column(name = "d_created_date", nullable = false, updatable = false)
    protected Date createdDate;

    @CreatedBy
    @Column(name = "c_created_by", nullable = false, updatable = false)
    protected String createdBy;

    @LastModifiedDate
    @Column(name = "d_last_modified_date")
    private Date lastModifiedDate;

    @LastModifiedBy
    @Column(name = "c_last_modified_by")
    private String lastModifiedBy;

    @Version
    @Column(name = "n_version", nullable = false)
    private Integer version;

    @Column(name = "e_enabled")
    EEnabled eEnabled;

    @Column(name = "e_deleted")
    EDeleted eDeleted;

}
