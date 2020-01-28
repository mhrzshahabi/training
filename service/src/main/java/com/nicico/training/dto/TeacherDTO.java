package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.AcademicBK;
import com.nicico.training.model.SubCategory;
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

public class TeacherDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String teacherCode;
    private String personnelCode;
    private Boolean enableStatus;
    private Boolean inBlackList;
    private Boolean personnelStatus;
    private String economicalCode;
    private String economicalRecordNumber;
    private String otherActivities;
    private Long personalityId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherInfo")
    public static class Info extends TeacherDTO {
        private Long id;
        private Set<CategoryDTO.CategoryInfoTuple> categories;
        private Set<SubCategoryDTO.SubCategoryInfoTuple> subCategories;
        private PersonalInfoDTO.Info personality;
        private Set<EmploymentHistoryDTO.Info> employmentHistories;
        private Set<AcademicBKDTO.Info> academicBKs;
        private Set<ForeignLangKnowledgeDTO.Info> foreignLangKnowledges;
        private Set<PublicationDTO.Info> publications;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherCreateRq")
    public static class Create extends TeacherDTO {
        private PersonalInfoDTO.CreateOrUpdate personality;
        private List<CategoryDTO.Info> categories;
        private List<SubCategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherUpdateRq")
    public static class Update extends TeacherDTO {
        private PersonalInfoDTO.CreateOrUpdate personality;
        private List<CategoryDTO.Info> categories;
        private List<SubCategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherSpecRs")
    public static class TeacherSpecRs {
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

    @Getter
    @Setter
    @ApiModel("TeacherFullNameTuple")
    public static class TeacherFullNameTuple {
        private Long id;
        private PersonalInfoDTO personality;

        public String getFullNameFa() {
            return String.format("%s %s", personality.getFirstNameFa(), personality.getLastNameFa());
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class FullNameSpecRs {
        private List<TeacherFullNameTuple> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherFullNameSpecRs")
    public static class TeacherFullNameSpecRs {
        private FullNameSpecRs response;
    }
}