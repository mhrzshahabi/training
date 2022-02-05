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

