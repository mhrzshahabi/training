package dto.exam;

import lombok.Getter;

@Getter
public enum ExamStatus {
    ACTIVE(1,"فعال"),
    EXPIRE(2, "منقضی"),
    CANCELED(3,"کنسل"),
    UPCOMMING(4, "آتی");

    private int key;
    private String value;
    ExamStatus(int key, String value){
        this.key = key;
        this.value = value;
    }
}
