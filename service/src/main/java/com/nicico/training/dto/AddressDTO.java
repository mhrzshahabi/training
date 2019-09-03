package com.nicico.training.dto;

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
public class AddressDTO {

    private String address;
    private Long postCode;
    private String phone;
    private String fax;
    private String webSite;
    private Boolean otherCountry;

    private Long cityId;
    private Long stateId;

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
        private CityDTO.CityInfoTuple city;
        private StateDTO.StateInfoTuple state;
    }

    @Getter
	@Setter
	@ApiModel("AddressInfoTuple")
	public static class AddressInfoTuple {
        private String address;
        private Long postCode;
        private String phone;
        private String fax;
        private String webSite;
        private Boolean otherCountry;
        private CityDTO.CityInfoTuple city;
        private StateDTO.StateInfoTuple state;
        private Long cityId;
        private Long stateId;
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

