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

