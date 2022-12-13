package dto.exam;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Setter
@Getter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ExamStudentDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ExamStudentDTO.Info")
    public static class Info {

        @ApiModelProperty
        private String firstName;

        @ApiModelProperty
        private String lastName;

        @ApiModelProperty
        private String nationalCode;

        @ApiModelProperty
        private Double score;

        @ApiModelProperty
        private String scoreStateTitle;

    }

}
