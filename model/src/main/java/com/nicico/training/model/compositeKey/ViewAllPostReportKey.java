/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/08/24
 * Last Modified: 2020/07/26
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
@EqualsAndHashCode(of = {"postId","groupid", "type"}, callSuper = false)
@Embeddable
public class ViewAllPostReportKey implements Serializable {

    @Column(name = "postid")
    private Long postId;

    @Column(name = "groupid")
    private Long groupid;

    @Column(name = "type")
    private Integer type;
}

