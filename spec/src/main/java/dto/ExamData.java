package dto;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter
@Setter
@ToString
public class ExamData {
    private Long tclassId;
    private Long duration;
    private String time;
    private String date;
    private Long id;
    private ExamClassData tclass;
 }
