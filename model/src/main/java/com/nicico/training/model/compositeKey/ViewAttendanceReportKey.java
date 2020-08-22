/*
 * Author: Mehran Golrokhi
 */

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
@EqualsAndHashCode(of = {"personalNum","classCode", "date"}, callSuper = false)
@Embeddable
public class ViewAttendanceReportKey implements Serializable {

    @Column(name = "personalnum")
    private String personalNum;

    @Column(name = "classcode")
    private String classCode;

    @Column(name = "c_session_date")
    private String date;
}

