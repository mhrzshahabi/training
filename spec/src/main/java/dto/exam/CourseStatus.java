package dto.exam;

import lombok.Getter;

@Getter
public enum CourseStatus {
    ACTIVE(1,"درحال برگزاری"),
    COMPLETED(2, "برگزار شده"),
    CANCELED(3,"کنسل"),
    UPCOMING(4, "آتی");
    // درخواست حق الزحمه برای این دوره  /// ////////////////////////////////

    private int key;
    private String value;
    CourseStatus(int key, String value){
        this.key = key;
        this.value = value;
    }
}
