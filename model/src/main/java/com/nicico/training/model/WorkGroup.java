package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_work_group")
public class WorkGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "work_group_seq")
    @SequenceGenerator(name = "work_group_seq", sequenceName = "seq_work_group_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title", nullable = false)
    private String title;

    @Column(name = "c_description")
    private String description;

    @OneToMany(mappedBy = "workGroup", fetch = FetchType.LAZY)
    private Set<Permission> permissions;

    @ElementCollection
    private List<Long> userIds;
}
