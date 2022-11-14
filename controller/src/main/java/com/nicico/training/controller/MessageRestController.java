package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.MessageDTO;
import com.nicico.training.iservice.IMessageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

    @Loggable
    @GetMapping(value = "/sms-history/{classId}")
    public ResponseEntity<MessageDTO.SmsSpecRs> getClassSmsHistory(@PathVariable Long classId) {
        List<MessageDTO.InfoForSms> infoList= messageService.getClassSmsHistory(classId);
        final MessageDTO.SpecSmsRs specResponse = new MessageDTO.SpecSmsRs();
        final MessageDTO.SmsSpecRs specRs = new MessageDTO.SmsSpecRs();
        specResponse.setData(infoList)
                .setStartRow(0)
                .setEndRow(infoList.size())
                .setTotalRows(infoList.size());
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/sms-detail/{id}")
    public ResponseEntity<String> getSmsDetail(@PathVariable Long id) {
        String detail= messageService.getSmsDetail(id);
        return new ResponseEntity<>(detail, HttpStatus.OK);
    }
}
