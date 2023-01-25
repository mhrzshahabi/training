package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class HrmRequestDto {
    private Integer count;
    private Integer startIndex;
    private HrmCustomCriteria criteria;

}
