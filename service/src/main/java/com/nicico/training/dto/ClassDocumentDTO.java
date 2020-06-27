package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.*;

@Getter
@Setter
@Accessors(chain = true)
public class ClassDocumentDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassInfo")
    public static class Info extends ClassDocumentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassCreateRq")
    public static class Create extends ClassDocumentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TclassUpdateRq")
    public static class Update extends ClassDocumentDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TclassSpecRs")
    public static class TclassSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ClassDocumentDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}