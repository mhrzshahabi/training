package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.WorkGroupDTO;
import com.nicico.training.service.WorkGroupService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/work-group")
public class WorkGroupRestController {

    private final WorkGroupService workGroupService;

    @Loggable
    @PostMapping("/form-data")
    public ResponseEntity<List<WorkGroupDTO.PermissionFormData>> formData(@RequestBody List<String> entityList) {
        return new ResponseEntity<>(workGroupService.getEntityAttributesList(entityList), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/edit-permission-list")
    public ResponseEntity<List<WorkGroupDTO.PermissionFormData>> editConfigList(@Validated @RequestBody WorkGroupDTO.PermissionUpdate[] rq) {
//        return new ResponseEntity<>(parameterValueService.editConfigList(rq), HttpStatus.OK);
        return null;
    }

}
