package dto.evaluuation;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
@JsonFormat
public enum EvalQuestionType {
    OPTIONAL,
    MULTIPLE_CHOICE,
    IN_RANGE;
}
