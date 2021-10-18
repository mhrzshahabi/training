package com.nicico.training.controller;

import com.nicico.training.dto.AnswerReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.iservice.IRequestService;
import com.nicico.training.model.enums.RequestStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/request")
public class RequestController {
    private final IRequestService iRequestService;

    @GetMapping("/all")
    public ResponseEntity<List<RequestResVM>> findAll() {
        List<RequestResVM> all = iRequestService.findAll();
        return ResponseEntity.ok(all);
    }

    @PutMapping("/change-status")
    public ResponseEntity<RequestResVM> findAll(@RequestParam RequestStatus status,@RequestParam String reference) {
        RequestResVM requestResVM = iRequestService.changeStatus(reference, status);
        return ResponseEntity.ok(requestResVM);
    }

    @DeleteMapping
    public ResponseEntity<Boolean> remove(@RequestParam String reference) {
        boolean aBoolean = iRequestService.remove(reference);
        return ResponseEntity.ok(aBoolean);
    }

    @PostMapping("/answer")
    public ResponseEntity<RequestResVM> answer(@RequestBody AnswerReqVM answerReqVM) {
        RequestResVM requestResVM = iRequestService.answerRequest(answerReqVM.getReference(), answerReqVM.getResponse(), answerReqVM.getRequestStatus());
        return ResponseEntity.ok(requestResVM);
    }


}
