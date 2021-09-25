package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.*;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ClassCourseSumByFeaturesAndDepartmentReportDTO implements Serializable {

    public enum GroupBy {
        CLASS_STATUS,
        CLASS_TEACHING_TYPE,
        COURSE_TECHNICAL_TYPE,
        COURSE_RUN_TYPE,
        COURSE_THEO_TYPE,
        COURSE_LEVEL_TYPE,
        EMPTY
    }

    public enum ReportFor {
        COMPLEX,
        ASSISTANT,
        AFFAIR
    }

    private Double presenceManHour;

    private String presenceManHourStr;

    private Double absenceManHour;

    private String absenceManHourStr;

    private Double unknownManHour;

    private String unknownManHourStr;

    private Integer personnelCount;

    private Integer studentCount;

    private String studentCountStr;

    private Double participationPercent;

    private String participationPercentStr;

    private Double presencePerPerson;

    private String presencePerPersonStr;

    private String mojtameCode;

    private String mojtameTitle;

    private String moavenatCode;

    private String moavenatTitle;

    private String omorCode;

    private String omorTitle;

    private String ghesmatCode;

    private String ghesmatTitle;

    private Long depId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassFeatures")
    public static class ClassFeatures extends ClassCourseSumByFeaturesAndDepartmentReportDTO {

        private String classTeachingType;
        private String classStatus;
        private String courseTechnicalType;
        private String courseRunType;
        private String courseTheoType;
        private String courseLevelType;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassFeatures")
    public static class ClassSumByStatus extends ClassCourseSumByFeaturesAndDepartmentReportDTO {

        private Integer planningCount;
        private Integer inProgressCount;
        private Integer finishedCount;
        private Integer canceledCount;
        private Integer lockedCount;
        private Double providedTaughtPercent;
        private String providedTaughtPercentStr;
        private Long categoryId;
        private String category;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassCourseSumByFeaturesAndDepartmentReportDTOSpecRs")
    public static class ClassCourseSumByFeaturesAndDepartmentReportDTOSpecRs {
        private ClassCourseSumByFeaturesAndDepartmentReportDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private Map<GroupBy, List<ClassFeatures>> allData;
        private List<ClassCourseSumByFeaturesAndDepartmentReportDTO> data;
        private List<ClassSumByStatus> dataSumByStatus;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("AttendanceReportDTOSpecRs")
    public static class ReportResponse {
        SpecRs response;
    }
}
