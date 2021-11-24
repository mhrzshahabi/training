package com.nicico.training.dto;

import lombok.Data;

import java.util.List;

@Data
public class NeedAssessmentReportUserObj {
    private List<NeedAssessmentReportUserDTO> reportUserDTOS;
    private String code;
    private String postTitle;
}
