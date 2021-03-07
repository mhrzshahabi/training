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
@EqualsAndHashCode(of = {"student_Id", "session1_Id", "session2_Id"}, callSuper = false)
@Embeddable
public class ClassConflictKey implements Serializable {

    @Column(name = "student_Id")
    private Long studentId;

    @Column(name = "session1_Id")
    private Long session1Id;

    @Column(name = "session2_Id")
    private Long session2Id;

}
