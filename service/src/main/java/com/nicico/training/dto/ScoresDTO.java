package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
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
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class ScoresDTO implements Serializable {

    @ApiModelProperty(required = true)
    private String scoresState;

    @ApiModelProperty(required = true)
    private String reasonsfailure;

    @ApiModelProperty(required = true)
    private double score;

    @ApiModelProperty(required = true)
    private Long studentId;

    @ApiModelProperty(required = true)
    private Long tclassId;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ScoresInfo")
    public static class Info extends ScoresDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private TclassDTO.Info tclass;
        private StudentDTO.Info student;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ScoresCreateRq")
    public static class Create extends ScoresDTO {

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ScoresUpdateRq")
    public static class Update extends ScoresDTO {

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ScoresDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ScoresIdListRq")
    public static class ScoresIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ScoresSpecRs")
    public static class ScoresSpecRs {
        private ScoresDTO.SpecRs response;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ScoresDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }


}
