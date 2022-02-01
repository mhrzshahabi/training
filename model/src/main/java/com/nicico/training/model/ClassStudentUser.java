package com.nicico.training.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Getter
@Setter
@AllArgsConstructor
public class ClassStudentUser implements Serializable {

     private String StartDate;
     private String mobile;
     private String classStudentRegistered;
     private String classID;
}
