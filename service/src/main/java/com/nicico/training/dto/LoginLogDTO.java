package com.nicico.training.dto;

import com.nicico.training.model.enums.LoginState;
import lombok.Data;

import java.sql.Timestamp;

@Data
public class LoginLogDTO {

    private String username;
    private String firstName;
    private String lastName;
    private String nationalCode;
    private Timestamp createDate;
    private LoginState state;
}
