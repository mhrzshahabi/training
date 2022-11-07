package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Date;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_group_of_personnel",uniqueConstraints = {@UniqueConstraint(columnNames = {"c_code"})})
public class GroupOfPersonnel extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "group_of_personnel_seq")
    @SequenceGenerator(name = "group_of_personnel_seq", sequenceName = "seq_group_of_personnel_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_title_fa", nullable = false)
    private String titleFa;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_description")
    private String description;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_personnel_in_group",
            joinColumns = {@JoinColumn(name = "f_personnel_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_group_id", referencedColumnName = "id")})
    private Set<Personnel> personnelSet;

    @Column(name = "d_last_modified_date_na")
    private Date lastModifiedDateNA;

    @Column(name = "c_modified_by_na")
    private String modifiedByNA;
}
