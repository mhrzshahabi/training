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
public class PostGroupDTO {
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
    @ApiModel("PostGroupInfo")
    public static class Info extends PostGroupDTO {
        private Long id;
        private Set<PostDTO.Info> postSet;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGroupCreateRq")
    public static class Create extends PostGroupDTO {
        private Set<Long> postIds;
        ;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGroupUpdateRq")
    public static class Update extends PostGroupDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGroupIdListRq")
    public static class PostGroupIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGroupDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private Set<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("PostGroupSpecRs")
    public static class PostGroupSpecRs {
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
