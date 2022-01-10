package com.nicico.training.dto;

import lombok.Data;
import response.BaseResponse;

@Data
public class NAReportForLMSResponseDTO extends BaseResponse {
    private NAReportForLMSDTO data;
}
