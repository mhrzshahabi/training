package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IRequestItemAuditService;
import com.nicico.training.iservice.IRequestItemService;
import com.nicico.training.model.RequestItemAudit;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/request-item-audit")
public class RequestItemAuditRestController {

    private final IRequestItemService iRequestItemService;
    private final IRequestItemAuditService iRequestItemAuditService;

    @Loggable
    @GetMapping(value = "/change-list/{id}")
    public ResponseEntity<ISC<RequestItemAudit>> changeList(@PathVariable Long id) throws IOException {

        List<Long> requestItemIds = iRequestItemService.getAllRequestItemIdsWithCompetenceId(id);
        List<RequestItemAudit> requestItemAuditList = iRequestItemAuditService.getChangeList(requestItemIds);

        SearchDTO.SearchRs<RequestItemAudit> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setList(requestItemAuditList);
        searchRs.setTotalCount((long) requestItemAuditList.size());

        ISC<RequestItemAudit> infoISC = ISC.convertToIscRs(searchRs, 0);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

}
