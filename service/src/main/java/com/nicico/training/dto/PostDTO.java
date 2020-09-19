/*
ghazanfari_f, 8/29/2019, 10:48 AM
*/
package com.nicico.training.dto;

import com.nicico.training.model.ParameterValue;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class PostDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Post - Info")
    public static class Info {
        private Long id;
        private String code;
        private String titleFa;
        private JobDTO.Info job;
        private PostGradeDTO.Info postGrade;
        private String area;
        private String assistance;
        private String affairs;
        private String section;
        private String unit;
        private String costCenterCode;
        private String costCenterTitleFa;
        private String peopleType;
        private Long enabled;
//        private DepartmentDTO.Info department;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Post - TupleInfo")
    public static class TupleInfo {
        private Long id;
        private String code;
        private String titleFa;
        private Long enabled;
        private Long deleted;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelInfo")
    public static class PersonnelInfo {
        private Long id;
        private String code;
        private String titleFa;
        private String peopleType;
        private Long enabled;
        private Long deleted;
        private JobDTO.Info job;
        private PostGradeDTO.Info postGrade;
    }
}
