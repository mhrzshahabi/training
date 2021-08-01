
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
@Subselect("select * from view_assignee_needs_assessments_report")
@DiscriminatorValue("ViewAssigneeNeedsAssessmentsReport")
public class ViewAssigneeNeedsAssessmentsReport implements Serializable{


    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "code")
    private String code;

    @Column(name = "des")
    private String des;

    @Column(name = "assignee")
    private String assignee;

    @Column(name = "time")
    private Date time;


}
