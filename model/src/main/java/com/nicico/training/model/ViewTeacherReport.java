package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from VIEW_TEACHER_REPORT")
@DiscriminatorValue("ViewTeacherReport")
public class ViewTeacherReport extends Auditable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "TEACHER_ID")
    private Long teacherId;

    @Column(name = "PERSONALINFO_FIRST_NAME")
    private String firstName;

    @Column(name = "PERSONALINFO_LAST_NAME")
    private String lastName;

    @Column(name = "PERSONALINFO_NATIONAL_CODE")
    private String nationalCode;

    @Column(name = "CONTACTINFO_MOBILE")
    private String mobile;

    @Column(name = "CLASS_COUNTS")
    private Integer classCounts;

    @Column(name = "TEACHER_ENABLE_STATUS")
    private Boolean teacherEnableStatus;

    @Column(name = "PERSONNEL_ENABLE_STATUS")
    private Boolean personnelStatus;

    @Column(name = "TEACHER_CODE")
    private String teacherCode;

    @Column(name = "TEACHER_PERSONNEL_COD")
    private String personnelCode;

    @Column(name = "PERSONALINFO_EDUCATION_MAJOR")
    private Long educationMajor;

    @Column(name = "PERSONALINFO_EDUCATION_LEVEL")
    private Long educationLevel;

    @Column(name = "ADDRESS_STATE")
    private Long state;

    @Column(name = "ADDRESS_CITY")
    private Long city;

    @Column(name = "LASTCLASSTITLE")
    private String lastClass;

    @Column(name = "REACTIONGRADE")
    private String lastClassGrade;

    @Column(name="TEACHER_CATEGORIES")
    private String teacherCategories;

    @Column(name="TEACHER_SUB_CATEGORIES")
    private String teacherSubCategories;

    @Column(name="TEACHING_HISTORY_CATS")
    private String teachingHistoryCats;

    @Column(name="TEACHING_HISTORY_SUBCATS")
    private String teachingHistorySubCats;

    @Column(name="TEACHER_TERM_IDS")
    private String teacherTermIds;

    @Column(name="TEACHER_TERM_TITLES")
    private String teacherTermTitles;

    @Column(name="PERSONALINFO_EDUCATION_MAJOR_TITLE")
    private String educationMajorTitle;
}
