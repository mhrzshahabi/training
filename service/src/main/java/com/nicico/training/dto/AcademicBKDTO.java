package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class AcademicBKDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationLevelId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationMajorId;
    private Long educationOrientationId;
    private String date;
    private String duration;
    private String academicGrade;
    private String collageName;
    private Long teacherId;
    private Long universityId;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AcademicBK - Info")
    public static class Info extends AcademicBKDTO {
        private Long id;
        private Integer version;
        private EducationLevelDTO.Info educationLevel;
        private EducationMajorDTO.Info educationMajor;
        private EducationOrientationDTO.Info educationOrientation;
        private ParameterValueDTO.TupleInfo university;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AcademicBK - Create")
    public static class Create extends AcademicBKDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AcademicBK - Update")
    public static class Update extends AcademicBKDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("AcademicBK - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}
