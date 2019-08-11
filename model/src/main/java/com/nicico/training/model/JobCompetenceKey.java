package com.nicico.training.model;

/*
AUTHOR: ghazanfari_f
DATE: 6/2/2019
TIME: 3:32 PM
*/

import lombok.*;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Embeddable
public class JobCompetenceKey implements Serializable {

    @Column(name = "f_job_id")
    private Long jobId;

    @Column(name = "f_competence_id")
    private Long competenceId;
}