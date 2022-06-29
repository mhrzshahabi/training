package com.nicico.training.model;


import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;


@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_committee_of_experts_post")
 public class CommitteePost {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "committee_post_seq")
    @SequenceGenerator(name = "committee_post_seq", sequenceName = "seq_committee_post_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id ;

    @ManyToOne
    @JoinColumn(name = "f_committee_id", insertable = false, updatable = false)
    private CommitteeOfExperts committeeOfExperts;

   @Column(name = "f_committee_id")
   private Long committeeOfExpertId;


    @Column(name = "object_type")
    private String postType;

    @Column(name = "object_id")
    private Long postId;

    @Column(name = "object_code")
    private String postCode;


}