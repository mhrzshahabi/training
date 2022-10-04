package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;

@Getter
@Setter
@Accessors(chain = true)
public class RequestItemProcessDetailDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String expertNationalCode;
    private String roleName;
    private Long requestItemId;
    private Long expertsOpinionId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("RequestItemProcessDetailInfo")
    public static class Info extends RequestItemProcessDetailDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("RequestItemProcessDetailCreate")
    public static class Create extends RequestItemProcessDetailDTO {
    }
}
