package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.UserDetailDTO;
import com.nicico.training.iservice.ISelfDeclarationService;
import com.nicico.training.model.SelfDeclaration;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/self-declaration")
public class SelfDeclarationController {
    private final ISelfDeclarationService iSelfDeclarationService;

    @Loggable
    @GetMapping("/findAll")
    public ResponseEntity<List<SelfDeclaration>> findAll() {
        List<SelfDeclaration> all = iSelfDeclarationService.findAll();
        return ResponseEntity.ok(all);
    }

    @GetMapping("/detail/")
    public ResponseEntity<UserDetailDTO> mobileVerifyUserDetail(@RequestParam String nationalCode) {
        return ResponseEntity.ok(iSelfDeclarationService.findDetailByNationalCode(nationalCode));
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ISC<SelfDeclaration>> selfDeclarationList(HttpServletRequest iscRq) throws IOException {

        List<SelfDeclaration> all = iSelfDeclarationService.findAll();
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs<SelfDeclaration> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) all.size());
        searchRs.setList(all);

        ISC<SelfDeclaration> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
