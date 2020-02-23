package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
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

    @Getter
    @Setter
    @Accessors(chain = true)
    @AllArgsConstructor
    public static class printScoreInfo  {
        private String   code;
        private String   titleClass;
        private String   preTestScore;
        private String   firstName;
        private String   lastName;
        private String   startDate;
        private String   endDate;
       private String   personnelNo;
        private String   nationalCode;
    }

   }
