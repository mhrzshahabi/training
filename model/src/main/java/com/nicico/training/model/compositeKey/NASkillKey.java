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
@EqualsAndHashCode(of = {"NAId", "skillId"}, callSuper = false)
@Embeddable
public class NASkillKey implements Serializable {

    @Column(name = "na_id")
    private Long NAId;

    @Column(name = "skill_id")
    private Long skillId;
}
