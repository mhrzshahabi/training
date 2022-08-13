package com.nicico.training.dto.enums;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.TeacherRank;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ETeacherRankDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ETeacherRankSpecRs")
    public static class ETeacherRankSpecRs {
        private ETeacherRankDTO.SpecRs response = new ETeacherRankDTO.SpecRs();
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private TeacherRank[] data = TeacherRank.values();
        private Integer startRow = 0;
        private Integer endRow = TeacherRank.values().length;
        private Integer totalRows = TeacherRank.values().length;
    }
}
