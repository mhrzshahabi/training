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

//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @ApiModel("Department - Info")
//    public static class Info {
//        private Long id;
//        private String assistance;
//        private String affairs;
//        private String section;
//        private String unit;
//        private String costCenterCode;
//        private String costCenterTitleFa;
//    }

    @ApiModelProperty
    private Long depParrentId;

    @ApiModelProperty(required = true)
    private String departmentName;

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("DepartmentInfo")
    public static class Info extends DepartmentDTO {

        private Long id;
        private String code;
        private String treeVersion;
        private String parentCode;
        //private DepartmentDTO.Info parentDepartment;
    }

    // ------------------------------

//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @ApiModel("DepartmentCreateRq")
//    public static class Create extends DepartmentDTO {
//        private Integer version;
//        private String departmentName;
//        private String parentCode;
//        private Long depParrentId;
//        private String code;
//        private Long sync;
//        private String treeVersion;
//    }
//
//    // ------------------------------
//
//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @ApiModel("DepartmentUpdateRq")
//    public static class Update extends DepartmentDTO {
//        private Long id;
//    }
//
//    // ------------------------------
//
//    @Getter
//    @Setter
//    @Accessors(chain = true)
//    @ApiModel("DepartmentDeleteRq")
//    public static class Delete {
//        @NotNull
//        @ApiModelProperty(required = true)
//        private List<Long> ids;
//    }

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
