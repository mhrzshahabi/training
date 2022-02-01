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
@Table(name = "tbl_employment_history")
public class EmploymentHistory extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "employment_history_seq")
    @SequenceGenerator(name = "employment_history_seq", sequenceName = "seq_employment_history_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_company_name")
    private String companyName;

    @Column(name = "c_job_title")
    private String jobTitle;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_employment_history_category",
            joinColumns = {@JoinColumn(name = "f_employment_history", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_category", referencedColumnName = "id")})
    private Set<Category> categories;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "tbl_employment_history_subcategory",
            joinColumns = {@JoinColumn(name = "f_employment_history", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_subcategory", referencedColumnName = "id")})
    private Set<Subcategory> subCategories;

    @Column(name = "c_start_date")
    private String startDate;

    @Column(name = "c_end_date")
    private String endDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;
}
