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
public class SkillLevelDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty(required = true)
    private String titleEn;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLevelInfo")
    public static class Info extends SkillLevelDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    @Getter
    @Setter
    @ApiModel("SkillLevelInfoTuple")
    public static class SkillLevelInfoTuple {
        private Long id;
        private String titleFa;
        private String titleEn;
    }
    @Getter
    @Setter
    @ApiModel("SkillLevelInfoTuple")
    public static class SkillLevelInfoTupleV2 {
        private Long id;
        private String titleFa;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLevelCreateRq")
    public static class Create extends SkillLevelDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLevelUpdateRq")
    public static class Update extends SkillLevelDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillLevelDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("SkillLevelSpecRs")
    public static class SkillLevelSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
