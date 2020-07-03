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
@Table(name = "tbl_post_group")
@DiscriminatorValue("PostGroup")
public class PostGroup extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "post_group_seq")
    @SequenceGenerator(name = "post_group_seq", sequenceName = "seq_post_group_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_code", unique = true)
    private String code;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_description", length = 500)
    private String description;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_post_postgroup",
            joinColumns = {@JoinColumn(name = "f_postgroup_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_post_id", referencedColumnName = "id")})
    private Set<Post> postSet;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_training_post_post_group",
            joinColumns = {@JoinColumn(name = "f_post_group_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_training_post_id", referencedColumnName = "id")})
    private Set<TrainingPost> trainingPostSet;
}
