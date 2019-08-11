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
public class SkillStandardCategoryDTO {

	@NotNull
	@ApiModelProperty(required = true)
	private String code;
	@NotEmpty
	@ApiModelProperty(required = true)
	private String titleFa;
	@NotNull
	@ApiModelProperty(required = true)
	private String titleEn;

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("SkillStandardCategoryInfo")
	public static class Info extends SkillStandardCategoryDTO {
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
	@ApiModel("SkillStandardCategoryInfoTuple")
	public static class SkillStandardCategoryInfoTuple {
		private Long id;
		private String code;
		private String titleFa;
		private String titleEn;
	}

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("SkillStandardCategoryCreateRq")
	public static class Create extends SkillStandardCategoryDTO {
		private Set<Long> skillStandardSubCategoryIds;
	}

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("SkillStandardCategoryUpdateRq")
	public static class Update extends SkillStandardCategoryDTO {
		private Set<Long> skillStandardSubCategoryIds;
		@NotNull
		@ApiModelProperty(required = true)
		private Integer version;
	}

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("SkillStandardCategoryDeleteRq")
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
	@ApiModel("SkillStandardCategorySpecRs")
	public static class SkillStandardCategorySpecRs {
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
