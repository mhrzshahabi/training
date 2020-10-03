/*Mehran Golrokhi
1399/05/14
*/

package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_message")
public class Message extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "message_seq")
    @SequenceGenerator(name = "message_seq", sequenceName = "seq_message_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_context_text", nullable = false, length = 2000)
    private String contextText;

    @Column(name = "c_context_html", nullable = false, length = 2000)
    private String contextHtml;

    @Column(name = "c_pid", nullable = false)
    private String PId;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_message_parameter_value",
            joinColumns = {@JoinColumn(name = "f_message_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_parameter_value_id", referencedColumnName = "id")})
    private List<ParameterValue> sendWays;

    @ManyToOne
    @JoinColumn(name = "f_message_user_type", nullable = false, insertable = false, updatable = false)
    private ParameterValue userType;

    @Column(name = "f_message_user_type")
    private Long userTypeId;

    @OneToMany(mappedBy = "message", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MessageContact> messageContactList;

    @Column(name = "n_count_send", nullable = false)
    private Integer countSend;

    @Column(name = "n_interval", nullable = false)
    private Integer Interval;

    @ManyToOne
    @JoinColumn(name = "f_message_class", insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "f_message_class")
    private Long tclassId;

    @ManyToOne
    @JoinColumn(name = "f_orginal_message_message", insertable = false, updatable = false)
    private Message orginalMessage;

    @Column(name = "f_orginal_message_message")
    private Long orginalMessageId;
}
