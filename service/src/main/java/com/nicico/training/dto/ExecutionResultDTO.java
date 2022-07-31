package com.nicico.training.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class ExecutionResultDTO {
    Map<String, Double> stringDoubleMap;
    List<Long> evaluationIds;
}
