package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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
import java.util.Set;

@Getter
@Setter
@Accessors(chain=true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class SkillStandardGroupDTO {

	@NotEmpty
	@ApiModelProperty(required = true)
	private String titleFa;
    @NotNull
    @ApiModelProperty(required = true)
    private String titleEn;

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain=true)
    @ApiModel("SkillStandardGroupInfo")
    public static class Info extends SkillStandardGroupDTO{
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillStandardGroupCreateRq")
    public static  class Create extends SkillStandardGroupDTO{
        private Set<Long> skillStandardIds;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillStandardGroupUpdateRq")
    public static class Update extends SkillStandardGroupDTO{
		private Set<Long> skillStandardIds;
        @NotNull
        @ApiModelProperty(required = true)
		private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillStandardGroupDeleteRq")
    public static class Delete{
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;

    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("SkillStandardGroupSpecRs")
    public static class SkillStandardGroupSpecRs{
        private SpecRs response;
    }

	// ---------------

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
