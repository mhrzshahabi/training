package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_job")
@DiscriminatorValue("ViewJob")
public class ViewJob extends Auditable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_code", unique = true, nullable = false)
    private String code;

    @Column(name = "n_competence_count")
    private Integer competenceCount;

    @Column(name = "n_personnel_count")
    private Integer personnelCount;

    @ManyToMany(mappedBy = "jobSet", fetch = FetchType.LAZY)
    private Set<JobGroup> jobGroupSet;
}
