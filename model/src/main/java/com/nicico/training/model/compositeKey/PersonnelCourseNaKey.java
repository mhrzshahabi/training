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
@EqualsAndHashCode(of = {"courseId", "personnelId"}, callSuper = false)
@Embeddable
public class PersonnelCourseNaKey implements Serializable {

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "personnel_id")
    private Long personnelId;
}
