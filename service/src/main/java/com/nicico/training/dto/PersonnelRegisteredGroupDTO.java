package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:Lotfy
*/

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)

public class PersonnelRegisteredGroupDTO {


     private String nationalCode;
     private String mobile;


}
