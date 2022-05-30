package com.nicico.training.model;

import com.nicico.training.model.enums.EQuestionLevel;
import lombok.*;
import lombok.experimental.Accessors;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;

import javax.persistence.*;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_question_bank")
public class QuestionBank extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "question_bank_seq")
    @SequenceGenerator(name = "question_bank_seq", sequenceName = "seq_question_bank_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_code", nullable = false)
    private String code;

    @Column(name = "n_code_id", nullable = false)
    private Integer codeId;

    @Column(name = "c_question", nullable = false)
    private String question;

    @Column(name = "n_lines", nullable = false)
    private Integer lines = 1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value_question_type", nullable = false, insertable = false, updatable = false)
    private ParameterValue questionType;

    @Column(name = "f_parameter_value_question_type", nullable = false)
    private Long questionTypeId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_parameter_value_question_display_type", insertable = false, updatable = false)
    private ParameterValue displayType;

    @Column(name = "f_parameter_value_question_display_type")
    private Long displayTypeId;

    @Column(name = "c_option1")
    private String option1;

    @Column(name = "c_option2")
    private String option2;

    @Column(name = "c_option3")
    private String option3;

    @Column(name = "c_option4")
    private String option4;

    @Column(name = "c_descriptive_answer")
    private String descriptiveAnswer;

    @Column(name = "n_multiple_choice_answer")
    private Integer multipleChoiceAnswer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_category_id", insertable = false, updatable = false)
    private Category category;

    @Column(name = "f_category_id")
    private Long categoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_subcategory_id", insertable = false, updatable = false)
    private Subcategory subCategory;

    @Column(name = "f_subcategory_id")
    private Long subCategoryId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_course_id", insertable = false, updatable = false)
    private Course course;

    @Column(name = "f_course_id")
    private Long courseId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_tclass_id", insertable = false, updatable = false)
    private Tclass tclass;

    @Column(name = "f_tclass_id")
    private Long tclassId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "f_teacher_id", insertable = false, updatable = false)
    private Teacher teacher;

    @Column(name = "f_teacher_id")
    private Long teacherId;

    @OneToMany(mappedBy = "questionBank", fetch = FetchType.LAZY)
    private Set<QuestionBankTestQuestion> questionBankTestQuestion;

    @Column(name = "has_attachment")
    private Boolean hasAttachment;

    @Column(name = "e_question_level", insertable = false, updatable = false)
    private EQuestionLevel eQuestionLevel;

    @Column(name = "e_question_level")
    private Integer eQuestionLevelId;

    @Column(name = "c_proposed_point_value")
    private Double proposedPointValue;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "tbl_question_bank_target", joinColumns = @JoinColumn(name = "f_question"))
    @Column(name = "targets")
    private List<Integer> questionTargets;

    @CreatedDate
    @Column(name = "D_CREATED_DATE", nullable = false, updatable = false)
    protected Date createdDate;

    @CreatedBy
    @Column(name = "C_CREATED_BY", nullable = false, updatable = false)
    protected String createdBy;

    @Column(name = "C_QUESTION_DESIGNER")
    private String questionDesigner;



    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "tbl_group_question", uniqueConstraints = {@UniqueConstraint(columnNames = {"f_parent_id", "f_child_id"})},
            joinColumns = {@JoinColumn(name = "f_parent_id", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "f_child_id", referencedColumnName = "id")})

    private List<QuestionBank> groupQuestions;
}

