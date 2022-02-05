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
@EqualsAndHashCode(of = {"institute_id","category_id"}, callSuper = false)
@Embeddable
public class AnnualStatisticalReportKey implements Serializable {

    @Column(name = "institute_id")
    private Long institute_id;

    @Column(name = "category_id")
    private Long category_id;
}

