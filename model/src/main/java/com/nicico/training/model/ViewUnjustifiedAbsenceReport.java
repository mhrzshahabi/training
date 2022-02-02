package com.nicico.training.model;

import com.nicico.training.model.compositeKey.ViewUnjustifiedAbsenceReportKey;
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
@Subselect("select * from view_unjustified_absence_report")
public class ViewUnjustifiedAbsenceReport implements Serializable {

    @EmbeddedId
    private ViewUnjustifiedAbsenceReportKey id;

    @Column(name = "class_id", insertable = false, updatable = false)
    private Long classId;

    @Column(name = "student_id", insertable = false, updatable = false)
    private Long studentId;

    @Column(name = "session_id", insertable = false, updatable = false)
    private Long sessionId;

    @Column(name = "c_session_date")
    private String sessionDate;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "c_title_class")
    private String titleClass;

    @Column(name = "c_start_date")
    private String startDate;

    @Column(name = "c_end_date")
    private String endDate;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_session_end_hour")
    private String endHour;

    @Column(name = "c_session_start_hour")
    private String startHour;
}
