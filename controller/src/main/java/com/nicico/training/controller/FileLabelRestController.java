package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.FileLabelDTO;
import com.nicico.training.iservice.IFileLabelService;
import com.nicico.training.model.FileLabel;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/file-label")
public class FileLabelRestController {

    private final ModelMapper modelMapper;
    private final IFileLabelService iFileLabelService;

    @Loggable
    @PostMapping
    public ResponseEntity create(@Validated @RequestBody FileLabelDTO.Create create) {
        try {
            return new ResponseEntity<>(iFileLabelService.create(create), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            iFileLabelService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ISC<FileLabelDTO.Info>> fileLabelList(HttpServletRequest iscRq) throws IOException {

        List<FileLabel> all = iFileLabelService.findAll();
        List<FileLabelDTO.Info> fileLabelDTOs = modelMapper.map(all, new TypeToken<List<FileLabelDTO.Info>>() {
        }.getType());
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs<FileLabelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) fileLabelDTOs.size());
        searchRs.setList(fileLabelDTOs);

        ISC<FileLabelDTO.Info> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
