package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class EqualCourseDTO implements Serializable {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EqualCourse - Info")
    public static class Info extends EqualCourseDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long id;
        String idEC;
        String nameEC;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EqualCourse - Add")
    public static class Add extends EqualCourseDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long id;
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long courseId;
        @NotEmpty
        @ApiModelProperty(required = true)
        private List<Long> equalCoursesId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EqualCourse - Remove")
    public static class Remove extends EqualCourseDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long id;
        @NotEmpty
        @ApiModelProperty(required = true)
        private Long courseId;
    }
}

