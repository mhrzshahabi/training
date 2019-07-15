package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.City;
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
public class AddressDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String street;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String alley;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Long postCode;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String phoneNumber;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String mobile;

    @NotEmpty
    @ApiModelProperty(required = true)
    private State state;

    @NotEmpty
    @ApiModelProperty(required = true)
    private City city;

    //---------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AddressInfo")
    public static class Info extends AddressDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }
    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AddressCreateRq")
    public static class Create extends AddressDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AddressUpdateRq")
    public static class Update extends AddressDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AddressDeleteRq")
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
    @ApiModel("AddressSpecRs")
    public static class AddressSpecRs {
        private AddressDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<AddressDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}

