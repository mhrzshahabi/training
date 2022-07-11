package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from tbl_oa_user")
@DiscriminatorValue("oAUser")
public class SynonymOAUser {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_first_name")
    private String firstName;

    @Column(name = "c_last_name")
    private String lastName;

    @Column(name = "c_username")
    private String userName;

    @Column(name = "c_password")
    private String password;

    @Column(name = "c_national_code")
    private String nationalCode;
}