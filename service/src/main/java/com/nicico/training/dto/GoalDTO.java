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
public class GoalDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    private String titleEn;
    private Long categoryId;
    private Long subCategoryId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GoalInfo")
    public static class Info extends GoalDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GoalCreateRq")
    public static class Create extends GoalDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GoalUpdateRq")
    public static class Update extends GoalDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GoalDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("GoalSpecRs")
    public static class GoalSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<GoalDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class Syllabuses extends GoalDTO {
        private List<SyllabusDTO.SyllabusInfoTuple> syllabusSet;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class GoalTitleFa {
        private String titleFa;
    }
}
