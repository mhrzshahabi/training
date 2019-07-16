package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.copper.common.dto.date.DateTimeDTO;
import com.nicico.training.model.Category;
import com.nicico.training.model.EducationOrientation;
import com.nicico.training.model.enums.EGender;
import com.nicico.training.model.enums.EMarried;
import com.nicico.training.model.enums.EMilitary;
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
	@NotEmpty
	@ApiModelProperty(required = true)
	private String fullNameEn;
	@NotEmpty
	@ApiModelProperty(required = true)
	private String nationalCode;
	@NotEmpty
	@ApiModelProperty(required = true)
	private String teacherCode;

	private String fatherName;
	private String birthDate;
	private String birthLocation;
	private String birthCertificate;
	private String birthCertificateLocation;
	private String religion;
	private String nationality;
	private String email;

	private String mobile;
	private String description;
	private String workName;
	private String workAddress;
	private String workPhone;
	private String workPostalCode;
	private String workJob;
	private String workTeleFax;
	private String workWebSite;
	private String homeAddress;
	private String homePhone;
	private String homePostalCode;
    private String attachPhoto;
    private String attachExtension;

	private Boolean enableStatus;
	private String economicalCode;
	private String economicalRecordNumber;
	private String eduLevel;
	private String eduMajor;
	private String eduOrientation;
	private String accountNember;
	private String bank;
	private String bankBranch;
	private String cartNumber;
	private String shabaNumber;

	private Integer eMilitaryId;
	private Integer eMarriedId;
	private Integer eGenderId;

    private Long educationLevelId;
    private Long educationMajorId;
    private Long educationOrientationId;

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
		private List<CategoryDTO.CategoryInfoTuple> categories;
		private EMilitary eMilitary;
		private EMarried eMarried;
		private EGender eGender;
		private EducationLevelDTO.EducationLeveInfoTuple educationLevel;
		private EducationMajorDTO.EducationMajorInfoTuple educationMajor;
		private EducationOrientationDTO.EducationOrientationInfoTuple educationOrientation;
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
