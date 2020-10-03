package response.teacher.dto;

import dto.PersonalInfoDto;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TeacherInCourseDto {
    private Long id;
    private PersonalInfoDto personality;
}
