package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class PersonnelClassesHistoryDTO extends BaseResponse {
    List<ViewLmsTrainingFileDTO> viewTrainingFileDTOS;
}