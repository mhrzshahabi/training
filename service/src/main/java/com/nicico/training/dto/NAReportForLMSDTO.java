package com.nicico.training.dto;

import lombok.Data;

import java.util.List;

@Data
public class NAReportForLMSDTO {

    private String personnelNo;
    private String personnelNo2;
    private String nationalCode;
    private String firstName;
    private String lastName;
    private String postCode;
    private String postTitle;
    private List<NAReportDetailForLMSDTO> reportDetailList;

}
