package com.nicico.training.model;

import com.nicico.training.model.compositeKey.AnnualStatisticalReportKey;
import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_annual_statistical")
public class AnnualStatisticalReport {

    @EmbeddedId
    private AnnualStatisticalReportKey id;

    @Column(name = "institute_id", insertable = false, updatable = false)
    private Long institute_id;

    @Column(name = "institute_title_fa")
    private String institute_title_fa;

    @Column(name = "category_id", insertable = false, updatable = false)
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

     private Long barnamerizi_class_count;
     private Long ejra_class_count;
     private Long ekhtetam_class_count;
     private Long student_count_ghabool;

}