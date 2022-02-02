package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@Accessors(chain = true)
public class ImportedQuestion {
    @ApiModelProperty
    private Long id;
    @ApiModelProperty(required = true)
    private String title;
    @ApiModelProperty
    private String description;
    @ApiModelProperty
    private EQuestionType type;
    @ApiModelProperty
    private Boolean isEvaluationQuestion;
    @ApiModelProperty
    private boolean dbStatus;
//        @ApiModelProperty(hidden = true)
//        private int usageCount;
//        @ApiModelProperty
//        private QuestionLevel questionLevel;
    @ApiModelProperty
    private List<ImportedQuestionOption> questionOption;
    @ApiModelProperty
    private List<Map<String, String>> files;
//        @ApiModelProperty
//        private List<Map<String,String>> option1Files;
//
//        @ApiModelProperty
//        private List<Map<String,String>> option2Files;
//
//        @ApiModelProperty
//        private List<Map<String,String>> option3Files;
//
//        @ApiModelProperty
//        private List<Map<String,String>> option4Files;
    @ApiModelProperty
    private Boolean hasAttachment;
    @ApiModelProperty(required = true)
    private Double proposedPointValue;
}
