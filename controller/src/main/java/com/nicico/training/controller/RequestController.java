package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.AnswerReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.iservice.IRequestService;
import com.nicico.training.model.enums.RequestStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
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
    public ResponseEntity<RequestResVM> changeStatus(@RequestParam RequestStatus status,@RequestParam String reference) {
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

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ISC<RequestResVM>> requests(HttpServletRequest iscRq) throws IOException {

        List<RequestResVM> all = iRequestService.findAll();
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs<RequestResVM> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) all.size());
        searchRs.setList(all);

        ISC<RequestResVM> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);

    }
    
}
