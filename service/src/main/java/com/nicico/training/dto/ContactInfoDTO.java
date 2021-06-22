package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EMobileForSMS;
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

public class ContactInfoDTO {

    private String email;
    private String mobile;
    private String personalWebSite;
    private Long homeAddressId;
    private Long workAddressId;
    private String mdmsMobile;
    private String hrMobile;
    private String mobile2;
    private EMobileForSMS eMobileForSMS;
    private Date lastModifiedDate;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfo")
    public static class Info extends ContactInfoDTO {
        private Long id;
        private AddressDTO.Info homeAddress;
        private AddressDTO.Info workAddress;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteContactInfo")
    public static class InstituteContactInfo extends ContactInfoDTO {
        private Long id;
        private String email;
        private String mobile;
        private String personalWebSite;
        private AddressDTO.InstituteAddress workAddress;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoGrid")
    public static class Grid {
        private Long id;
        private String mobile;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ManagerContactInfo")
    public static class ManagerContactInfo {
        private Long id;
        private String email;
        private String mobile;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoCreateOrUpdateRq")
    public static class CreateOrUpdate extends ContactInfoDTO {
        private Long id;
        private AddressDTO.CreateOrUpdate homeAddress;
        private AddressDTO.CreateOrUpdate workAddress;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoCreateRq")
    public static class Create extends ContactInfoDTO {
        private Long id;
        private AddressDTO.CreateOrUpdate homeAddress;
        private AddressDTO.CreateOrUpdate workAddress;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContactInfoUpdateRq")
    public static class Update extends ContactInfoDTO {
        private Long id;
        private AddressDTO.CreateOrUpdate homeAddress;
        private AddressDTO.CreateOrUpdate workAddress;
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

    public void setMobileForSMS(Integer mobileForSMS) {
        eMobileForSMS = EMobileForSMS.getEnum(mobileForSMS);
    }

    public Integer getMobileForSMS() {
        if (eMobileForSMS == null)
            return null;
        return eMobileForSMS.getId();
    }

    public String getSmSMobileNumber() {
        if (eMobileForSMS == null)
            return mobile;
        switch (eMobileForSMS) {
            case hrMobile:
                return hrMobile;
            case mdmsMobile:
                return mdmsMobile;
            case trainingSecondMobile:
                return mobile2;
            default:
                return mobile;
        }
    }

}

