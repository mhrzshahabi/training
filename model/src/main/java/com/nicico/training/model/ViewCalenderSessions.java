package com.nicico.training.model;

import com.nicico.training.model.compositeKey.CalenderSessionsKey;
import com.nicico.training.model.compositeKey.ClassConflictKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_calendar_sessions")
@DiscriminatorValue("viewCalenderSessions")
public class ViewCalenderSessions {
    @EmbeddedId
    CalenderSessionsKey id;


    @Column(name = "c_day_name")
    private String sessionDay;

    @Column(name = "c_session_date",insertable = false,updatable = false)
    private String sessionDate;

    @Column(name = "c_session_start_hour")
    private String sessionStartHour;

    @Column(name="c_session_end_hour")
    private String sessionEndHour;

    @Column(name="calendar_id")
    private Long calenderId;

    @Column(name="classcode")
    private String classCode;
}
