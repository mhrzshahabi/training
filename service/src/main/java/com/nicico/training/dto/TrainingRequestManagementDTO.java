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
public class TrainingRequestManagementDTO {
    private String applicant;
    private String letterNumber;
    private String complex;
    private Date requestDate;
    private String title;
    private String description;
    private String acceptor;
    private Date letterDate;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestManagementDTO-BankInfo")
    public static class Info extends TrainingRequestManagementDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestManagementDTO")
    public static class Create extends TrainingRequestManagementDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingRequestManagementDTO-CompetenceRequestSpecRs")
    public static class TrainingRequestManagementSpecRs {
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
