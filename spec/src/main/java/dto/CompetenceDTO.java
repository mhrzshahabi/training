package dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;


@Setter
@Getter
public class CompetenceDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String title;
    @NotNull
    @ApiModelProperty(required = true)
    private Long competenceTypeId;


}
