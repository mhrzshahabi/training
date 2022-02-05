package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ElsCategoryDto {
    @ApiModelProperty
    private Long categoryId;
    @ApiModelProperty
    private String categoryCode;
    @ApiModelProperty
    private String categoryName;
    @ApiModelProperty
    private String categoryNameEn;
}
