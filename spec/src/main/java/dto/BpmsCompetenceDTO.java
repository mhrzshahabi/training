package dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BpmsCompetenceDTO {
    private String title;
    private String code;
    private String description;
    private Long categoryId;
    private Long id;
    private Long subCategoryId;
    private Long competenceTypeId;
    private Long workFlowStatusCode;
}
