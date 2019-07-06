package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.copper.common.dto.date.DateTimeDTO;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class TeacherDTO {

	@NotEmpty
	@ApiModelProperty(required = true)
	private String fullNameFa;
	private String fullNameEn;
	@NotEmpty
	@ApiModelProperty(required = true)
	private String nationalCode;
	private String mobile;
	private String phone;
	private String homeAddress;
	private String workAddress;

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("TeacherInfo")
	public static class Info extends TeacherDTO {
		private Long id;
		private DateTimeDTO.DateTimeRs createdDate;
		private String createdBy;
		private DateTimeDTO.DateTimeRs lastModifiedDate;
		private String lastModifiedBy;
		private Integer version;
	}

	//-------------------------------
	@Getter
	@Setter
	@ApiModel("TeacherInfoTuple")
	public static class TeacherInfoTuple {
		private Long id;
		private String fullNameFa;
	}
	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("TeacherCreateRq")
	public static class Create extends TeacherDTO {
	}

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("TeacherUpdateRq")
	public static class Update extends TeacherDTO {
		@NotNull
		@ApiModelProperty(required = true)
		private Integer version;
	}

	// ------------------------------

	@Getter
	@Setter
	@Accessors(chain = true)
	@ApiModel("TeacherDeleteRq")
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
	@ApiModel("TeacherSpecRs")
	public static class TeacherSpecRs {
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
