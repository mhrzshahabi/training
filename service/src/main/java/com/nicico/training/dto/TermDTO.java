package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class TermDTO implements Serializable {
    @ApiModelProperty(required = true)
    private String code;
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty(required = true)
    private String startDate;
    @ApiModelProperty(required = true)
    private String endDate;
    @ApiModelProperty()
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TermInfo")
    public static class Info extends TermDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TermCreateRq")
    public static class Create extends TermDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TermUpdateRq")
    public static class Update extends TermDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TermDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TermIdListRq")
    public static class TermIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TermSpecRs")
    public static class TermSpecRs {
        private TermDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<TermDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Year")
    public static class Year {
        private String startDate;
        private String year;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("YearSpecRs")
    public static class YearSpecRs {
        private TermDTO.YSpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class YSpecRs {
        private List<TermDTO.Year> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TermDTOTuple")
    public static class TermDTOTuple extends TermDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Years")
    @AllArgsConstructor
    public static class Years {
        private String year;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("YearsSpecRs")
    public static class YearsSpecRs {
        private TermDTO.YsSpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class YsSpecRs {
        private List<TermDTO.Years> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

