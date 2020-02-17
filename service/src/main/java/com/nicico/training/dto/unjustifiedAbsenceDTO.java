package com.nicico.training.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
public class unjustifiedAbsenceDTO {
    private String session_date;
    private String lname;
    private String first_name;
    private String title_class;
    private String start_date;
    private String end_date;
    private String end_hour;
    private String start_hour;
   }
