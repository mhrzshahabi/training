package response.tclass.dto;

import lombok.Getter;

@Getter
public enum WeekDays {
    SATURDAY(1,"شنبه"),
    SUNDAY(2, "یکشنبه"),
    MONDAY(3, "دوشنبه"),
    TUESDAY(4, "سه شنبه"),
    WEDNESDAY(5, "چهارشنبه"),
    THURSDAY(6, "پنج شنبه"),
    FRIDAY(7, "جمعه");

    private int key;
    private String value;
    WeekDays(int key, String value){
        this.key = key;
        this.value = value;
    }
}
