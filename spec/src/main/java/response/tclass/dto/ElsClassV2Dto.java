package response.tclass.dto;

import dto.exam.ClassType;
import dto.exam.CourseStatus;
import dto.exam.CourseType;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsClassV2Dto implements Serializable {
    private String title;
    private String code;
    private Long categoryId;
    private Long classId;
    private Long subCategoryId;
    private String categoryName;
    private String subCategoryName;
}
