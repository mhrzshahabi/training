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
import java.util.stream.Collectors;

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
    private String blackListDescription;
    private Boolean personnelStatus;
    private String economicalCode;
    private String economicalRecordNumber;
    private String otherActivities;
    private Long personalityId;
    private Long majorCategoryId;
    private Long majorSubCategoryId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherInfo")
    public static class Info extends TeacherDTO {
        private Long id;
        private Set<CategoryDTO.CategoryInfoTuple> categories;
        private Set<SubcategoryDTO.SubCategoryInfoTuple> subCategories;
        private PersonalInfoDTO.Info personality;
        private CategoryDTO.CategoryInfoTuple majorCategory;
        private SubcategoryDTO.SubCategoryInfoTuple majorSubCategory;
        private Integer version;
        private List<Long> roles;

        public String getFullName() {
            return personality.getFirstNameFa() + " " + personality.getLastNameFa();
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("FinalTestTeacherInfo")
    public static class FinalTestInfo extends TeacherDTO {

        private Long id;
        private Integer version;
        private PersonalInfoDTO.CompanyManager personality;

    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherInformation")
    public static class TeacherInformation {

        private PersonalInfoDTO.contractInfo personality;
        private String personnelCode;

        public String getFullName() {

            return personality.getFirstNameFa() + " " + personality.getLastNameFa();
        }

        public String getAddress() {
            AddressDTO.Info homeAddress = null;

            if (personality.getContactInfo() != null && personality.getContactInfo().getHomeAddress() != null) {
                homeAddress = personality.getContactInfo().getHomeAddress();
            } else {
                return "";
            }

            if (homeAddress.getState() != null && homeAddress.getState().getName() != null) {
                return ((homeAddress.getState() == null) ? "" : homeAddress.getState().getName()) + "-" + ((homeAddress.getCity() == null) ? "" : homeAddress.getCity().getName()) + "-" + homeAddress.getRestAddr() + "- کد پستی: " + homeAddress.getPostalCode();
            } else {
                return "";
            }
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherGrid")
    public static class Grid {
        private Long id;
        private String teacherCode;
        private String personnelCode;
        private PersonalInfoDTO.Grid personality;
        private Long personalityId;
        private Boolean personnelStatus;
        private Boolean enableStatus;
        private Set<CategoryDTO.Info> categories;
        private Set<SubcategoryDTO.Info> subCategories;
        private Integer version;

        public String getFullName() {
            return personality.getFirstNameFa() + " " + personality.getLastNameFa();
        }

        public List<Long> getCategories() {
            if (categories == null) return null;
            return categories.stream().map(CategoryDTO.Info::getId).collect(Collectors.toList());
        }

        public List<Long> getSubCategories() {
            if (subCategories == null) return null;
            return subCategories.stream().map(SubcategoryDTO.Info::getId).collect(Collectors.toList());
        }

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherReport")
    public static class Report {
        Set<TclassDTO.TclassTeacherReport> tclasse;
        private Long id;
        private String teacherCode;
        private String personnelCode;
        private PersonalInfoDTO.Report personality;
        private Boolean personnelStatus;
        private String numberOfCourses;
        private String evaluationGrade;
        private String lastCourse;
        private Long lastCourseId;
        private String lastCourseEvaluationGrade;
        private Integer version;
        private String codes;
        private Set<CategoryDTO.CategoryInfoTuple> categories;
        private Set<SubcategoryDTO.SubCategoryInfoTuple> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherSpecRsGrid")
    public static class TeacherSpecRsGrid {
        private SpecRsGrid response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherSpecRsReport")
    public static class TeacherSpecRsReport {
        private SpecRsReport response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsReport {
        private List<Report> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsGrid {
        private List<Grid> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherCreateRq")
    public static class Create extends TeacherDTO {
        private PersonalInfoDTO.CreateOrUpdate personality;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherUpdateRq")
    public static class Update extends TeacherDTO {
        private PersonalInfoDTO.CreateOrUpdate personality;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
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
    public static class SpecRs<T> {
        private List<T> data;
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
    public static class FullNameSpecRs<T> {
        private List<T> data;
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

    @Getter
    @Setter
    @ApiModel("TeacherFullNameTupleWithFinalGrade")
    public static class TeacherFullNameTupleWithFinalGrade {
        private Long id;
        private PersonalInfoDTO personality;
        private String grade;

        public String getFullNameFa() {
            return String.format("%s %s", personality.getFirstNameFa(), personality.getLastNameFa());
        }
    }

    @Getter
    @Setter
    @ApiModel("TeacherInfoTuple")
    public static class TeacherInfoTuple {
        private Long id;
        private PersonalInfoDTO.PersonalInfoCustom personality;

        public String getFullNameFa() {
            return String.format("%s %s", personality.getFirstNameFa(), personality.getLastNameFa());
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherSpecRs")
    public static class TeacherInfoTupleSpecRs {
        private InfoTupleSpecRs response;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class InfoTupleSpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}