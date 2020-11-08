package com.nicico.training.model;

import lombok.Getter;
import org.hibernate.annotations.Immutable;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;
import javax.persistence.Table;

@Getter
@Entity
@Immutable
@Table(name = "tbl_department")
@DiscriminatorValue("Department")
public class Department extends DepartmentSuperClass {
}