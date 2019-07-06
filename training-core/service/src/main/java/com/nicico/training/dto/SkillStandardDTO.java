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
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class SkillStandardDTO {

	@NotNull
	@ApiModelProperty(required = true)
	private String code;
	@NotEmpty
	@ApiModelProperty(required = true)
	private String titleFa;
	@NotNull
	@ApiModelProperty(required = true)
	private String titleEn;
	@NotNull
	@ApiModelProperty(required = true)
	private Long skillLevelId;
	@NotNull
	@ApiModelProperty(required = true)
	private Long skillStandardCategoryId;

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("SkillStandardInfo")
	public static class Info extends SkillStandardDTO {
		private Long id;
		private SkillLevelDTO.SkillLevelInfoTuple skillLevel;
		private SkillStandardCategoryDTO.SkillStandardCategoryInfoTuple skillStandardCategory;
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
	@ApiModel("SkillStandardCreateRq")
	public static class Create extends SkillStandardDTO {
		private Set<Long> courseIds;
	}

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("SkillStandardUpdateRq")
	public static class Update extends SkillStandardDTO {
		private Set<Long> courseIds;
		@NotNull
		@ApiModelProperty(required = true)
		private Integer version;
	}

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("SkillStandardDeleteRq")
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
	@ApiModel("SkillStandardSpecRs")
	public static class SkillStandardSpecRs {
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
