package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.apache.commons.lang3.builder.HashCodeBuilder;

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
        private String ghesmatTitle;
        private String vahedTitle;
        private String type;
        private Long enabled;
        public Long parentId;
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

    @Getter
    @Setter
    @ApiModel("TSociety")
    public static class TSociety{

        private Long id;
        public String title;
        public String code;
        public Long parentId;

        @Override
        public int hashCode() {
            return new HashCodeBuilder(17, 31).
                    append(code).
                    toHashCode();
        }

        @Override
        public boolean equals(Object obj) {
            if (!(obj instanceof CompetenceWebserviceDTO))
                return false;
            return (this.getId().equals(((CompetenceWebserviceDTO.TupleInfo) obj).getId()));
        }
    }

}
