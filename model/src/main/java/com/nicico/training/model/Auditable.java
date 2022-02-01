package com.nicico.training.model;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "e_enabled", insertable = false, updatable = false)
    /////pEnabled and pDeleted is not enabled and deleted because conflict with "Student and PersonnelRegistered" entities
    private ParameterValue pEnabled;

    @Column(name = "e_enabled")
    Long enabled;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "e_deleted", insertable = false, updatable = false)
    /////pEnabled and pDeleted is not enabled and deleted because conflict with "Student and PersonnelRegistered" entities
    private ParameterValue pDeleted;

    @Column(name = "e_deleted")
    Long deleted;

    @LastModifiedDate
    @Column(name = "d_last_modified_date")
    private Date lastModifiedDate;
    @LastModifiedBy
    @Column(name = "c_last_modified_by")
    private String lastModifiedBy;
    @Version
    @Column(name = "n_version", nullable = false)
    private Integer version;
}
