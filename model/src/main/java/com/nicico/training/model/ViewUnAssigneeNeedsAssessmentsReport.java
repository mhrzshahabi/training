
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
@Subselect("select * from view_un_assignee_needs_assessments_report")
@DiscriminatorValue("ViewUnAssigneeNeedsAssessmentsReport")
public class ViewUnAssigneeNeedsAssessmentsReport implements Serializable{


    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "code")
    private String code;

    @Column(name = "created_by")
    private String createdBy;

    @Column(name = "type")
    private String type;

    @Column(name = "title")
    private String title;

    @Column(name = "time")
    private Date time;


    @Column(name = "f_object")
    private String object;


}
