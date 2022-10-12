package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_training_req_item")
public class TrainingRequestItem extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "item_seq")
    @SequenceGenerator(name = "item_seq", sequenceName = "seq_item_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;


    @ManyToOne()
    @JoinColumn(name = "f_personnel", insertable = false, updatable = false)
    private Personnel personnel;

    @Column(name = "f_personnel")
    private Long personnelId;


    @ManyToOne()
    @JoinColumn(name = "f_post", insertable = false, updatable = false)
    private Post post;

    @Column(name = "f_post")
    private Long postId;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_training_req_id", nullable = false, insertable = false, updatable = false)
    private TrainingRequestManagement trainingRequestManagement;

    @Column(name = "f_training_req_id")
    private Long trainingRequestManagementId;


    @Column(name = "ref")
    private String ref;

}
