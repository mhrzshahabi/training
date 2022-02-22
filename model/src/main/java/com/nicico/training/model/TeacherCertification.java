package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_teacher_certification")
public class TeacherCertification extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "teacher_certification_seq")
    @SequenceGenerator(name = "teacher_certification_seq", sequenceName = "seq_teacher_certification_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_course_title")
    private String courseTitle;

    @Column(name = "c_company_name")
    private String companyName;

    @Column(name = "c_company_location")
    private String companyLocation;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_certification_category",
            joinColumns = {@JoinColumn(name = "f_teacher_certification", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private Set<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_teacher_certification_subcategory",
            joinColumns = {@JoinColumn(name = "f_teacher_certification", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_subcategory", referencedColumnName = "id")})
    private Set<Subcategory> subCategories;

    @Column(name = "n_duration", precision = 5)
    private Integer duration;

    @Column(name = "c_start_date")
    private String startDate;

    @Column(name = "c_end_date")
    private String endDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

    @Column(name="certification_status")
    private Boolean certificationStatus;

    @Column(name="certification_status_detail")
    private String certificationStatusDetail;
}
