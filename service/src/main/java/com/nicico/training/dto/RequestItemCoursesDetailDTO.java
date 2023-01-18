package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;
import java.util.Set;


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
        private String taskIdPerCourse;
        private String processInstanceId;
        private String courseCode;
        private String userNationalCode;
        private Set<Long> classIds;


        public CompleteTaskDto(Long id, String taskId, String processInstanceId,String courseCode,String userNationalCode) {
            this.id = id;
            this.taskIdPerCourse = taskId;
            this.processInstanceId = processInstanceId;
            this.courseCode = courseCode;
            this.userNationalCode = userNationalCode;
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
