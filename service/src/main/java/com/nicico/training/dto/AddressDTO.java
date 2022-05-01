package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class AddressDTO {
    private String restAddr;
    private String postalCode;
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
        private CityDTO.Info city;
        private StateDTO.Info state;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteAddress")
    public static class InstituteAddress extends AddressDTO {
        private Long id;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompanyAddress")
    public static class CompanyAddress {
        private Long id;
        private String restAddr;
        private String postalCode;
        private String phone;
        private String fax;
        private String webSite;
        private Long cityId;
        private Long stateId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AddressCreateOrUpdateRq")
    public static class CreateOrUpdate extends AddressDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AddressCreateRq")
    public static class Create extends AddressDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AddressUpdateRq")
    public static class Update extends AddressDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AddressDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AddressSpecRs")
    public static class AddressSpecRs {
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
    @Accessors(chain = true)
    @ApiModel("MajorInfo")
    public static class MajorInfo {
        private String restAddr;
        private String phone;
        private String fax;
    }
}

