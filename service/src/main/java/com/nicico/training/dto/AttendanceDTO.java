package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EDomainType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class AttendanceDTO {
    private String description;
    private String state;

    // ------------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceInfo")
    public static class Info extends AttendanceDTO {
        private Long tclassId;
        private Long studentId;
        private Long sessionId;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceCreateRq")
    public static class Create extends AttendanceDTO {
        private Long tclassId;
        private Long studentId;
        private Long sessionId;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceUpdateRq")
    public static class Update extends AttendanceDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AttendanceDeleteRq")
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
    @ApiModel("AttendanceSpecRs")
    public static class AttendanceSpecRs {
        private AttendanceDTO.SpecRs response;
    }

    // ---------------

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

    //-----------------------
}

