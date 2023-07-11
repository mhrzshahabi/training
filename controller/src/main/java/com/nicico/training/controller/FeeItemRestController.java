package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.FeeItemDTO;
import com.nicico.training.iservice.IFeeItemService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/fee-items")
public class FeeItemRestController {

    private final IFeeItemService feeItemService;

    @Loggable
    @PostMapping
    public ResponseEntity<FeeItemDTO.Info> create(@RequestBody FeeItemDTO.Create create) {
        return new ResponseEntity<>(feeItemService.create(create), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping
    public ResponseEntity<?> update(@RequestBody FeeItemDTO.Create update) {
        try {
            feeItemService.update(update);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        feeItemService.delete(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<FeeItemDTO.Info>> list(HttpServletRequest iscRq,
                                                     @RequestParam(value = "_startRow", required = false) Integer startRow,
                                                     @RequestParam(value = "_endRow", required = false) Integer endRow) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setStartIndex(startRow);
        searchRq.setCount(endRow - startRow);
        SearchDTO.SearchRs<FeeItemDTO.Info> result = feeItemService.search(searchRq);

        ISC.Response<FeeItemDTO.Info> response = new ISC.Response<>();
        response.setStartRow(startRow);
        response.setEndRow(startRow + result.getList().size());
        response.setTotalRows(result.getTotalCount().intValue());
        response.setData(result.getList());
        ISC<FeeItemDTO.Info> infoISC = new ISC<>(response);
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/{class-id}")
    public ResponseEntity<List<FeeItemDTO.Info>> getFeeItemByClassId(@PathVariable("class-id") Long classId) {
        List<FeeItemDTO.Info> feeItemsByClassId = feeItemService.getAllByClassId(classId);
        return new ResponseEntity<>(feeItemsByClassId, HttpStatus.OK);
    }

}
