package com.nicico.training.dto;

import com.nicico.copper.common.util.date.DateUtil;
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

@Getter
@Setter
@Accessors(chain = true)
public class ViewjobDTO implements Serializable {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String code;
    @ApiModelProperty()
    private Integer competenceCount;
    @ApiModelProperty()
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
    @ApiModel("JobInfo")
    public static class Info extends ViewjobDTO {
        private Long id;
        private Long enabled;
    }
}
