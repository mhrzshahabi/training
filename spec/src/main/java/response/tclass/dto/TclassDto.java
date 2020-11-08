package response.tclass.dto;

import dto.TermDto;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import response.teacher.dto.TeacherInCourseDto;

@Getter
@Setter
public class TclassDto {
    private long id;
    private String code;
    private String titleClass;
    private TermDto term;

    @Getter(AccessLevel.NONE)
    private TeacherInCourseDto teacher;

    public String getTeacher() {
        if (teacher != null)
            return teacher.getPersonality().getFirstNameFa() + " " + teacher.getPersonality().getLastNameFa();
        else
            return " ";
    }
}
