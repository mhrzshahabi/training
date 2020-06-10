/*
ghazanfari_f, 8/29/2019, 9:11 AM
*/
package com.nicico.training.model;

import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.*;
import java.util.Set;

@Getter
@Entity
@Immutable
@DiscriminatorValue("Job")
@Table(name = "tbl_job")
public class Job extends Auditable {

    @Id
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", nullable = false, unique = true)
    private String code;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @ManyToMany(mappedBy = "jobSet", fetch = FetchType.LAZY)
    private Set<JobGroup> jobGroupSet;

    @OneToMany(mappedBy = "job", fetch = FetchType.LAZY)
    private Set<Post> postSet;
}