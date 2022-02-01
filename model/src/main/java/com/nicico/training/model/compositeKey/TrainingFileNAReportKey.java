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
@EqualsAndHashCode(of = {"course_id","reference_course","id"}, callSuper = false)
@Embeddable
public class TrainingFileNAReportKey implements Serializable {

    @Column(name = "course_id", insertable = false, updatable = false)
    private Long courseId;

    @Column(name = "reference_course", insertable = false, updatable = false)
    private Long referenceCourse;

    @Column(name = "id", insertable = false, updatable = false)
    private Long id;

}

