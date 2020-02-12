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
@Table(name = "tbl_work_group")
public class WorkGroup extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "work_group_seq")
    @SequenceGenerator(name = "work_group_seq", sequenceName = "seq_work_group_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title", nullable = false, unique = true)
    private String title;

    @Column(name = "c_description")
    private String description;

    @OneToMany(mappedBy = "workGroup", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Permission> permissions;

    @ElementCollection
    @CollectionTable(name = "tbl_work_group_user_ids", joinColumns = @JoinColumn(name = "f_work_group"))
    @Column(name = "user_ids")
    private Set<Long> userIds;
}
