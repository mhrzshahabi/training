package com.nicico.training.model;

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
@Table(name = "tbl_competence_req")
public class CompetenceRequest extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "competence_req_seq")
    @SequenceGenerator(name = "competence_req_seq", sequenceName = "seq_competence_req_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "applicant")
    private String applicant;

    @Column(name = "request_date")
    private Date requestDate;

    @Column(name = "request_type")
    private RequestType requestType;

    @Column(name = "letter_number")
    private String letterNumber;

    @OneToMany(mappedBy = "competenceReq", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RequestItem> requestItems;
}
