package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.copper.common.util.date.DateUtil;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import javax.validation.constraints.NotEmpty;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewClassCostDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewClassCostDTO-Info")
    public static class Info {
        private Long id;

        private String acceptanceLimit;

        private String classStudent;

        private String classCode;

        private String classStartDate;

        private String classEndDate;

        private String classTitle;


        private String studentCost;

        private String currency;

        private String courseCode;

        private String courseTitle;

        private String teacher;

        private String teacherNationalCode;

        private String COMPLEX;

        private String isPersonnel;

        private String totalStudent;

        private String cost;
        private String omor;

        private String moavenat;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewClassCostDTOSpecRs")
    public static class ViewClassCostDTOspecRs {
        private ViewClassCostDTO.SpecRs response;
    }



    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewClassCostDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
