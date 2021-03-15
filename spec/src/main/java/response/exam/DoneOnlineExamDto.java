package response.exam;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.experimental.Accessors;

import java.util.Map;

@Getter
@Setter
@ToString
@Accessors(chain = true)
public class DoneOnlineExamDto {
    private String examTitle;
    private Map<String, UserDetailDto> users;
    private String instructor;
    private String startDate;
    private String examStartDate;
    private String createDate;
    private String course;
    private Integer answeredCount;
    private Integer unAnsweredCount;

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class UserDetailDto {
        private String fullName;
        private String nationalCode;
        private Boolean answered;
        private String phoneNumber;

    }

}
