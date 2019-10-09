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
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class TeacherDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String teacherCode;
    private Boolean enableStatus;
    private String economicalCode;
    private String economicalRecordNumber;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherInfo")
    public static class Info extends TeacherDTO {

        private Long id;
        private Long personalityId;
        private Set<CategoryDTO.CategoryInfoTuple> categories;
        private PersonalInfoDTO.PersonalInfoInfoTuple personality;
    }

    @Getter
    @Setter
    @ApiModel("TeacherInfoTuple")
    static class TeacherInfoTuple {
        private PersonalInfoDTO.Create personality;
        private Set<CategoryDTO.CategoryInfoTuple> categories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherCreateRq")
    public static class Create extends TeacherDTO {
        private PersonalInfoDTO.Create personality;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherUpdateRq")
    public static class Update extends TeacherDTO {
        private PersonalInfoDTO.Update personality;
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

}