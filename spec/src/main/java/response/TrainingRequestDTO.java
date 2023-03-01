package response;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Setter
@Getter
public class TrainingRequestDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestDTO - Info")
    public static class Info {

        private Long id;
        private String trainingRequestTypeTitle;
        private String requesterNationalCode;
        private String assignTo;
        private String requesterSupervisorNationalCode;
        private String requesterSupervisorFullName;
        private String requesterSupervisorComment;
        private String runSupervisorComment;
        private String runExpertNationalCode;
        private String runExpertComment;
        private String objectType;
        private String objectCode;
        private String trainingRequestStateTitle;
        private String description;
        private String createdDate;
        private String objectName;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestDTO - Create")
    public static class Create {

        private Long trainingRequestTypeId;
        private String requesterNationalCode;
        private String objectCode;
        private String description;
        private List<AttachmentDTO> attachFiles;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestDTO - ReviewByRequesterSupervisor")
    public static class ReviewByRequesterSupervisor {

        private Long id;
        private String requesterSupervisorComment;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestDTO - RefuseByRequesterSupervisor")
    public static class RefuseByRequesterSupervisor {

        private Long id;
        private String requesterSupervisorComment;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestDTO - ResendByRequester")
    public static class ResendByRequester {

        private Long id;
        private String description;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestDTO - ReviewByRunSupervisor")
    public static class ReviewByRunSupervisor {

        private Long id;
        private String runSupervisorComment;
        private String runExpertNationalCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TrainingRequestDTO - ReviewByRunExpert")
    public static class ReviewByRunExpert {

        private Long id;
        private String runExpertComment;
    }



    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TrainingRequestDTOSpecRs")
    public static class TrainingRequestSpecRs {
        private SpecRs response;
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


}
