package com.nicico.training.dto.teacherSpecialSkill;
import com.nicico.training.dto.ParameterValueDTO;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

@Setter
@Getter
@Accessors(chain = true)
public class TeacherSpecialSkillDTO {
    private Long fieldId;
    private Long typeId;
    private Long levelId;
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherSpecialSkillDTO.Info")
    public static class Info extends TeacherSpecialSkillDTO {
        private Long id;
        private ParameterValueDTO.TupleInfo field;
        private ParameterValueDTO.TupleInfo type;
        private ParameterValueDTO.TupleInfo level;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherSpecialSkillDTO.UpdatedInfo")
    public static class UpdatedInfo extends BaseResponse {
        private Long id;
        private Long fieldId;
        private Long typeId;
        private Long levelId;
        private String description;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherSpecialSkillDTO.Create")
    public static class Create extends TeacherSpecialSkillDTO {
        @ApiModelProperty(required = true)
        private String nationalCode;
        private Long teacherId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherSpecialSkillDTO.Update")
    public static class Update extends TeacherSpecialSkillDTO {
        @ApiModelProperty(required = true)
        private Long id;
    }

}
