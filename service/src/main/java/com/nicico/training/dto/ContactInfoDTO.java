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
public class ContactInfoDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfo")
    public static class Info{
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private AddressDTO.AddressInfoTuple homeAddress;
        private AddressDTO.AddressInfoTuple workAddress;
        private String email;
        private String mobile;
        private String personalWebSite;
        private String description;
        private Long homeAddressId;
        private Long workAddressId;
    }

    @Getter
	@Setter
	@ApiModel("ContactInfoInfoTuple")
	public static class ContactInfoInfoTuple {
	    private Long id;
        private String email;
        private String mobile;
        private String personalWebSite;
        private String description;
        private AddressDTO.AddressInfoTuple homeAddress;
        private AddressDTO.AddressInfoTuple workAddress;

	}

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoCreateRq")
    public static class Create{
        private AddressDTO.Create homeAddress;
        private AddressDTO.Create workAddress;
        private String email;
        private String mobile;
        private String personalWebSite;
        private String description;
        private Long homeAddressId;
        private Long workAddressId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoUpdateRq")
    public static class Update{
        private AddressDTO.Update homeAddress;
        private AddressDTO.Update workAddress;
        private String email;
        private String mobile;
        private String personalWebSite;
        private String description;
        private Long homeAddressId;
        private Long workAddressId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ContactInfoSpecRs")
    public static class ContactInfoSpecRs {
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

