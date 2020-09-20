package dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum RunType {
    Internal(1, "داخلي", "C"),
    Dispatch(2, "اعزام", "D"),
    InternalSeminar(3, "سمينار داخلي", "S"),
    DispatchSeminar(4, "سمينار اعزام", "H"),
    WhileWorking(5, "حين كار", "J"),
    External(6, "خارجی", "F"),
    ExternalSeminar(7, "سمینار خارجی", "O"),
    Virtual(8, "مجازي", "E"),
    ReView(9, "بازآموزي", "B"),
    ToolBox(10, "جعبه ابزار", "X");

    private final Integer id;
    private final String titleFa;
    private final String code;

    public String getLiteral() {
        return name();
    }
}
