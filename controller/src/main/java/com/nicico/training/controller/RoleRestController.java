package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IRoleService;
import com.nicico.training.model.Role;
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
@RequestMapping(value = "/api/role")
public class RoleRestController {

    private final IRoleService iRoleService;

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<Role>> list(HttpServletRequest iscRq) throws IOException {

        SearchDTO.SearchRs<Role> searchRs = new SearchDTO.SearchRs<>();
        List<Role> roleList = iRoleService.findAll();
        searchRs.setList(roleList);
        searchRs.setTotalCount((long) roleList.size());
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
    }

    @PostMapping("/addRole")
    public ResponseEntity<Boolean> addRole(@RequestParam String name, @RequestParam String description) {
        return ResponseEntity.ok(iRoleService.addRole(name, description));
    }

    @GetMapping("/getAllRole")
    public ResponseEntity<List<Role>> getAllRole() {
        return ResponseEntity.ok(iRoleService.findAll());
    }

}
