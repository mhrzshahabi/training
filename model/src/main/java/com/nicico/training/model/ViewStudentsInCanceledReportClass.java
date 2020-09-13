/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/13
 * Last Modified: 2020/09/13
 */


package com.nicico.training.model;

import com.nicico.training.model.compositeKey.ViewStudentsInCanceledClassReportKey;
import lombok.*;
import lombok.experimental.Accessors;
import org.hibernate.annotations.Subselect;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Subselect("select * from view_students_in_canceled_class_report")
public class ViewStudentsInCanceledReportClass implements Serializable {

    @EmbeddedId
    private ViewStudentsInCanceledClassReportKey id;

    @Column(name = "personalnum", insertable = false, updatable = false)
    private String personalNum;

    @Column(name = "personalnum2")
    private String personalNum2;

    @Column(name = "nationalcode")
    private String nationalCode;

    @Column(name = "name")
    private String name;

    @Column(name = "complex_title")
    private String ccpComplex;

    @Column(name = "ccp_assistant")
    private String ccpAssistant;

    @Column(name = "ccp_affairs")
    private String ccpAffairs;

    @Column(name = "ccp_unit")
    private String ccpUnit;

    @Column(name = "ccp_section")
    private String ccpSection;

    @Column(name = "class_code", insertable = false, updatable = false)
    private String classCode;

    @Column(name = "class_title")
    private String className;

    @Column(name = "start_data")
    private String startDate;

    @Column(name = "end_data")
    private String endDate;

    @Column(name = "personeltype")
    private String personelType;
}

