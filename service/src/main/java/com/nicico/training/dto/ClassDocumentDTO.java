package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import java.util.*;

@Getter
@Setter
@Accessors(chain = true)
public class ClassDocumentDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassDocumentInfo")
    public static class Info{
        private Long id;
        private Long classId;
        private String letterNum;
        private ParameterValueDTO.TupleInfo letterType;
        private Long letterTypeId;
        private ParameterValueDTO.TupleInfo reference;
        private Long referenceId;
        private String description;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassDocumentCreate")
    public static class Create {
        private Long classId;
        private String letterNum;
        private ParameterValueDTO.TupleInfo letterType;
        private Long letterTypeId;
        private ParameterValueDTO.TupleInfo reference;
        private Long referenceId;
        private String description;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ClassDocumentUpdate")
    public static class Update{
        private Long classId;
        private String letterNum;
        private ParameterValueDTO.TupleInfo letterType;
        private Long letterTypeId;
        private ParameterValueDTO.TupleInfo reference;
        private Long referenceId;
        private String description;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ClassDocumentsSpecRs")
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