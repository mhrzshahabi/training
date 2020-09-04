package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"institute_id"}, callSuper = false)
@Entity
@Table(name = "tbl_annual_statistical")
public class AnnualStatisticalReport {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "annual_seq")
    @SequenceGenerator(name = "annual_seq", sequenceName = "seq_annual_id", allocationSize = 1)
    @Column(name = "institute_id", precision = 10)
    private Long institute_id;
    @Column(name = "institute_title_fa")
    private String institute_title_fa;
    @Column(name = "category_id")
    private Long category_id;
    @Column(name = "finished_class_count")
    private Long finished_class_count;
    @Column(name = "canceled_class_count")
    private Long canceled_class_count;
    @Column(name = "sum_of_duration")
    private Long sum_of_duration;
    @Column(name = "student_count")
    private Long student_count;
    @Column(name = "sum_of_student_hour")
    private Long sum_of_student_hour;
}