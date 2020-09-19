/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/13
 * Last Modified: 2020/08/24
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
@EqualsAndHashCode(of = {"personalNum","classCode"}, callSuper = false)
@Embeddable
public class ViewStudentsInCanceledClassReportKey implements Serializable {

    @Column(name = "personalnum")
    private String personalNum;

    @Column(name = "class_code")
    private String classCode;
}

