
/*
 * Author: Mehran Golrokhi
 */

package com.nicico.training.model;

import com.nicico.training.model.compositeKey.ViewAttendanceReportKey;
import com.nicico.training.model.compositeKey.ViewStatisticsUnitReportKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_attendance_report")
public class ViewAttendanceReport implements Serializable {

    @EmbeddedId
    private ViewAttendanceReportKey id;

    @Column(name = "personalnum", insertable = false, updatable = false)
    private String personalNum;

    @Column(name = "personalnum2")
    private String personalNum2;

    @Column(name = "nationalcode")
    private String nationalCode;

    @Column(name = "name")
    private String name;

    @Column(name = "ccparea")
    private String ccpArea;

    @Column(name = "ccpaffairs")
    private String ccpAffairs;

    @Column(name = "peopletype")
    private String peopleType;

    @Column(name = "classcode", insertable = false, updatable = false)
    private String classCode;

    @Column(name = "classname")
    private String className;

    @Column(name = "c_session_date", insertable = false, updatable = false)
    private String date;

    @Column(name = "c_state", insertable = false, updatable = false)
    private Integer attendanceStatus;

    @Column(name = "time")
    private String time;

    @Column(name = "planner_complex")
    private String plannerComplex;

    @Column(name = "planner_name")
    private String plannerName;

    @Column(name = "institute_name")
    private String instituteName;

}
