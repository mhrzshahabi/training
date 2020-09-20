/*Mehran Golrokhi
1399/05/14
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
@Table(name = "tbl_message_contact")
public class MessageContact<E> extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "message_contact_seq")
    @SequenceGenerator(name = "message_contact_seq", sequenceName = "seq_message_contact_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_last_sent_date")
    private Date lastSentDate;

    @Column(name = "n_count_sent")
    private Integer countSent;

    @Column(name = "n_message_id")
    private Long returnMessageId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_message_contact_status_id", nullable = false, insertable = false, updatable = false)
    private ParameterValue status;

    @Column(name = "f_message_contact_status_id")
    private Long statusId;

    @Any(metaColumn = @Column(name = "c_object_type", nullable = false), fetch = FetchType.LAZY)
    @AnyMetaDef(idType = "long", metaType = "string",
            metaValues = {
                    @MetaValue(value = "ClassStudent", targetEntity = ClassStudent.class),
                    @MetaValue(value = "Teacher", targetEntity = Teacher.class),
            })
    @JoinColumn(name = "f_object", nullable = false, insertable = false, updatable = false)
    private E object;

    @Column(name = "f_object", nullable = false)
    private Long objectId;

    @Column(name = "c_object_type", nullable = false)
    private String objectType;

    @Column(name = "c_object_mobile", nullable = false)
    private String objectMobile;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_message_id", insertable = false, updatable = false)
    private Message message;

    @Column(name = "f_message_id")
    private Long messageId;

    @OneToMany(mappedBy = "messageContact", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MessageParameter> messageParameterList;

}

