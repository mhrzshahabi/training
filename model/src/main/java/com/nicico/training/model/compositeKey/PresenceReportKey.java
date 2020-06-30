package com.nicico.training.model.compositeKey;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"studentID", "classId", "sessionDate"}, callSuper = false)
@Embeddable
public class PresenceReportKey implements Serializable {

    @Column(name = "student_id")
    private Long studentID;

    @Column(name = "class_id")
    private Long classId;

    @Column(name = "session_session_date")
    private String sessionDate;
}
