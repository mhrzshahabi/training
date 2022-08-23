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
@EqualsAndHashCode(of = {"id", "session1_Id", "session2_Id"}, callSuper = false)
@Embeddable
public class CalenderSessionsKey implements Serializable {
    @Column(name = "id")
    private Long id;

    @Column(name = "c_session_date")
    private String  sessionDate;

}
