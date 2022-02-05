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
public class EducationMajorDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    private String titleEn;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationMajorInfo")
    public static class Info extends EducationMajorDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    @Getter
    @Setter
    @ApiModel("EducationMajorInfoTuple")
    public static class EducationMajorInfoTuple {
        private String titleFa;
        private String titleEn;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationMajorCreateRq")
    public static class Create extends EducationMajorDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationMajorUpdateRq")
    public static class Update extends EducationMajorDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EducationMajorDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EducationMajorSpecRs")
    public static class EducationMajorSpecRs {
        private EducationMajorDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EducationMajorDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
