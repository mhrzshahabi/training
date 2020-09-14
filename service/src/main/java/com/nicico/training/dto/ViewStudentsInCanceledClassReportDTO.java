/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/13
 * Last Modified: 2020/09/13
 */


package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewStudentsInCanceledClassReportDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewsStudentsInCanceledClass-Info")
    public static class Info {
        private String personalNum;
        private String personalNum2;
        private String nationalCode;
        private String name;
        private String ccpComplex;
        private String ccpAssistant;
        private String ccpAffairs;
        private String ccpUnit;
        private String ccpSection;
        private String classCode;
        private String className;
        private String startDate;
        private String endDate;
        private String personelType;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewsStudentsInCanceledClassDTOSpecRs")
    public static class ViewStudentsInCanceledClassDTOSpecRs {
        private ViewStudentsInCanceledClassReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewStudentsInCanceledClassReportDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
