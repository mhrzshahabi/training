package dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@RequiredArgsConstructor
@Getter
@ToString(of = {"id"})
@JsonFormat(shape = JsonFormat.Shape.OBJECT)
public enum TechnicalType {

    General(1, "عمومي"),
    Technical(2, "فني"),
    Managerial(3, "مديريتي");

    private final Integer id;
    private final String titleFa;

    public String getLiteral() {
        return name();
    }
}
