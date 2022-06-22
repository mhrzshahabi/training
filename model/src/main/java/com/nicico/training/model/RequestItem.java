package com.nicico.training.model;

import com.nicico.training.model.enums.RequestItemState;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.envers.AuditOverride;
import org.hibernate.envers.Audited;
import org.hibernate.envers.NotAudited;
import org.hibernate.envers.RelationTargetAuditMode;

import javax.persistence.*;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_request_item")
@Audited(targetAuditMode = RelationTargetAuditMode.NOT_AUDITED)
@AuditOverride(forClass = Auditable.class)
public class RequestItem extends Auditable implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "request_item_seq")
    @SequenceGenerator(name = "request_item_seq", sequenceName = "seq_request_item_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
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

    @NotAudited
    @Column(name = "post_title")
    private String postTitle;

    @NotAudited
    @Column(name = "current_post_title")
    private String currentPostTitle;

    @Column(name = "work_group_code")
    private String workGroupCode;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "TBL_REQUEST_ITEM_OPERATIONAL_ROLE_IDS", joinColumns = @JoinColumn(name = "F_REQUEST_ITEM"))
    @Column(name = "OPERATIONAL_ROLE_IDS")
    @NotAudited
    private List<Long> operationalRoleIds;

    @Column(name = "national_code")
    private String nationalCode;

    @NotAudited
    @Column(name = "education_level")
    private String educationLevel;

    @NotAudited
    @Column(name = "education_major")
    private String educationMajor;

    @Column(name = "state")
    private RequestItemState state;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_competence_id", insertable = false, updatable = false)
    @NotAudited
    private CompetenceRequest competenceReq;

    @Column(name = "f_competence_id")
    @NotAudited
    private Long competenceReqId;

    @Column(name = "process_instance_id")
    @NotAudited
    private String processInstanceId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_process_status_id", insertable = false, updatable = false)
    @NotAudited
    private ParameterValue processStatus;

    @Column(name = "f_process_status_id")
    @NotAudited
    private Long processStatusId;

    @Column(name = "c_return_detail")
    @NotAudited
    private String returnDetail;
}
