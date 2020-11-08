package dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum Gender {
    MALE(1,"مرد", "M"),
    FEMALE(2, "زن", "F");

    private final int id;
    private final String titleFa;
    private final String code;

    public String getLiteral() {
        return name();
    }
}
