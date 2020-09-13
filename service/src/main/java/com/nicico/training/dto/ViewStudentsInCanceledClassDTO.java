/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/13
 * Last Modified: 2020/09/13
 */


package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@AllArgsConstructor
@NoArgsConstructor
public class ViewStudentsInCanceledClassDTO {
    private String sessionDate;
    private String lastName;
    private String firstName;
    private String titleClass;
    private String startDate;
    private String endDate;
    private String code;
    private String endHour;
    private String startHour;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewsStudentsInCanceledClassDTOInfo")
    public static class Info extends ViewStudentsInCanceledClassDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("ViewsStudentsInCanceledClassDTOSpecRs")
    public static class ViewStudentsInCanceledClassDTOSpecRs {
        private ViewStudentsInCanceledClassDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<ViewStudentsInCanceledClassDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
