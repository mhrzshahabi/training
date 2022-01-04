package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.HelpFilesDTO;
import com.nicico.training.iservice.IHelpFilesService;
import com.nicico.training.mapper.helpFiles.HelpFilesBeanMapper;
import com.nicico.training.model.HelpFiles;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Set;


@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/help-files")
public class HelpFilesRestController {

    private final IHelpFilesService iHelpFilesService;
    private final HelpFilesBeanMapper helpFilesBeanMapper;

    @Loggable
    @PostMapping
    public ResponseEntity<HelpFilesDTO.Info> create(@RequestBody HelpFilesDTO.Create create) {
        return new ResponseEntity<>(iHelpFilesService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@RequestBody HelpFilesDTO.Update update, @PathVariable Long id) {
        try {
            iHelpFilesService.update(update, id);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        iHelpFilesService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<ISC<HelpFilesDTO.Info>> HelpFileList(HttpServletRequest iscRq) throws IOException {

        List<HelpFiles> all = iHelpFilesService.findAll();
        List<HelpFilesDTO.Info> helpFilesInfoList = helpFilesBeanMapper.toHelpFilesInfoList(all);
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs<HelpFilesDTO.Info> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) helpFilesInfoList.size());
        searchRs.setList(helpFilesInfoList);

        ISC<HelpFilesDTO.Info> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/filter/{labelIds}")
    public ResponseEntity<ISC<HelpFilesDTO.Info>> HelpFileFilter(HttpServletRequest iscRq, @PathVariable Set<Long> labelIds) throws IOException {

        List<HelpFiles> all = iHelpFilesService.findAllByFileLabelIdsIn(labelIds);
        List<HelpFilesDTO.Info> helpFilesInfoList = helpFilesBeanMapper.toHelpFilesInfoList(all);
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs<HelpFilesDTO.Info> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) helpFilesInfoList.size());
        searchRs.setList(helpFilesInfoList);

        ISC<HelpFilesDTO.Info> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
