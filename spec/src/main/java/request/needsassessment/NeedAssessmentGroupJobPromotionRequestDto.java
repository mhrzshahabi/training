package request.needsassessment;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class NeedAssessmentGroupJobPromotionRequestDto implements Serializable {
    private static final long serialVersionUID = 2736628968763636669L;
    private List<NeedAssessmentGroupJobPromotionDto> needAssessmentGroupJobPromotionDtos;
}
