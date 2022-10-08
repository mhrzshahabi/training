package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_request_item_process_detail")
public class RequestItemProcessDetail extends Auditable implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "request_item_process_detail_seq")
    @SequenceGenerator(name = "request_item_process_detail_seq", sequenceName = "seq_request_item_process_detail_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_expert_national_code")
    private String expertNationalCode;

    @Column(name = "c_role_name")
    private String roleName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_request_item_id", nullable = false, insertable = false, updatable = false)
    private RequestItem requestItem;

    @Column(name = "f_request_item_id")
    private Long requestItemId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_experts_opinion_id", insertable = false, updatable = false)
    private ParameterValue expertsOpinion;

    @Column(name = "f_experts_opinion_id")
    private Long expertsOpinionId;

}
