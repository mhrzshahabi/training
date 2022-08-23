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
@Subselect("select * from view_calendar_headline")
@DiscriminatorValue("viewCalenderHeadlines")
public class ViewCalenderHeadlines {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "sarfaslha")
    private String headline;

    @Column(name="calendar_id")
    private Long calenderId;

    @Column(name="c_code")
    private String classCode;

}
