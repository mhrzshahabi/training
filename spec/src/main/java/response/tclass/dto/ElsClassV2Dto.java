package response.tclass.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

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
    private Boolean canEnterPractical;
    private Boolean needToClassification;
}
