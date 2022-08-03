package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;


@Getter
@Setter
@Accessors(chain = true)
public class GenericStatisticalIndexReportDTO {

    private String complex;
    private String assistant;
    private String affairs;
    private Long baseOnComplex;
    private Long baseOnAssistant;
    private Long baseOnAffairs;
}
