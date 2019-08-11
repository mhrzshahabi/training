package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class StudentDTO {
    
    @ApiModelProperty(required = true)
    private String studentID;

    @ApiModelProperty(required = true)
    private String fullNameFa;

    @ApiModelProperty(required = true)
    private String fullNameEn;

    private String personalID;
    private String department;
    private String license;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentInfo")
    public static class Info extends StudentDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentCreateRq")
    public static class Create extends StudentDTO {
       }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentUpdateRq")
    public static class Update extends StudentDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentDeleteRq")
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
    @ApiModel("StudentSpecRs")
    public static class StudentSpecRs {
        private SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<StudentDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
