package dto.bpms;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@Setter
@Getter
public class BPMSReqItemCoursesDetailDto implements Serializable {
    private String courseCode;
    private String courseTitle;
    private String categoryTitle;
    private String subCategoryTitle;
    private String priority;
    private Long requestItemProcessDetailId;
}
