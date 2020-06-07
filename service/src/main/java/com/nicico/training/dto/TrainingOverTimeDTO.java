package com.nicico.training.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class TrainingOverTimeDTO implements Serializable {
    String personalNum;
    String getPersonalNum2;
    String nationalCode;
    String name;
    String ccpArea;
    String classCode;
    String className;
    String date;
}
