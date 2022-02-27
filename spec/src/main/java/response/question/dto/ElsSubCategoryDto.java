package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ElsSubCategoryDto {
    @ApiModelProperty
    private Long id;
    @ApiModelProperty
    private String code;
    @ApiModelProperty
    private String titleFa;
    @ApiModelProperty
    private String titleEn;
    @ApiModelProperty
    private Long categoryId;
}
