package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_teaching_history")
public class TeachingHistory extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teaching_history_seq")
    @SequenceGenerator(name = "teaching_history_seq", sequenceName = "seq_teaching_history_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_course_title")
    private String courseTitle;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teaching_history_category",
            joinColumns = {@JoinColumn(name = "f_teaching_history", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private List<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teaching_history_subcategory",
            joinColumns = {@JoinColumn(name = "f_teaching_history", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_subcategory", referencedColumnName = "id")})
    private List<SubCategory> subCategories;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_education_level_id", insertable = false, updatable = false)
    private EducationLevel educationLevel;

    @Column(name = "f_education_level_id")
    private Long educationLevelId;

    @Column(name = "n_duration", precision = 5)
    private Integer duration;

    @Column(name = "d_start_date")
    private Date startDate;

    @Column(name = "d_end_date")
    private Date endDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

    @Column(name = "c_company_name")
    private String companyName;

}
