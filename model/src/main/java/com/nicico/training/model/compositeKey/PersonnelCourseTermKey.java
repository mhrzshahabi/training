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
@EqualsAndHashCode(of = {"courseId", "personnelId", "termId"}, callSuper = false)
@Embeddable
public class PersonnelCourseTermKey implements Serializable {

    @Column(name = "course_id")
    private Long courseId;

    @Column(name = "personnel_id")
    private Long personnelId;

    @Column(name = "term_id")
    private Long termId;
}
