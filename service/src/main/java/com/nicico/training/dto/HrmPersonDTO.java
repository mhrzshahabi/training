package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class HrmPersonDTO {

    private String firstName;
    private String lastName;
    private String nationalCode;
    private String mobile;

}
