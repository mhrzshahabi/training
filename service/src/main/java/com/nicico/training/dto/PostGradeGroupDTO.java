package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class PostGradeGroupDTO implements Serializable {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    private String code;
    private String titleEn;
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGradeGroup - Info")
    public static class Info extends PostGradeGroupDTO {
        private Long id;
        private Set<PostGradeDTO.Info> postGradeSet;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGradeGroup - Create")
    public static class Create extends PostGradeGroupDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGradeGroup - Update")
    public static class Update extends PostGradeGroupDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostGradeGroup - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("PostGradeGroupSpecRs")
    public static class PostGradeGroupSpecRs {
        private PostGradeGroupDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<PostGradeGroupDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
