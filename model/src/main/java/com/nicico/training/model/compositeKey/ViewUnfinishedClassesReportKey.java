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
@EqualsAndHashCode(of = {"classId","courseId", "studentId"}, callSuper = false)
@Embeddable
public class ViewUnfinishedClassesReportKey implements Serializable {

    @Column(name = "id")
    private Long classId;

    @Column(name = "f_course")
    private Long courseId;

    @Column(name = "student_id")
    private Long studentId;
}

