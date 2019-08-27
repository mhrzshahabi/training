package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.State;
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
public class CityDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String name;

    //---------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CityInfo")
    public static class Info extends CityDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
        private StateDTO.StateInfoTuple state;
    }

    @Getter
	@Setter
	@ApiModel("CityInfoTuple")
	public static class CityInfoTuple {
        private Long id;
	    private String name;
	}
    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CityCreateRq")
    public static class Create extends CityDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CityUpdateRq")
    public static class Update extends CityDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CityDeleteRq")
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
    @ApiModel("CitySpecRs")
    public static class CitySpecRs {
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

