package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

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

    public String getPostGradeTitle() {
        if (postGradeTitle != null) {
            return postGradeTitle.replaceAll("\\d", "");
        }
        return null;
    }
}
