package request.needsassessment;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

@Getter
@Setter
public class NeedAssessmentGroupJobPromotionResponseDto implements Serializable {

    private static final long serialVersionUID = 7799088209220298802L;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("GroupJobPromotionInfo")
    public static class Info extends NeedAssessmentGroupJobPromotionResponseDto {
        private Long id;
        private String createdBy;
        private String createDate;
        private String excelReference;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("GroupJobPromotionSpecRs")
    public static class GroupJobPromotionSpecRs {
        private SpecRs response;
    }

}
