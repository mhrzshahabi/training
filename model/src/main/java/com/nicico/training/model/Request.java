package com.nicico.training.model;


import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.model.enums.UserRequestType;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@Entity
@Table(name = "tbl_Request")
public class Request extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "request_seq")
    @SequenceGenerator(name = "request_seq", sequenceName = "request_seq_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column
    private String text;
    @Column
    private String nationalCode;
    @Column
    private String name;

    @Column
    private String response;

    @Column
    private String fmsReference;

    @Column
    private String groupId;

    @Column(name = "REQUEST_TYPE")
    @Enumerated(EnumType.STRING)
    private UserRequestType type;

    @Column(name = "REQUEST_STATUS")
    @Enumerated(EnumType.STRING)
    private RequestStatus status;

    private String reference;

    @PrePersist
    public void setReference(){
        reference= UUID.randomUUID().toString();
        status=RequestStatus.ACTIVE;
    }
}
