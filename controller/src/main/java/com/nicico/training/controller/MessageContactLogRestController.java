package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.iservice.IMessageContactLogService;
import com.nicico.training.iservice.IMessageContactService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/messageContactLog")
public class MessageContactLogRestController {
    private final IMessageContactLogService messageService;


    @Loggable
    @DeleteMapping(value = "/delete/{id}")
    public ResponseEntity<String> deleteMessage(@PathVariable("id") Long id) {
        messageService.delete(id);
        return new ResponseEntity<>("ok", HttpStatus.OK);
    }
}
