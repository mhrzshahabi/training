package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class ContactInfoDTO {

    private String email;
    private String mobile;
    private String personalWebSite;
    private String description;
    private Long homeAddressId;
    private Long workAddressId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfo")
    public static class Info extends ContactInfoDTO {
        private Long id;
        private AddressDTO.Info homeAddress;
        private AddressDTO.Info workAddress;
    }

    @Getter
    @Setter
    @ApiModel("ContactInfoInfoTuple")
    static class ContactInfoInfoTuple extends ContactInfoDTO {
        private Long id;
        private AddressDTO.Info homeAddress;
        private AddressDTO.Info workAddress;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoCreateRq")
    public static class Create extends ContactInfoDTO {
        private AddressDTO.Create homeAddress;
        private AddressDTO.Create workAddress;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoUpdateRq")
    public static class Update extends ContactInfoDTO {
        private Long id;
        private AddressDTO.Update homeAddress;
        private AddressDTO.Update workAddress;
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

