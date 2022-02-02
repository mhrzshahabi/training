package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EDomainType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class SyllabusDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    private String titleEn;
    @NotNull
    @ApiModelProperty(required = true)
    private Float practicalDuration;
    @NotNull
    @ApiModelProperty(required = true)
    private Float theoreticalDuration;
    private String description;
    @NotNull
    @ApiModelProperty
    private Integer eDomainTypeId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SyllabusInfo")
    public static class Info extends SyllabusDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
        private EDomainType eDomainType;
        private Long goalId;
        private GoalDTO.GoalTitleFa goal;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SyllabusCreateRq")
    public static class Create extends SyllabusDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Long goalId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SyllabusUpdateRq")
    public static class Update extends SyllabusDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SyllabusDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("SyllabusSpecRs")
    public static class SyllabusSpecRs {
        private SyllabusDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<SyllabusDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @ApiModel("SyllabusInfoTuple")
    public static class SyllabusInfoTuple {
        private String titleFa;
        private String titleEn;
        private EDomainType eDomainType;
        private Long theoreticalDuration;
        private Long practicalDuration;
    }
}

