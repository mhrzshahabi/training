package com.nicico.training.dto;

import lombok.Data;
import net.sf.jasperreports.engine.fill.BaseReportFiller;
import response.BaseResponse;

@Data
public class NAReportForLMSResponseDTO extends BaseResponse {
    private NAReportForLMSDTO data;
}
