package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class JobGroupDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty
    private String code;
    @ApiModelProperty()
    private String titleEn;
    @ApiModelProperty()
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobGroupInfo")
    public static class Info extends JobGroupDTO {
        private Long id;
        private Set<JobDTO.Info> jobSet;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobGroupTuple")
    public static class Tuple extends JobGroupDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobGroupCreateRq")
    public static class Create extends JobGroupDTO {
        private Set<Long> jobIds;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobGroupUpdateRq")
    public static class Update extends JobGroupDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobGroupIdListRq")
    public static class JobGroupIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobGroupDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private Set<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("JobGroupSpecRs")
    public static class JobGroupSpecRs {
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
