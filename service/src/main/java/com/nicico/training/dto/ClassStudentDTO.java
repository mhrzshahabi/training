package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)

public class ClassStudentDTO implements Serializable {

    private String scoresState;

    private String failureReason;

    private Float score;

    private String applicantCompanyName;

    private Long presenceTypeId;

    @ApiModelProperty(required = true)
    private Long studentId;

    @ApiModelProperty(required = true)
    private Long tclassId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Info")
    public static class ClassStudentInfo extends ClassStudentDTO {
        private Long id;
        private StudentDTO.ClassStudentInfo student;
        private String applicantCompanyName;
        private Long presenceTypeId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Create")
    public static class Create {
        @ApiModelProperty(required = true)
        private String personnelNo;
        private Integer registerTypeId;
        private String applicantCompanyName;
        private Long presenceTypeId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Update")
    public static class Update {
        private String applicantCompanyName;
        private Long presenceTypeId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassStudent - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

}
