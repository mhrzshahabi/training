package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewTrainingFileDTO implements Serializable {
    private String empNo;
    private String postTitle;
    private String postCode;
    private String jobTitle;
    private String postGradeTitle;
    private String complex;
    private String assistant;
    private String affairs;
    private String termTitleFa;
    private String scoresState;
    private Float score;
    private String classStatus;
    private String classCode;
    private String startDate;
    private String endDate;
    private String courseCode;
    private String courseTitle;
    private String teacher;
    private String personType;
    private Integer duration;
    private String runType;
    private String companyName;
    private Integer classStatusNum;
    private Integer scoresStateNum;
    private Integer runTypeNum;
    private String personnelCode;
    private Integer personTypeNum;

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("info")
    public static class Info {
        private String firstName;
        private String lastName;
        private String nationalCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewTrainingFileSpecRs")
    public static class ViewTrainingFileSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewTrainingFileDTO> data;
        private Info info;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    public String getPostGradeTitle() {
        if (postGradeTitle != null) {
            return postGradeTitle.replaceAll("\\d", "");
        }
        return null;
    }
}
