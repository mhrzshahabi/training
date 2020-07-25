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
@EqualsAndHashCode(of = {"classId","studentId", "sessionDate"}, callSuper = false)
@Embeddable
public class ViewStatisticsUnitReportKey implements Serializable {

    @Column(name = "class_id")
    private Long classId;

    @Column(name = "student_id")
    private Long studentId;

    @Column(name = "session_session_date")
    private String sessionDate;
}

