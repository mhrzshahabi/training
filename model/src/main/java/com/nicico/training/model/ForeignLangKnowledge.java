package com.nicico.training.model;

import com.nicico.training.model.enums.ELangLevel;
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
@Table(name = "tbl_foreign_lang_knowledge")
public class ForeignLangKnowledge extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "foreign_lang_knowledge_seq")
    @SequenceGenerator(name = "foreign_lang_knowledge_seq", sequenceName = "seq_foreign_lang_knowledge_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_lang_name", nullable = false)
    private String langName;

    @Column(name = "c_description", length = 500)
    private String description;

    @Column(name = "e_level", insertable = false, updatable = false)
    private ELangLevel langLevel;

    @Column(name = "e_level")
    private Integer langLevelId;

    @Column(name = "c_start_date")
    private String startDate;

    @Column(name = "c_end_date")
    private String endDate;

    @Column(name = "c_institute_name")
    private String instituteName;

    @Column(name = "c_duration")
    private String duration;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;
}
