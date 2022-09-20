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
@Subselect("select * from view_calendar_course")
@DiscriminatorValue("ViewCalenderCourses")
public class ViewCalenderCourses {
    @Id
    @Column(name = "id")
    private Long id;

    @Column(name="calendar_id")
    private Long calenderId;

    @Column(name="COURSECODE")
    private String courseCode;

    @Column(name="MAHALBARGOZARI")
    private String mahalBarghozari;

    @Column(name="NOEDORE")
    private String nomreh;

    @Column(name="HAZINEHDORE")
    private String hazinehDore;

    @Column(name="NAHVEBARGOZARI")
    private String nahveBargozari;

    @Column(name="DARKHASTAMOUZESHI")
    private String darkhastAmouzeshi;

    @Column(name="TARIKHBARGOZARI")
    private String tarikhBargozari;

    @Column(name="MODATDORE")
    private String modatDore;


}
