package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.GenericPermissionDTO;
import com.nicico.training.dto.PermissionDTO;
import com.nicico.training.dto.WorkGroupDTO;
import com.nicico.training.iservice.IWorkGroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/work-group")
public class WorkGroupRestController {

    private final IWorkGroupService workGroupService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<WorkGroupDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setDistinct(true);
        SearchDTO.SearchRs<WorkGroupDTO.Info> searchRs = workGroupService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody WorkGroupDTO.Create request) {
        try {
            return new ResponseEntity<>(workGroupService.create(request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody WorkGroupDTO.Update request) {
        try {
            return new ResponseEntity<>(workGroupService.update(id, request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping("/{request}")
    public ResponseEntity deleteAll(@PathVariable List<Long> request) {
        try {
            workGroupService.deleteAll(request);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

    @Loggable
    @PostMapping("/form-data")
    public ResponseEntity<List<PermissionDTO.PermissionFormData>> formData(@RequestBody List<String> entityList) {
        return new ResponseEntity<>(workGroupService.getEntityAttributesList(entityList), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/edit-permission-list/{workGroupId}")
    public ResponseEntity<List<PermissionDTO.Info>> editConfigList(@Validated @RequestBody PermissionDTO.CreateOrUpdate[] rq, @PathVariable Long workGroupId) {
        return new ResponseEntity<>(workGroupService.editPermissionList(rq, workGroupId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/generic-form-data/{workGroupId}")
    public ResponseEntity<List<GenericPermissionDTO.Info>> genericformData(@PathVariable Long workGroupId) {
        return new ResponseEntity<>(workGroupService.getAllGenericPermissions(workGroupId), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/edit-generic-permission-list/{workGroupId}")
    public ResponseEntity<List<GenericPermissionDTO.Info>> editGenericPermissionList(@Validated @RequestBody GenericPermissionDTO.Update rq, @PathVariable Long workGroupId) {
        return new ResponseEntity<>(workGroupService.editGenericPermissionList(rq, workGroupId), HttpStatus.OK);
    }

}
