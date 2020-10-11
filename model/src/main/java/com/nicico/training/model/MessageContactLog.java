/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/09/30
 */

package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Any;
import org.hibernate.annotations.AnyMetaDef;
import org.hibernate.annotations.MetaValue;

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
@Table(name = "tbl_message_contact_log")
public class MessageContactLog extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "message_contact_log_seq")
    @SequenceGenerator(name = "message_contact_log_seq", sequenceName = "seq_message_contact_log_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "return_message_id")
    private String returnMessageId;

    @Column(name = "error_message")
    private String errorMessage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_message_contact_id", insertable = false, updatable = false)
    private MessageContact messageContact;

    @Column(name = "f_message_contact_id")
    private Long messageContactId;
}

