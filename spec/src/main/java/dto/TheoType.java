package dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum TheoType {

    Theory(1, "تئوري", "T"),
    Practical(2, "عملي", "P"),
    TheoryPractical(3, "تئوري_عملي", "M");

    private final Integer id;
    private final String titleFa;
    private final String code;

    public String getLiteral() {
        return name();
    }
}