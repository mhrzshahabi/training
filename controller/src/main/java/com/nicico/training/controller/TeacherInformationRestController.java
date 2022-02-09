package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.service.TeacherService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import response.teacher.TeacherInCourseListResponse;
import response.teacher.dto.TeacherInCourseDto;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/teacherInformation")
public class TeacherInformationRestController {
    private final ITeacherService iTeacherService;


    @Loggable
    @GetMapping(value = "/teacher-information-iscList/{courseId}")
    public ResponseEntity getTeachers(@PathVariable("courseId") Long courseId) {
        List<TeacherInCourseDto> teachers = iTeacherService.getTeachersInCourse(courseId);
        final TeacherInCourseListResponse teacherInCourseListResponse = new TeacherInCourseListResponse();
        teacherInCourseListResponse
                .setData(teachers)
                .setStartRow(0)
                .setEndRow(teachers.size())
                .setTotalRows(teachers.size());
        final TeacherInCourseListResponse.Response response = new TeacherInCourseListResponse.Response();
        response.setResponse(teacherInCourseListResponse);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
