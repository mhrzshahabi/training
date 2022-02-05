package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_questionnaire")
public class Questionnaire extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_questionnaire_id")
    @SequenceGenerator(name = "seq_questionnaire_id", sequenceName = "seq_questionnaire_id", allocationSize = 1)
    private Long id;

    @Column(name = "c_title", nullable = false)
    private String title;

    @Column(name = "c_description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="f_parameter_value",nullable = false,insertable = false,updatable = false)
    private ParameterValue questionnaireType;

    @Column(name="f_parameter_value")
    private Long questionnaireTypeId;

    @OneToMany(mappedBy = "questionnaire", fetch = FetchType.EAGER)
    private List<QuestionnaireQuestion> questionnaireQuestionList;

    @Column(name = "lock_status")
    private Boolean lockStatus;
}

