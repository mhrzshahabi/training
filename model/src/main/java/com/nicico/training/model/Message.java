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
@DiscriminatorValue("Message")
public class Message extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "message_seq")
    @SequenceGenerator(name = "message_seq", sequenceName = "seq_message_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_context_text", nullable = false)
    private String contextText;

    @Column(name = "c_context_html", nullable = false)
    private String contextHtml;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_message_ParameterValue",
            joinColumns = {@JoinColumn(name = "f_message_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_parameter_value_id", referencedColumnName = "id")})
    private List<ParameterValue> sendWays;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_message_user_type", nullable = false, insertable = false, updatable = false)
    private ParameterValue userType;

    @OneToMany(mappedBy = "id", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<MessageContact> messageContactList;

}
