package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_skill_group", schema = "TRAINING")
public class SkillGroup extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "skill_group_seq")
    @SequenceGenerator(name = "skill_group_seq", sequenceName = "seq_skill_group_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_description", length = 500)
    private String description;

    @ManyToMany(cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @JoinTable(name = "tbl_skill_skillgroup", schema = "TRAINING",
            joinColumns = {@JoinColumn(name = "f_skillgroup_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_skill_id", referencedColumnName = "id")})
    private Set<Skill> skillSet;

   // @ManyToMany(mappedBy = "skillGroupSet" )
   @ManyToMany(fetch = FetchType.EAGER)
   @JoinTable(schema = "training", name = "tbl_competence_skill_group", joinColumns = @JoinColumn(name = "f_skill_group_id"),
           inverseJoinColumns = @JoinColumn(name = "f_competence_id"))
    private Set<Competence> competenceSet;

}
