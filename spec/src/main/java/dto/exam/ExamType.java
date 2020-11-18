package dto.exam;

import lombok.Getter;

@Getter
public enum ExamType {
    DESCRIPTIVE(1,"تشریحی"),
    MULTI_CHOICES(2,"چند گزینه ای"),
    MIX(3,"تستی-تشریحی");

    private int key;
    private String value;

    ExamType(int key, String value) {
        this.key = key;
        this.value = value;
    }

}
