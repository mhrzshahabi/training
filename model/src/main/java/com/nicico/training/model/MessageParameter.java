/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/19
 * Last Modified: 2020/09/19
 */



package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import javax.persistence.*;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_message_parameter")
public class MessageParameter<E> extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "message_parameter_seq")
    @SequenceGenerator(name = "message_parameter_seq", sequenceName = "seq_message_parameter_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_name", nullable = false)
    private String name;

    @Column(name = "c_value", nullable = false)
    private String value;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_message_contact_id", insertable = false, updatable = false)
    private MessageContact messageContact;

    @Column(name = "f_message_contact_id")
    private Long messageContactId;

}

