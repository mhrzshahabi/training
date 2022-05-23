package dto.exam;

import lombok.Getter;

@Getter
public enum EQuestionType {

    DESCRIPTIVE(1, "تشریحی"),
    MULTI_CHOICES(2, "چند گزینه ای"),
    QUALITATIVE(3, "طیفی"),
    READING(4, "ردینگ");

    private int key;
    private String value;

    EQuestionType(int key, String value) {
        this.key = key;
        this.value = value;
    }
}
