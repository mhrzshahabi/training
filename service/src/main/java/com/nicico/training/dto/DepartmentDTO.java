package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.*;
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
        private String ghesmatTitle;
        private String vahedTitle;
        private String type;
        private Long enabled;
        public Long parentId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("DepartmentSpecRs")
    public static class DepartmentSpecRs {
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
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("FieldValue")
    public static class FieldValue {
        private String value;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @NoArgsConstructor
    @Accessors(chain = true)
    @ApiModel("OrganSegment")
    public static class OrganSegment extends DepartmentDTO {
        private String type;
        private Long enabled;
    }

    @Getter
    @Setter
    @EqualsAndHashCode(of = {"id"}, callSuper = false)
    @ApiModel("TSociety")
    public static class TSociety {
        private Long id;
        public String title;
        public String code;
        public Long parentId;
    }

    @Getter
    @Setter
    @EqualsAndHashCode(of = {"id"}, callSuper = false)
    @ApiModel("DepChart")
    public static class DepChart {
        private Long id;
        public String title;
        public String code;
        public String category;
        public Long parentId;
        public String parentTitle;
    }
}
