package dto.exam;

import lombok.Getter;

@Getter
public enum EQuestionType {

    DESCRIPTIVE(1, "تشریحی"),
    MULTI_CHOICES(2, "چند گزینه ای"),
    QUALITATIVE(3, "طیفی");

    private int key;
    private String value;

    EQuestionType(int key, String value) {
        this.key = key;
        this.value = value;
    }
}
