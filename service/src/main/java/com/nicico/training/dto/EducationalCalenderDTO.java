package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class EducationalCalenderDTO implements Serializable {
    @ApiModelProperty(required = true)
    private Long id;
    @ApiModelProperty(required = true)
    private String code;
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty(required = true)
    private String titleEn;
    @ApiModelProperty(required = true)
    private String startDate;
    @ApiModelProperty(required = true)
    private String endDate;
    @ApiModelProperty(required = true)
    private String calenderStatus;
    private String instituteName;
    private InstituteDTO.InstituteInfoTuple institute;
    @ApiModelProperty(required = true)
    private Long instituteId;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TermInfo")
    public static class Info extends EducationalCalenderDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EducationalCalenderSpecRs")
    public static class EducationalCalenderSpecRs {
        private EducationalCalenderDTO.SpecRs response;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EducationalCalenderDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;

        public void setResponse(SpecRs specResponse) {
        }
    }

}
