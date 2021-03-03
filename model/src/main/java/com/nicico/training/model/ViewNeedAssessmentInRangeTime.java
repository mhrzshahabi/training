
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_need_assessment_in_range_time")
@DiscriminatorValue("viewNeedAssessmentInRangeTime")
public class ViewNeedAssessmentInRangeTime implements Serializable{


    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "POST")
    private String postType;

    @Column(name = "C_CODE")
    private String postCode;

    @Column(name = "C_TITLE_FA")
    private String postTitle;

    @Column(name = "NAME")
    private String updateBy;

    @Column(name = "UPDATETIME")
    private Date updateAt;

    @Column(name = "N_VERSION")
    private Integer version;


}
