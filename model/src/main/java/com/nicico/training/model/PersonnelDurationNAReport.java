
package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"personnelId"}, callSuper = false)
@Entity
@Subselect("select * from view_personnel_duration_na_report")
public class PersonnelDurationNAReport implements Serializable {


    ///////////////////////////////////////////////////personnel///////////////////////////////////////

    @Id
    @Column(name = "personnel_id")
    private long personnelId;

    //////////////////////////////////////////////////duration////////////////////////////////////////

    @Column(name = "duration")
    private Float duration;

    @Column(name = "passed")
    private Float passed;

    @Column(name = "essential")
    private Float essential;

    @Column(name = "essential_passed")
    private Float essentialPassed;

    @Column(name = "improving")
    private Float improving;

    @Column(name = "improving_passed")
    private Float improvingPassed;

    @Column(name = "developmental")
    private Float developmental;

    @Column(name = "developmental_passed")
    private Float developmentalPassed;
}
