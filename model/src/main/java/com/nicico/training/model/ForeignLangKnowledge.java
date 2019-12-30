package com.nicico.training.model;

import com.nicico.training.model.enums.ELangLevel;
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

    @Column(name = "e_reading" ,insertable = false, updatable = false)
    private ELangLevel langLevelReading;

    @Column(name = "e_writing" , insertable = false, updatable = false)
    private ELangLevel langLevelWriting;

    @Column(name = "e_speaking",  insertable = false, updatable = false)
    private ELangLevel langLevelSpeaking;

    @Column(name = "e_translation",  insertable = false, updatable = false)
    private ELangLevel langLevelTranslation;

    @Column(name = "e_reading")
    private Integer langLevelReadingId;

    @Column(name = "e_writing")
    private Integer langLevelWritingId;

    @Column(name = "e_speaking")
    private Integer langLevelSpeakingId;

    @Column(name = "e_translation")
    private Integer langLevelTranslationId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

}
