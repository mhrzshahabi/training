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
public class EducationOrientationDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty(required = true)
    private String titleEn;
    @NotNull
    @ApiModelProperty(required = true)
    private Long educationLevelId;
    @NotNull
    @ApiModelProperty(required = true)
    private Long educationMajorId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationOrientationInfo")
    public static class Info extends EducationOrientationDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
        private EducationLevelDTO.Info educationLevel;
        private EducationMajorDTO.Info educationMajor;
    }

    @Getter
    @Setter
    @ApiModel("EducationOrientationInfoTuple")
    static class EducationOrientationInfoTuple {
        private String titleFa;
        private String titleEn;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationOrientationCreateRq")
    public static class Create extends EducationOrientationDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationOrientationUpdateRq")
    public static class Update extends EducationOrientationDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationOrientationDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EducationOrientationSpecRs")
    public static class EducationOrientationSpecRs {
        private EducationOrientationDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EducationOrientationDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
