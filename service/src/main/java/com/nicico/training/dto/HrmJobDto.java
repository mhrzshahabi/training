package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.Date;

@Getter
@Setter
@Accessors(chain = true)
public class HrmJobDto {
    private Date startDate;
    private Date endDate;
    private String firstName;
    private Long id;
    private String lastName;
    private String nationalCode;
    private String personnelCode;
    private String personnelCompanyName;
    private HrmPostDto post;



}
