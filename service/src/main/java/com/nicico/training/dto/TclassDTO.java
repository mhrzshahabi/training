package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.Student;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TrainingPlace;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class TclassDTO {

//    @ApiModelProperty(required = true)
//    private Long courseId;

    private Long minCapacity;
    private Long maxCapacity;
    @ApiModelProperty(required = true)
    private String code;

    private String titleClass;
    private String teachingType;//روش آموزش
    private Long hDuration;
    private Long dDuration;
    private Long supervisor;
    private String reason;
    private String classStatus;
    @ApiModelProperty(required = true)
    private Long group;
    @ApiModelProperty(required = true)
    private Long termId;
    private String teachingBrand;//نحوه آموزش
    @ApiModelProperty(required = true)
    private String startDate;
    @ApiModelProperty(required = true)
    private String endDate;
    private Boolean saturday;
    private Boolean sunday;
    private Boolean monday;
    private Boolean tuesday;
    private Boolean wednesday;
    private Boolean thursday;
    private Boolean friday;
    private String topology;//چیدمان



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassInfo")
    public static class Info extends TclassDTO {
        private Long id;
        private CourseDTO.CourseInfoTuple course;
        private TermDTO term;
        private List<Student> studentSet;
        private List<TeacherDTO.TeacherInfoTuple> teacherSet;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassCreateRq")
    public static class Create extends TclassDTO {
        private Long courseId;
        private List<Long> teacherSet;
//        private List<Long> studentSet;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassUpdateRq")
    public static class Update extends TclassDTO {
        private Long courseId;
        private List<Long> teacherSet;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class TclassSpecRs {
        private SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<TclassDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
