/*
ghazanfari_f,
1/8/2020,
2:41 PM
*/
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
@EqualsAndHashCode(of = "id")
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

//    @OneToMany(mappedBy = "questionnaire", fetch = FetchType.LAZY)
//    private List<QuestionnaireQuestion> questionnaireQuestionSet;

}

