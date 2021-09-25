package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Set;

@Setter
@Getter
public class SysUserInfoModel implements Serializable {
    private int status;
    private String message;
    private String userId;
    private String cellNumber;
    private Set<String> authorities;
}
