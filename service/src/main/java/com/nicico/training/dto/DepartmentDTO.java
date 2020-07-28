package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class DepartmentDTO implements Serializable {

    @ApiModelProperty
    private Long id;
    @ApiModelProperty
    private String title;
    @ApiModelProperty
    private String code;

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("DepartmentInfo")
    public static class Info extends DepartmentDTO {

        private String parentCode;
        private String hozeTitle;
        private String moavenatTitle;
        private String omorTitle;
        private String ghesmatCode;
        private String vahedTitle;
    }


    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("DepartmentSpecRs")
    public static class DepartmentSpecRs {
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

    //Amin HK
    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("FieldValue")
    public static class FieldValue {
        private String value;
    }
}
