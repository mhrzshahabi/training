package response.masterData;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JobExpResponse {
    private String personnelNo;
    private String ssn;
    private Boolean active;
    private String assignmentDate;
    private String dismissalDate;
    private String postTitle;
    private String postCode;
    private String jobNo;
    private String jobTitle;
    private String departmentTitle;
    private String departmentCode;
    private String omur;
    private String ghesmat;
    private String companyName;

    @Getter
    @Setter
    public static class postInfo extends JobExpResponse {
        private String firstName;
        private String lastName;
        private String nationalCode;
    }
}
