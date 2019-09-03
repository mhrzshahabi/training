/*
ghazanfari_f, 8/29/2019, 9:11 AM
*/
package com.nicico.training.model;

import com.nicico.training.model.enums.EActive;
import com.nicico.training.model.enums.EDeleted;
import lombok.EqualsAndHashCode;
import lombok.Getter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "tbl_job_new")
@Getter
@EqualsAndHashCode(of = "id")
public class Job {

    @Id
    @Column(name = "id")
    private Long id;

    @Column(name = "c_code")
    private String code;

    @Column(name = "c_title_fa")
    private String titleFa;

    @Column(name = "e_active")
    EActive eActive;

    @Column(name = "e_deleted")
    EDeleted eDeleted;
}