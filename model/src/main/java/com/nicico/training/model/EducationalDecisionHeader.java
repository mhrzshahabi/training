package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_educational_decision_header")
public class EducationalDecisionHeader extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "educational_decision_header_seq")
    @SequenceGenerator(name = "educational_decision_header_seq", sequenceName = "seq_educational_decision_header_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "complex")
    private String complex;

    @Column(name = "item_from_date")
    private String itemFromDate;

    @Column(name = "item_to_date")
    private String itemToDate;

    @OneToMany(mappedBy = "educationalDecisionHeader", fetch = FetchType.LAZY)
    private List<EducationalDecision> educationalDecisionList;
}