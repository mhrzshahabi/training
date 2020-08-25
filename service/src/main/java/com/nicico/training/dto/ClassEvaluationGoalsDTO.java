package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;


@Getter
@Setter
@Accessors(chain = true)
public class ClassEvaluationGoalsDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Info")
    public static class Info{
        private Long id;
        private Long classId;
        private Long skillId;
        private Long goalId;
        private String question;
        private String goalQuestion;
    }

}
