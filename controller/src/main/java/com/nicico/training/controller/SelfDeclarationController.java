package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.iservice.ISelfDeclarationService;
import com.nicico.training.model.SelfDeclaration;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
}
