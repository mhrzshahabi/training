/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/16
 * Last Modified: 2020/09/14
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
@EqualsAndHashCode(of = {"id","rev"}, callSuper = false)
@Embeddable
public class AuditClassId implements Serializable {

    @Column(name = "id")
    private Long id;

    @Column(name = "rev")
    private Long rev;
}

