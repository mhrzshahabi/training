package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.*;

@Getter
@Setter
@Accessors(chain = true)
public class ViewClassDTO {

    private Long id;
    private String code;
    private String titleClass;
    private String startDate;
    private String endDate;
    private String studentCount;
    private Long group;
    private String teacher;
    private Long teacherId;
    private String planner;
    private Long plannerId;
    private String supervisor;
    private String organizer;
    private Long termId;
    private String topology;
    private String classStatus;
    private String reason;
    private String workflowEndingStatus;
    private Boolean classToOnlineStatus;
    private String classCancelReason;

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewClassDTO> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewClassSpecRs")
    public static class ViewClassSpecRs {
        private ViewClassDTO.SpecRs response;
    }

}
