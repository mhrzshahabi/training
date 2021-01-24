package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.CheckListDTO;
import com.nicico.training.dto.CheckListItemDTO;
import com.nicico.training.service.CheckListService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/checklist")
public class CheckListRestController {
    private final CheckListService checkListService;
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<CheckListDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(checkListService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<CheckListDTO.Info>> list() {
        return new ResponseEntity<>(checkListService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<CheckListDTO.Info> create(@RequestBody CheckListDTO.Create req) {
        CheckListDTO.Create create = (new ModelMapper()).map(req, CheckListDTO.Create.class);
        return new ResponseEntity<>(checkListService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<CheckListDTO.Info> update(@PathVariable Long id, @RequestBody CheckListDTO.Update request) {
        CheckListDTO.Update update = (new ModelMapper()).map(request, CheckListDTO.Update.class);
        return new ResponseEntity<>(checkListService.update(id, update), HttpStatus.OK);
    }

//    @Loggable
//    @DeleteMapping("/{id}")
//    public ResponseEntity<Void> delete(@PathVariable Long id) {
//        checkListService.delete(id);
//        return new ResponseEntity<>(HttpStatus.OK);
//    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity<Void> delete(@Validated @RequestBody CheckListDTO.Delete request) {
        checkListService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<CheckListDTO.CheckListSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                             @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                             @RequestParam(value = "_constructor", required = false) String constructor,
                                                             @RequestParam(value = "operator", required = false) String operator,
                                                             @RequestParam(value = "criteria", required = false) String criteria,
                                                             @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<CheckListDTO.Info> response = checkListService.search(request);

        final CheckListDTO.SpecRs specResponse = new CheckListDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CheckListDTO.CheckListSpecRs specRs = new CheckListDTO.CheckListSpecRs();
        specRs.setResponse(specResponse);
        if (specRs.getResponse()!=null && specRs.getResponse().getData()!=null)
        {

            specRs.getResponse().getData().stream()
                    .filter(checkListDTO -> checkListDTO.getTitleFa().equals("سوالات مربوط به ارزيابي استاد"))
                    .findFirst()
                    .map(p -> {
                        specRs.getResponse().getData().remove(p);
                        return p;
                    });

        }
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = "/search")
    public ResponseEntity<SearchDTO.SearchRs<CheckListDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(checkListService.search(request), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{CheckListId}/getCheckListItem")
    public ResponseEntity<CheckListItemDTO.CheckListItemSpecRs> getCheckListItem(@PathVariable Long CheckListId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<CheckListItemDTO.Info> list = checkListService.getCheckListItem(CheckListId);

        final CheckListItemDTO.SpecRs specResponse = new CheckListItemDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        final CheckListItemDTO.CheckListItemSpecRs specRs = new CheckListItemDTO.CheckListItemSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("delete/{id}")
    public ResponseEntity<Boolean> delete1(@PathVariable Long id) {
        boolean check = checkListService.checkForDelete(id);
        if (check) {
            checkListService.delete(id);
        }
        return new ResponseEntity<>(check, HttpStatus.OK);
    }


//    @Loggable
//    @GetMapping(value = "/getchecklist/{classId}")
//      public ResponseEntity<List<CheckListDTO.Info>> getCheckList(@PathVariable Long classId) {
//            return new ResponseEntity<>(checkListService.getCheckList(classId),HttpStatus.OK);
//         }

    @Loggable
    @GetMapping(value = "/getchecklist/{classId}")
    public ResponseEntity<CheckListDTO.CheckListSpecRs> getCheckList(@PathVariable Long classId) {

        List<CheckListDTO.Info> list = checkListService.getCheckList(classId);

        final CheckListDTO.SpecRs specResponse = new CheckListDTO.SpecRs();
        specResponse.setData(list)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());
        final CheckListDTO.CheckListSpecRs specRs = new CheckListDTO.CheckListSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


}
