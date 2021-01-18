package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
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

public class EducationLevelDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    private Integer code;
    private String titleEn;

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationLevelInfo")
    public static class Info extends EducationLevelDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    //-------------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationLevelInfoTuple")
    public static class EducationLevelInfoTuple {
        private Integer code;
        private String titleFa;
        private String titleEn;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationLevelCreateRq")
    public static class Create extends EducationLevelDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationLevelUpdateRq")
    public static class Update extends EducationLevelDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationLevelDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EducationLevelSpecRs")
    public static class EducationLevelSpecRs {
        private EducationLevelDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EducationLevelDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
