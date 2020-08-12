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
@EqualsAndHashCode(of = {"classId", "personnelId"}, callSuper = false)
@Embeddable
public class PersonnelClassKey implements Serializable {
    @Column(name = "class_id")
    private Long classId;

    @Column(name = "personnel_id")
    private Long personnelId;
}
