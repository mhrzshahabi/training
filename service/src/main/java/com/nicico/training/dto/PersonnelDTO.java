package com.nicico.training.dto;


import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class PersonnelDTO implements Serializable {

    @Getter
    @Setter
    @Accessors
    @ApiModel("Personnel - Info")
    public static class Info {
        private Long id;
        private String firstName;
        private String lastName;
        private String nationalCode;
        private String companyName;
        private String personnelNo;
        private String personnelNo2;
    }
}
