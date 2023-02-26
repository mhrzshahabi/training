package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Id;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from syn_hrm_view_fetch_parent_post")
@DiscriminatorValue("synHrmViewFetchParentPost")
public class SynHrmViewFetchParentPost implements Serializable {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_national_code_input")
    private String input;


    @Column(name = "c_national_code_prnt_output")
    private String parent;


}
