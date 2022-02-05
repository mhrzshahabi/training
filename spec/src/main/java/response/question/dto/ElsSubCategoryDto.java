package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ElsSubCategoryDto {
    @ApiModelProperty
    private Long subCategoryId;
    @ApiModelProperty
    private String subCategoryCode;
    @ApiModelProperty
    private String subCategoryName;
    @ApiModelProperty
    private String subCategoryNameEn;
    @ApiModelProperty
    private Long categoryId;
}
