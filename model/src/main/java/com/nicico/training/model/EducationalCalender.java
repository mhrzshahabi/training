package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_educational_calender")
public class EducationalCalender extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "educational_calender_seq")
    @SequenceGenerator(name = "educational_calender_seq", sequenceName = "seq_educational_calender_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "e_title_fa", nullable = false, unique = true)
    private String titleFa;

//    @Column(name = "e_title_en")
//    private String titleEn;

    @Column(name = "e_code", nullable = false, unique = true)
    private String code;

    @Column(name = "e_start_date", nullable = false)
    private String startDate;

    @Column(name = "e_end_date", nullable = false)
    private String endDate;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "institute_id",insertable = false, updatable = false)
    private Institute institute;

    @Column(name = "institute_id")
    private Long instituteId;

    @Column(name = "c_status")
    private String calenderStatus;


    @OneToMany(mappedBy = "educationalCalender",fetch=FetchType.LAZY)
    private List<Tclass> classList;


}
