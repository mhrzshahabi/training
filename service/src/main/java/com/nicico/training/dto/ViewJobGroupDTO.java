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
public class ViewJobGroupDTO implements Serializable {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty
    private String code;
    @ApiModelProperty()
    private String titleEn;
    @ApiModelProperty()
    private String description;
    @ApiModelProperty()
    private Integer competenceCount;
    @ApiModelProperty()
    private Integer personnelCount;
    @ApiModelProperty
    @Getter(AccessLevel.NONE)
    private Date lastModifiedDateNA;
    @ApiModelProperty
    private String modifiedByNA;

    public String getLastModifiedDateNA() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        if (lastModifiedDateNA != null)
            return DateUtil.convertMiToKh(formatter.format(lastModifiedDateNA));
        return "آپ دیت نشده";
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("JobGroupInfo")
    public static class Info extends ViewJobGroupDTO {
        private Long id;
    }
}
