package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.util.Date;
import java.util.List;


@Getter
@Setter
@Accessors(chain = true)
public class CompetenceRequestDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String applicant;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String letterNumber;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Date requestDate;

    @NotEmpty
    @ApiModelProperty(required = true)
    private int requestType;


    // ------------------------------
//
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("BankInfo")
    public static class Info extends CompetenceRequestDTO {
        private Long id;
    }

//    // ------------------------------


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompetenceRequestRq")
    public static class Create extends CompetenceRequestDTO {
    }


    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CompetenceRequestSpecRs")
    public static class CompetenceRequestSpecRs {
        private SpecRs response;
    }

//    // ---------------

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
