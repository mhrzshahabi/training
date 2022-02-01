package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_evaluation_student_comments")
@DiscriminatorValue("ViewEvaluationStudentComments")
public class ViewEvaluationStudentComments implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "id_category")
    private Long categoryId;

    @Column(name = "id_sub_category")
    private Long subCategoryId;

    @Column(name = "des")
    private String description;

    @Column(name = "class_code")
    private String classCode;

    @Column(name = "class_title")
    private String classTitle;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "title_category")
    private String titleCategory;

    @Column(name = "title_sub_category")
    private String titleSubCategory;

    @Column(name = "start_date")
    private String startDate;

    @Column(name = "end_date")
    private String endDate;
}
