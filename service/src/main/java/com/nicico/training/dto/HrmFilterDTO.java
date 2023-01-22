package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class HrmFilterDTO {
    private String field;
    private String type;
    private String operator;
    private List<Object> values;
    private List<Object> fromValues;
    private List<Object> toValues;

}
