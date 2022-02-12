package com.nicico.training.controller;

import com.nicico.training.dto.ViewTrainingFileDTO;
import com.nicico.training.iservice.IViewTrainingFileService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/view-training_file")
public class ViewTrainingFileRestController {

    private final IViewTrainingFileService viewTrainingFileService;

    @GetMapping(value = "/{nationalCode}")
    public ResponseEntity<ViewTrainingFileDTO.ViewTrainingFileSpecRs> iscList(@PathVariable String nationalCode) {
        return new ResponseEntity(new ViewTrainingFileDTO
                .ViewTrainingFileSpecRs()
                .setResponse(viewTrainingFileService
                        .getByNationalCode(nationalCode)),
                HttpStatus.OK);
    }

}
