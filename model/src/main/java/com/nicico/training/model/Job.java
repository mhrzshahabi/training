package com.nicico.training.model;

import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;
import java.util.Date;
import java.util.Set;

@Getter
@Entity
@Immutable
@DiscriminatorValue("Job")
@Table(name = "tbl_job",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_code", "c_people_type"})})
public class Job extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "c_people_type", length = 50)
    private String peopleType;

    @ManyToMany(mappedBy = "jobSet", fetch = FetchType.LAZY)
    private Set<JobGroup> jobGroupSet;

    @OneToMany(mappedBy = "job", fetch = FetchType.LAZY)
    private Set<Post> postSet;

    @OneToMany(mappedBy = "job", fetch = FetchType.LAZY)
    private Set<TrainingPost> trainingPostSet;

    @Column(name = "d_last_modified_date_na")
    private Date lastModifiedDateNA;

    @Column(name = "c_modified_by_na")
    private String modifiedByNA;
}