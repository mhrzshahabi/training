package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.BehavioralGoalDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.service.BehavioralGoalService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/behavioralgoal")
public class BehavioralGoalRestController {

private final BehavioralGoalService behavioralGoalService;
 private final ModelMapper mapper;

 @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<BehavioralGoalDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(behavioralGoalService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<BehavioralGoalDTO.Info>> list() {
        return new ResponseEntity<>(behavioralGoalService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<BehavioralGoalDTO.Info> create(@RequestBody Object req) {
        BehavioralGoalDTO.Create create = mapper.map(req, BehavioralGoalDTO.Create.class);
        return new ResponseEntity<>(behavioralGoalService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<BehavioralGoalDTO.Info> update(@PathVariable Long id, @RequestBody BehavioralGoalDTO.Update request) {
        //ClassStudentDTO.Update update = modelMapper.map(request, ClassStudentDTO.Update.class);
       return new ResponseEntity<>(behavioralGoalService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody BehavioralGoalDTO.Delete request) {
        behavioralGoalService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }


   @GetMapping(value = "iscList")
      public ResponseEntity<TotalResponse<BehavioralGoalDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity(behavioralGoalService.search(nicicoCriteria), HttpStatus.OK);
    }

     @GetMapping(value = "/iscList/{goalId}")
    public ResponseEntity<ISC<BehavioralGoalDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long classId) throws IOException {
       int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<BehavioralGoalDTO.Info> searchRs =behavioralGoalService.search(searchRq, classId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }
}
