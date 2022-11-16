package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.MessageContactDTO;
import com.nicico.training.iservice.IMessageContactService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/messageContact")
public class MessageContactRestController {
    private final IMessageContactService messageService;


    @Loggable
    @DeleteMapping(value = "/delete/{id}")
    public ResponseEntity<String> deleteMessage(@PathVariable("id") Long id) {
        messageService.delete(id);
        return new ResponseEntity<>("ok", HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/sms-history/{classId}")
    public ResponseEntity<MessageContactDTO.SmsSpecRs> getClassSmsHistory(@PathVariable Long classId) {
        List<MessageContactDTO.InfoForSms> infoList= messageService.getClassSmsHistory(classId);
        final MessageContactDTO.SpecSmsRs specResponse = new MessageContactDTO.SpecSmsRs();
        final MessageContactDTO.SmsSpecRs specRs = new MessageContactDTO.SmsSpecRs();
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
