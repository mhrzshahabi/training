package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;


@Getter
@Setter
@Accessors(chain = true)
public class RequestItemCoursesDetailDTO {

    private String courseCode;
    private String courseTitle;
    private String categoryTitle;
    private String subCategoryTitle;
    private String priority;
    private Long requestItemProcessDetailId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("RequestItemCoursesDetailInfo")
    public static class Info extends RequestItemCoursesDetailDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("RequestItemCoursesDetailCreate")
    public static class Create extends RequestItemCoursesDetailDTO {
    }
}
