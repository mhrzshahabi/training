package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class CourseProtocolImportDTO {
    @ApiModelProperty(required = true)
    private String name;
    @ApiModelProperty(required = true)
    private String code;
    @ApiModelProperty(required = true)
    private Integer capacity;
    @ApiModelProperty(required = true)
    private Integer duration;
    @ApiModelProperty(required = true)
    private CourseStatus courseStatus;
    @ApiModelProperty(required = true)
    private ClassType classType;
    @ApiModelProperty(required = true)
    private CourseType courseType;
    @ApiModelProperty(required = true)
    private Long startDate;
    @ApiModelProperty(required = true)
    private Long finishDate;
}
