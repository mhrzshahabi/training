package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.TargetSocietyDTO;
import com.nicico.training.iservice.ITargetSocietyService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.service.TargetSocietyService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Iterator;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/target-society")
public class TargetSocietyRestController {

    private final ITclassService tclassService;
    private final ITargetSocietyService societyService;

    @Loggable
    @GetMapping("/getListById/{id}")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getListById(@PathVariable Long id) {
        Long targetType = tclassService.getTargetSocietyTypeById(id).getId();
        Iterator<TargetSocietyDTO.Info> infoIterator = tclassService.getTargetSocietiesListById(id).iterator();
        return new ResponseEntity<>(societyService.getTargetSocietiesById(infoIterator, targetType), HttpStatus.OK);
    }
}
