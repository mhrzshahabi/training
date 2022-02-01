package dto.exam;

public enum CourseType {

    IMPERETIVE(1, "ضروری"),
    IMPROVEMENT(2, "بهبود"),
    DEVELOPMENTAL(3, "توسعه ای");

    private int key;
    private String value;

    CourseType(int key, String value) {
        this.key = key;
        this.value = value;
    }
}
