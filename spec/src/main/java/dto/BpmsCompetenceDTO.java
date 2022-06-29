package dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BpmsCompetenceDTO {
    private String title;
    private String type;
    private String code;
    private Long competenceLevelId;
    private Long competencePriorityId;
    private String complex;
    private String description;
    private Long categoryId;
    private Long id;
    private Long subCategoryId;
    private Long competenceTypeId;
    private Long workFlowStatusCode;
}
