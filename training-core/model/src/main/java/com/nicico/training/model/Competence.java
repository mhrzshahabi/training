package com.nicico.training.model;

/*
AUTHOR: ghazanfari_f
DATE: 6/2/2019
TIME: 9:26 AM
*/

import com.nicico.training.model.enums.ECompetenceInputType;
import com.nicico.training.model.enums.ETechnicalType;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotEmpty;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(schema = "training", name = "tbl_competence")
public class Competence extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_competence_id")
    @SequenceGenerator(name = "seq_competence_id", sequenceName = "seq_competence_id", allocationSize = 1)
    private Long id;

    @Column(name = "titleFa", nullable = false)
    @NotEmpty
    private String titleFa;

    @Column(name = "titleEn")
    private String titleEn;

    @Column(name = "description")
    private String description;

    @Column(name = "e_technical_type")
    private ETechnicalType eTechnicalType;

    @Column(name = "e_Competence_input_type")
    private ECompetenceInputType eCompetenceInputType;

    @Column(name = "wf_status")
    private Integer wStatus;

/*    @ElementCollection(targetClass = EDomainType.class)
    @CollectionTable(name = "tbl_competence_domain_type",
            joinColumns = @JoinColumn(name = "f_competence_id"))
    @Column(name = "e_domain_type")
    private Set<EDomainType> eDomainTypeSet;*/

    @OneToMany(mappedBy = "competence", cascade = CascadeType.REMOVE)
    private Set<JobCompetence> jobCompetenceSet;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(schema = "training", name = "tbl_competence_skill", joinColumns = @JoinColumn(name = "f_competence_id"),
            inverseJoinColumns = @JoinColumn(name = "f_skill_id"))
    private Set<Skill> skillSet;

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(schema = "training", name = "tbl_competence_skill_group", joinColumns = @JoinColumn(name = "f_competence_id"),
            inverseJoinColumns = @JoinColumn(name = "f_skill_group_id"))
    private Set<SkillGroup> skillGroupSet;

}
