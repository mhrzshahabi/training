package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.iservice.IMessageService;
import com.nicico.training.iservice.ITeacherService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.teacher.TeacherInCourseListResponse;
import response.teacher.dto.TeacherInCourseDto;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/message")
public class MessageRestController {
    private final IMessageService messageService;


    @Loggable
    @DeleteMapping(value = "/delete/{id}")
    public ResponseEntity<String> deleteMessage(@PathVariable("id") Long id) {
        messageService.delete(id);
        return new ResponseEntity<>("ok", HttpStatus.OK);
    }
}
