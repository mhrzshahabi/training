package com.nicico.training.dto;

/*
AUTHOR: ghazanfari_f
DATE: 6/11/2019
TIME: 8:09 AM
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EJobCompetenceType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class JobCompetenceDTO implements Serializable {


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobCompetence DTO Create Req")
    public static class CreateForJob extends JobCompetenceDTO {

        @NotNull
        @ApiModelProperty(required = true)
        private Long jobId;

        @NotNull
        @ApiModelProperty(required = true)
        private Set<Long> competenceIds;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eJobCompetenceTypeId;
    }

     @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobCompetence DTO Create Req")
    public static class CreateForCompetence extends JobCompetenceDTO {

        @NotNull
        @ApiModelProperty(required = true)
        private Long competenceId;

        @NotNull
        @ApiModelProperty(required = true)
        private Set<Long> jobIds;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eJobCompetenceTypeId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobCompetence DTO Update Req")
    public static class Update extends JobCompetenceDTO {

        @NotNull
        @ApiModelProperty(required = true)
        private Long jobId;

        @NotNull
        @ApiModelProperty(required = true)
        private Long competenceId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eJobCompetenceTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobCompetence DTO Delete Req")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobCompetence DTO Info Req")
    public static class Info extends JobCompetenceDTO {
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
        private CompetenceDTO.Info competence;
        private JobDTO.Info job;
        private EJobCompetenceType eJobCompetenceType;
        private Integer eJobCompetenceTypeId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CompetenceSpecRs")
    public static class iscRes {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<JobCompetenceDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}