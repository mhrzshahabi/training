package com.nicico.training.model;

/*
AUTHOR: ghazanfari_f
DATE: 6/2/2019
TIME: 10:30 AM
*/

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = "id", callSuper = false)
@Entity
@Table(name = "tbl_job")
public class JobOld extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "seq_job_id")
    @SequenceGenerator(name = "seq_job_id", sequenceName = "seq_job_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

	@Column(name = "c_title_fa", nullable = false)
    private String titleFa;

	@Column(name = "c_title_en")
    private String titleEn;

	@Column(name = "c_code", nullable = false)
    private String code;

	@Column(name = "c_cost_center")
    private String costCenter;

	@Column(name = "c_description")
    private String description;

    @OneToMany(mappedBy = "job", cascade = CascadeType.REMOVE)
    private Set<JobCompetence> jobCompetenceSet;
}
