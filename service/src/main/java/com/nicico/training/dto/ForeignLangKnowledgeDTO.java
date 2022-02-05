package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.dto.enums.ELangLevelDTO;
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
public class ForeignLangKnowledgeDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String langName;
    private String description;
    private Long teacherId;
    private Integer langLevelId;
    private String instituteName;
    private String duration;
    private String startDate;
    private String endDate;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ForeignLangKnowledge - Info")
    public static class Info extends ForeignLangKnowledgeDTO {
        private Long id;
        private Integer version;
        private ELangLevelDTO.ELangLevelInfoTuple langLevel;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ForeignLangKnowledge - Create")
    public static class Create extends ForeignLangKnowledgeDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ForeignLangKnowledge - Update")
    public static class Update extends ForeignLangKnowledgeDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ForeignLangKnowledge - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ForeignLangKnowledge-SpecRs")
    public static class ForeignLangKnowledgeSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
