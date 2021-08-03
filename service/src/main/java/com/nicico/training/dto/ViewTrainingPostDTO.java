package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.service.ParameterValueService;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewTrainingPostDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String code;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String affairs;

    @ApiModelProperty
    private String area;

    @ApiModelProperty
    private String mojtameTitle;

    @ApiModelProperty
    private String assistance;

    @ApiModelProperty
    private String costCenterTitleFa;

    @ApiModelProperty
    private String costCenterCode;

    @ApiModelProperty
    private String section;

    @ApiModelProperty
    private String unit;

    @ApiModelProperty()
    private Long departmentId;

    @ApiModelProperty
    private Long postGradeId;

    @ApiModelProperty
    private Long jobId;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String jobTitleFa;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String jobCode;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String postGradeTitleFa;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String postGradeCode;

    @ApiModelProperty
    private Integer competenceCount;

    @ApiModelProperty
    private Integer personnelCount;

    @ApiModelProperty
    @Getter(AccessLevel.NONE)
    private Date lastModifiedDateNA;

    @ApiModelProperty
    private String modifiedByNA;

    @ApiModelProperty
    private String peopleType;

    public String getLastModifiedDateNA(){
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        if(lastModifiedDateNA != null)
            return DateUtil.convertMiToKh(formatter.format(lastModifiedDateNA));
        return "آپ دیت نشده";
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostInfo")
    public static class Info extends ViewTrainingPostDTO{
        private Long id;
        private Long enabled;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PostReport")
    public static class Report extends Info {
        private String mojtameCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("PostSpecRs")
    public static class PostSpecRs {
        private ViewTrainingPostDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
