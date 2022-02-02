package com.nicico.training.model;

import com.nicico.training.model.enums.EDomainType;
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
@Table(name = "tbl_syllabus")
public class Syllabus extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "syllabus_seq")
    @SequenceGenerator(name = "syllabus_seq", sequenceName = "seq_syllabus_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa", nullable = false, length = 700)
    private String titleFa;

    @Column(name = "c_title_en")
    private String titleEn;

    @Column(name = "c_description")
    private String description;

    @Column(name = "n_theoretical_duration", length = 10)
    private Float theoreticalDuration;

    @Column(name = "n_practical_duration", length = 10)
    private Float practicalDuration;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_goal", insertable = false, updatable = false)
    private Goal goal;

    @Column(name = "f_goal", nullable = false)
    private Long goalId;

    @Column(name = "e_domain_type", insertable = false, updatable = false)
    private EDomainType eDomainType;

    @Column(name = "e_domain_type")
    private Integer eDomainTypeId;
}
