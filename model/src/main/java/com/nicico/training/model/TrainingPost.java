package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Date;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Table(name = "tbl_training_post",
        uniqueConstraints = {@UniqueConstraint(columnNames = {"c_code", "c_people_type"})})
@DiscriminatorValue("TrainingPost")
public class TrainingPost extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "training_post_seq")
    @SequenceGenerator(name = "training_post_seq", sequenceName = "seq_training_post_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code",nullable = false, unique = false)//true
    private String code;

    @Column(name = "c_title_fa",nullable = false, unique = false)//true
    private String titleFa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_job_id")
    private Job job;

    @Column(name = "c_area")
    private String area;

    @Column(name = "c_mojtame_title")
    private String mojtameTitle;

    @Column(name = "c_assistance")
    private String assistance;

    @Column(name = "c_affairs")
    private String affairs;

    @Column(name = "c_section")
    private String section;

    @Column(name = "c_unit")
    private String unit;

    @Column(name = "c_cost_center_code")
    private String costCenterCode;

    @Column(name = "c_cost_center_title_fa")
    private String costCenterTitleFa;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_post_training_post",
            joinColumns = {@JoinColumn(name = "f_training_post_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_post_id", referencedColumnName = "id")})
    private Set<Post> postSet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_post_grade_id")
    private PostGrade postGrade;

    @ManyToMany(mappedBy = "trainingPostSet")
    private Set<PostGroup> postGroupSet;

    @Column(name = "c_people_type", length = 50)
    private String peopleType;

    @Column(name = "f_department_id")
    private Long departmentId;

    @Column(name = "d_last_modified_date_na")
    private Date lastModifiedDateNA;

    @Column(name = "c_modified_by_na")
    private String modifiedByNA;

//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "f_department_id", insertable = false, updatable = false)
//    private Department department;
}
