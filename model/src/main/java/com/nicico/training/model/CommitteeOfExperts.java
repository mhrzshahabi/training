package com.nicico.training.model;

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
@Table(name = "tbl_committee_of_experts")
public class CommitteeOfExperts extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "committee_of_experts_seq")
    @SequenceGenerator(name = "committee_of_experts_seq", sequenceName = "seq_committee_of_experts_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "title")
    private String title;

    @Column(name = "address")
    private String address;

    @Column(name = "phone")
    private String phone;

    @Column(name = "fax")
    private String fax;

    @Column(name = "email")
    private String email;

     @OneToMany(fetch = FetchType.LAZY, mappedBy = "committeeOfExperts",cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CommitteePersonnel> committeePersonnels;


     @OneToMany(fetch = FetchType.LAZY, mappedBy = "committeeOfExperts",cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CommitteePost> committeePosts;


    @ElementCollection
    @CollectionTable(name = "tbl_committee_of_experts_complex", joinColumns = @JoinColumn(name = "committee_of_experts_id"))
    @Column(name = "complex_values")
    private List<String> complexes;


}