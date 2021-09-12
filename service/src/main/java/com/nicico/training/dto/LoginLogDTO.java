package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.LoginState;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.sql.Timestamp;

@Data
public class LoginLogDTO {

    private String username;
    private String firstName;
    private String lastName;
    private String nationalCode;
    private Timestamp createDate;
    private LoginState state;

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class ExcelDTO {

        private String username;
        private String firstName;
        private String lastName;
        private String nationalCode;
        private String createDate;
        private LoginState state;
    }
}
