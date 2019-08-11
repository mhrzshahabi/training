package com.nicico.training.model;

/*
AUTHOR: ghazanfari_f
DATE: 6/3/2019
TIME: 7:22 AM
*/

import com.nicico.training.model.enums.EJobCompetenceType;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode
@Entity
@Table(schema = "training", name = "tbl_job_competence")
public class JobCompetence {

    @EmbeddedId
    private JobCompetenceKey id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("f_job_id")
    @JoinColumn(name = "f_job_id")
    private Job job;

    @ManyToOne(fetch = FetchType.EAGER)
    @MapsId("f_competence_id")
    @JoinColumn(name = "f_competence_id")
    private Competence competence;

    @Column(name = "e_job_competence_type", insertable = false, updatable = false)
    private EJobCompetenceType eJobCompetenceType;

    @Column(name = "e_job_competence_type")
    private Integer eJobCompetenceTypeId;

    public JobCompetence(Job job, Competence competence) {
        this.job = job;
        this.competence = competence;
        this.id = new JobCompetenceKey(job.getId(), competence.getId());
    }
}