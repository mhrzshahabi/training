package com.nicico.training.model;/* com.nicico.training.model
@Author:jafari-h
@Date:5/26/2019
@Time:10:14 AM
*/

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_goal")
public class Goal extends Auditable
{
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "goal_seq")
    @SequenceGenerator(name = "goal_seq", sequenceName = "seq_goal_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "goal")
    private Set<Syllabus> syllabusSet;

    @ManyToMany(cascade = {CascadeType.DETACH, CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH}, mappedBy = "goalSet")
    private List<Course> courseSet;
}
