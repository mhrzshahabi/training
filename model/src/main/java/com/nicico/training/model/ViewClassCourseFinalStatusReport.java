package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_class_course_final_status")
@DiscriminatorValue("ViewClassCourseFinalStatus")
public class ViewClassCourseFinalStatusReport {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "CLASS_CODE")
    private String classCode;

    @Column(name = "COURSE_CODE")
    private String courseCode;

    @Column(name = "CLASS_TITLE")
    private String classTitle;

    @Column(name = "TEACHER_ID")
    private Long teacherId;

    @Column(name = "TEACHER_FULL_NAME")
    private String teacherFullName;

    @Column(name = "CLASS_STATUS")
    private String classStatus;

    @Column(name = "CLASS_SCORING_METHOD_CODE")
    private Long classScoringMethodCode;

    @Column(name = "CLASS_SCORING_METHOD_TITLE")
    private String classScoringMethodTitle;

    @Column(name = "CLASS_SCORING_STATUS")
    private String classScoringStatus;

    @Column(name = "ACCEPTANCE_PERCENTAGE")
    private Double acceptancePercentage;

    @Column(name = "CATEGORY_ID")
    private Long courseCategory;

    @Column(name = "CLASS_START_DATE")
    private String classStartDate;

    @Column(name = "CLASS_END_DATE")
    private String classEndDate;

    @Column(name = "CLASS_YEAR")
    private String tclassYear;

    @Column(name = "TERM_TITLE")
    private String termTitle;

    @Column(name = "STUDENT_ID")
    private Long studentId;

    @Column(name = "STUDENT_FULL_NAME")
    private String studentFullName;

    @Column(name = "COMPLEX_ID")
    private Long complexId;

    @Column(name = "COMPLEX_TITLE")
    private String complexTitle;

    @Column(name = "AFFAIR_ID")
    private Long affairId;

    @Column(name = "AFFAIR_TITLE")
    private String affairTitle;

    @Column(name = "ASSISTANT_ID")
    private Long assistantId;

    @Column(name = "ASSISTANT_TITLE")
    private String assistantTitle;

    @Column(name = "INSTITUTE_TITLE")
    private String instituteTitle;

}
