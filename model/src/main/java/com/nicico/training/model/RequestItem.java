package com.nicico.training.model;

import com.nicico.training.model.enums.RequestItemState;
import com.nicico.training.model.enums.RequestType;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_request_item")
public class RequestItem extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "request_item_seq")
    @SequenceGenerator(name = "request_item_seq", sequenceName = "seq_request_item_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "personnel_number")
    private String personnelNumber;

    @Column(name = "name")
    private String name;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "affairs")
    private String affairs;

    @Column(name = "post")
    private String post;

    @Column(name = "work_group_code")
    private String workGroupCode;

    @Column(name = "state")
    private RequestItemState state;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_competence_id", insertable = false, updatable = false)
    private CompetenceRequest competenceReq;

    @Column(name = "f_competence_id")
    private Long competenceReqId;


}
