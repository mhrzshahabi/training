/*
ghazanfari_f,
1/14/2020,
2:46 PM
*/
package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.service.CompetenceService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Locale;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/competence")
public class CompetenceRestController {

    private final CompetenceService competenceService;
    private final ModelMapper modelMapper;
    private final MessageSource messageSource;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<CompetenceDTO.Info>> list() {
        return new ResponseEntity<>(competenceService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList")
    public ResponseEntity<TotalResponse<CompetenceDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(competenceService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CompetenceDTO.Info> create(@RequestBody Object rq, HttpServletResponse response) {
        CompetenceDTO.Create create = modelMapper.map(rq, CompetenceDTO.Create.class);
        return new ResponseEntity<>(competenceService.checkAndCreate(create, response), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody Object rq, HttpServletResponse response) {
        final List<NeedsAssessmentDTO.Info> list = competenceService.checkUsed(id);
        if(!list.isEmpty()){
            return new ResponseEntity<>(list, HttpStatus.IM_USED);
        }
        CompetenceDTO.Update update = modelMapper.map(rq, CompetenceDTO.Update.class);
        return new ResponseEntity<>(competenceService.checkAndUpdate(id, update, response), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        final List<NeedsAssessmentDTO.Info> list = competenceService.checkUsed(id);
        if(!list.isEmpty()){
            return new ResponseEntity<>(list, HttpStatus.IM_USED);
        }
        try {
            return new ResponseEntity<>(competenceService.delete(id), HttpStatus.OK);
        } catch (TrainingException ex) {
            Locale locale = LocaleContextHolder.getLocale();
            return new ResponseEntity<>(messageSource.getMessage("exception.unauthorized", null, locale), HttpStatus.UNAUTHORIZED);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }

    @Loggable
    @GetMapping("/{id}")
    public ResponseEntity checkUsed(@PathVariable Long id) {
        final List<NeedsAssessmentDTO.Info> list = competenceService.checkUsed(id);
        if(!list.isEmpty()){
            return new ResponseEntity<>(list, HttpStatus.IM_USED);
        }
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
