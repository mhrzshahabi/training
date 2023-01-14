package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.iservice.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/request-item-courses-detail")
public class RequestItemCoursesDetailRestController {

    private final IRequestItemCoursesDetailService requestItemCoursesDetailService;

    @Loggable
    @PutMapping(value = "/update-after-run-supervisor-review")
    public BaseResponse updateCoursesDetailAfterRunSupervisorReview(@RequestParam String processInstanceId, @RequestParam String taskId, @RequestParam String courseCode) {
        return requestItemCoursesDetailService.updateCoursesDetailAfterRunSupervisorReview(processInstanceId, taskId, courseCode);
    }
}
