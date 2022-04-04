package dto.evaluuation;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Setter
@Getter
public class EvaluationAnsweredQuestionsDetailsDTO {

    private String classCode;
    private String classTitle;
    private String answerTitle;
    private String firstName;
    private String lastName;
    private String nationalCode;
    private String complexTitle;
    private String questionTitle;

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EvaluationAnsweredQuestionsDetailsDTOSpecRs")
    public static class EvaluationAnsweredQuestionsDetailsDTOSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<EvaluationAnsweredQuestionsDetailsList> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class EvaluationAnsweredQuestionsDetailsList extends EvaluationAnsweredQuestionsDetailsDTO{
    }

}
