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
@Subselect("select * from view_training_need_assessment")
@DiscriminatorValue("viewTrainingNeedAssessment")
public class ViewTrainingNeedAssessment implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_id")
    private Long categoryId;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa")
    private String courseTitle;

    @Column(name = "c_title_fa1")
    private String categoryTitle;

    @Column(name = "c_title_fa2")
    private String subCategoryTitle;
}
