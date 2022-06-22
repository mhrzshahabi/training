package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_request_item_courses_detail")
public class RequestItemCoursesDetail extends Auditable implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "request_item_courses_detail_seq")
    @SequenceGenerator(name = "request_item_courses_detail_seq", sequenceName = "seq_request_item_courses_detail_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_course_code")
    private String courseCode;

    @Column(name = "c_course_title")
    private String courseTitle;

    @Column(name = "c_category_title")
    private String categoryTitle;

    @Column(name = "c_sub_category_title")
    private String subCategoryTitle;

    @Column(name = "c_priority")
    private String priority;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_request_item_process_detail_id", nullable = false, insertable = false, updatable = false)
    private RequestItemProcessDetail requestItemProcessDetail;

    @Column(name = "f_request_item_process_detail_id")
    private Long requestItemProcessDetailId;

}
