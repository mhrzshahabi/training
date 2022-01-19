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
@EqualsAndHashCode(of = {"id", "rev"}, callSuper = false)
@Embeddable
public class AuditAttendanceId implements Serializable {

    @Column(name = "id")
    private Long id;

    @Column(name = "rev")
    private Long rev;
}
