package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class HrmCustomCriteria {
    private String operator;
    private List<HrmCustomCriteria2> criteria;


}
