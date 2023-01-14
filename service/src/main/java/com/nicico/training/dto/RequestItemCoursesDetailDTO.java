package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;


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
    private boolean isPassed = false;

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
    @ApiModel("RequestItemOpinionInfo")
    public static class OpinionInfo {
        private List<Info> courses;
        private String finalOpinion;
        private Long finalOpinionId;
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompleteTaskDto")
    public static class CompleteTaskDto {
        private Long id;
        private String taskId;
        private String processInstanceId;

        public CompleteTaskDto(Long id, String taskId, String processInstanceId) {
            this.id = id;
            this.taskId = taskId;
            this.processInstanceId = processInstanceId;
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("RequestItemCourseCategoryInfo")
    public static class CourseCategoryInfo {
        private Long id;
        private String courseCode;
        private String courseTitle;
        private Long categoryId;
        private String categoryTitle;
        private Long subCategoryId;
        private String subCategoryTitle;
        private String priority;
        private Long requestItemProcessDetailId;
        private List<String> supervisorAssigneeList;
        private List<String> expertsAssigneeList;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("RequestItemCoursesDetailCreate")
    public static class Create extends RequestItemCoursesDetailDTO {
    }
}
