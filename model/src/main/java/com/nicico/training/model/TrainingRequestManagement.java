package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_training_request_management")
public class TrainingRequestManagement extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "training_request_management_seq")
    @SequenceGenerator(name = "training_request_management_seq", sequenceName = "seq_training_request_management_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "applicant")
    private String applicant;

    @Column(name = "request_date")
    private Date requestDate;

    @Column(name = "complex")
    private String complex;

    @Column(name = "title")
    private String title;

    @Column(name = "letter_number")
    private String letterNumber;

    @Column(name = "letter_date")
    private Date letterDate;

    @Column(name = "c_description")
    private String description;

    @Column(name = "acceptor")
    private String acceptor;

    @OneToMany(mappedBy = "trainingRequestManagement", fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TrainingRequestItem> items;
}
