package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.GroupOfPersonnelDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.iservice.IGroupOfPersonnelService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.service.BaseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Set;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/group-of-personnel")
public class GroupOfPersonnelRestController {
    private final IGroupOfPersonnelService groupOfPersonnelService;
    private final IPersonnelService personnelService;

//
    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<GroupOfPersonnelDTO.Info>> list(HttpServletRequest iscRq, @RequestParam(value = "id", required = false) Long id) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq, id, "id", EOperator.equals);
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        SearchDTO.SearchRs<GroupOfPersonnelDTO.Info> searchRs = groupOfPersonnelService.searchWithoutPermission(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }

    //
    @GetMapping(value = "/{id}/get-group-personnel")
    public ResponseEntity<ISC<PersonnelDTO.Info>> personnelList(HttpServletRequest iscRq, @PathVariable(value = "id") Long id) throws IOException {
        List<Long> personnel = groupOfPersonnelService.getPersonnel(id);
        if (personnel == null || personnel.isEmpty()) {
            return new ResponseEntity(new ISC.Response().setTotalRows(0), HttpStatus.OK);
        }
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq, personnel, "id", EOperator.inSet);
        SearchDTO.SearchRs<PersonnelDTO.Info> searchRs = personnelService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, searchRq.getStartIndex()), HttpStatus.OK);
    }
//

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_job_group')")
    public ResponseEntity<BaseResponse> create(@Validated @RequestBody GroupOfPersonnelDTO.Create request) {
        BaseResponse response = groupOfPersonnelService.create(request);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_job_group')")
    public ResponseEntity<BaseResponse> update(@PathVariable Long id, @Validated @RequestBody GroupOfPersonnelDTO.Update request) {
        BaseResponse response = groupOfPersonnelService.update(id, request);
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    //
    @Loggable
    @DeleteMapping(value = "/{id}/{type}")
//    @PreAuthorize("hasAuthority('d_job_group')")
    public ResponseEntity delete(@PathVariable Long id,@PathVariable String type) {
        try {
            boolean haveError = false;

            if (!groupOfPersonnelService.delete(id,type))
                haveError = true;

            if (haveError) {
                return new ResponseEntity<>("", HttpStatus.NOT_ACCEPTABLE);
            } else {
                return new ResponseEntity<>(HttpStatus.OK);
            }
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }
//

//
    @Loggable
    @PostMapping(value = "/addPersonnel/{GroupId}/{ids}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> addPersonnel(@PathVariable Long GroupId, @PathVariable Set<Long> ids) {
        groupOfPersonnelService.addPersonnel(GroupId, ids);
        return new ResponseEntity(HttpStatus.OK);
    }
    @Loggable
    @DeleteMapping(value = "/removePersonnel/{GroupId}/{ids}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Void> removePersonnel(@PathVariable Long GroupId, @PathVariable Set<Long> ids) {
        groupOfPersonnelService.removePersonnel(GroupId, ids);
        return new ResponseEntity(HttpStatus.OK);
    }

}
