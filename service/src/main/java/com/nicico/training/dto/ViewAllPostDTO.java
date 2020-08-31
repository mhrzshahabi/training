/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/08/24
 * Last Modified: 2020/08/16
 */

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
public class ViewAllPostDTO implements Serializable {

    private Long postId;

    private Long enabled;

    private Long deleted;

    private Integer version;

    private String affairs;

    private String area;

    private String assistance;

    private String code;

    private String costCenterCode;

    private String costCenterTitleFa;

    private String section;

    private String titleFa;

    private String unit;

    private String peopleType;

    private Long groupid;

    private Integer type;

    private String jobTitle;

    private String postGradeTitle;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel(" ViewAllPostInfo")
    public static class Info extends ViewAllPostDTO {
    }
}
