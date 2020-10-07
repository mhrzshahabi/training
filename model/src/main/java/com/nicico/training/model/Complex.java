package com.nicico.training.model;

import lombok.Getter;
import org.hibernate.annotations.Immutable;
import org.hibernate.annotations.Subselect;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Getter
@Entity
@Immutable
@Subselect("select * from view_complex")
@DiscriminatorValue("Complex")
public class Complex extends DepartmentSuperClass {
}