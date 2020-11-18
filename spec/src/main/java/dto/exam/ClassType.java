package dto.exam;

import lombok.Getter;

@Getter
public enum ClassType {
    ATTENDANCE(1,"حضوری"),
    VIRTUAL(2, "مجازی");

    private int key;
    private String value;
    ClassType(int key, String value){
        this.key = key;
        this.value = value;
    }
}
