package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class HrmJobHistoryDto {
    private Integer totalCount;
    private HrmJobDto list;

}
