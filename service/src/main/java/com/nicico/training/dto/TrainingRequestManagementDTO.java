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
    private String title;
    private String description;
    private String acceptor;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestManagementDTO-BankInfo")
    public static class Info extends TrainingRequestManagementDTO {
        private Long id;
        private Date requestDate;
        private Date letterDate;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingPositionAppointmentInfo-BankInfo")
    public static class PositionAppointmentInfo  {
        private Long id;
        private Long personnelId;
        private Long postId;
        private String name;
        private String lastName;
        private String nationalCode;
        private String personnelNo2;
        private String personnelNo;
        private String currentPostTitle;
        private String currentPostCode;
        private String nextPostTitle;
        private String nextPostCode;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestManagementDTO")
    public static class Create extends TrainingRequestManagementDTO {
        private Date requestDate;
        private Date letterDate;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestManagementDTOUpdate")
    public static class Update extends TrainingRequestManagementDTO {
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CreatePositionAppointment")
    public static class CreatePositionAppointment  {
        private Long postId;
        private Long reqId;
        private Long personnelId;
        private String ref;

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
    @ApiModel("TrainingRequestManagementDTO-CompetenceRequestSpecRs")
    public static class PASpecRs {
        private SpecRsPA response;
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
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsPA {
        private List<PositionAppointmentInfo> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
