package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
public class unjustifiedAbsenceDTO {
    private String sessionDate;
    private String lname;
    private String firstName;
    private String titleClass;
    private String startDate;
    private String endDate;
    private String endHour;
    private String startHour;

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
       private String    personnelNo;
        private String   nationalCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("unjustifiedAbsenceSpecRs")
    public static class unjustifiedAbsenceSpecRs {
        private unjustifiedAbsenceDTO.SpecRs response;
    }

    //*********************************

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<unjustifiedAbsenceDTO.printScoreInfo> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

   }
