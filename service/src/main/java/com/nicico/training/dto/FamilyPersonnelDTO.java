package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class FamilyPersonnelDTO {



    @Getter
    @Setter
    @Accessors
    @ApiModel("Family - Info")
    public static class Info {
        private Long id;
        private String familyNationalCode;
        private String familyFirstName;
        private String familyLastName;
        private String familyFatherName;
        private String familyMobile;
        private String familyGen;
        private String personnelNationalCode;
        private String personnelFirstName;
        private String personnelLastName;
        private String personnelFatherName;

    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("FamilySpecRs")
    public static class FamilySpecRs {
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
