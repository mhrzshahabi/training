package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PermissionDTO;
import com.nicico.training.dto.WorkGroupDTO;
import com.nicico.training.service.WorkGroupService;
import lombok.RequiredArgsConstructor;
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

    private final WorkGroupService workGroupService;

    @Loggable
    @PostMapping("/form-data")
    public ResponseEntity<List<PermissionDTO.PermissionFormData>> formData(@RequestBody List<String> entityList) {
        return new ResponseEntity<>(workGroupService.getEntityAttributesList(entityList), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/edit-permission-list")
    public ResponseEntity<List<PermissionDTO.PermissionFormData>> editConfigList(@Validated @RequestBody PermissionDTO.PermissionUpdate[] rq) {
//        return new ResponseEntity<>(parameterValueService.editConfigList(rq), HttpStatus.OK);
        return null;
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<WorkGroupDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<WorkGroupDTO.Info> searchRs = workGroupService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

}
