package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ImportedQuestionOption {


        @ApiModelProperty(required = false, hidden = true)
        private Long id;

        @ApiModelProperty(required = true, hidden = false)
        private String title;

}
