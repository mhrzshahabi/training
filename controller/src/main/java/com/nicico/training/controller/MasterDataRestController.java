/**
 * Author:    Mehran Golrokhi
 * Created:    1399.03.24
 * Description:    Use of WebService
 */


package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.service.MasterDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/masterData/")
public class MasterDataRestController {

    private final MasterDataService masterDataService;
    private final ModelMapper modelMapper;


    @GetMapping(value = "personnel/iscList")
    public ResponseEntity<TotalResponse<PersonnelDTO.Info>> getPersonnel(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getPeople(iscRq,resp), HttpStatus.OK);
    }

    @GetMapping(value = "competence/iscList")
    public ResponseEntity<TotalResponse<CompetenceDTO.Info>> getCompetences(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getCompetencies(iscRq,resp), HttpStatus.OK);
    }

    @GetMapping(value = "department/iscList")
    public ResponseEntity<TotalResponse<MasterDataService.CompetenceWebserviceDTO>> getDepartments(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getDepartments(iscRq,resp), HttpStatus.OK);
    }

    @GetMapping(value = "department/touple-iscList")
    public ResponseEntity<TotalResponse<MasterDataService.CompetenceWebserviceDTOInfoTuple>> getToupleDepartments(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {

        TotalResponse<MasterDataService.CompetenceWebserviceDTO> departments = masterDataService.getDepartments(iscRq, resp);
        departments.getResponse().setData(modelMapper.map(departments.getResponse().getData(), new TypeToken<List<MasterDataService.CompetenceWebserviceDTOInfoTuple>>() {}.getType()));
        return new ResponseEntity<>((TotalResponse<MasterDataService.CompetenceWebserviceDTOInfoTuple>) (Object)departments, HttpStatus.OK);
    }

    @GetMapping(value = "department/getDepartmentsByParentId/{parentId}")
    public ResponseEntity<List<MasterDataService.CompetenceWebserviceDTOInfoTuple>> getDepartmentsByParentCode(@PathVariable String parentId) throws IOException {
        List<MasterDataService.CompetenceWebserviceDTOInfoTuple> result = modelMapper.map(masterDataService.getDepartmentsByParentCode("ParentId?parentId=" + parentId),new TypeToken<List<MasterDataService.CompetenceWebserviceDTOInfoTuple>>() {}.getType());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PostMapping(value = "department/getDepartmentsChilderen")
    public ResponseEntity<List<MasterDataService.CompetenceWebserviceDTOInfoTuple>> getDepartmentsChilderen(@RequestBody List<Long> childeren) throws IOException {
        List<MasterDataService.CompetenceWebserviceDTOInfoTuple> result = modelMapper.map(masterDataService.getDepartmentsChilderenByParentCode(childeren),new TypeToken<List<MasterDataService.CompetenceWebserviceDTOInfoTuple>>() {}.getType());
        return new ResponseEntity<>(result, HttpStatus.OK);

    }

    @GetMapping(value = "department/getDepartmentsRoot")
    public ResponseEntity<List<MasterDataService.CompetenceWebserviceDTOInfoTuple>> getDepartmentsRoot() throws IOException {
        return new ResponseEntity<>((List<MasterDataService.CompetenceWebserviceDTOInfoTuple>) (Object) modelMapper.map(masterDataService.getDepartmentsByParentCode("RootByType?peopleType=Personal"),new TypeToken<List<MasterDataService.CompetenceWebserviceDTOInfoTuple>>() {}.getType()) , HttpStatus.OK);
    }

    @GetMapping(value = "post/iscList")
    public ResponseEntity<TotalResponse<ViewPostDTO.Info>> getposts(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getPosts(iscRq,resp), HttpStatus.OK);
    }

    @GetMapping(value = "department/getDepartmentsChilderenAndParents")
    public ResponseEntity<Set<MasterDataService.CompetenceWebserviceDTOInfoTuple>> getDepartmentsChilderenAndParents(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        TotalResponse<MasterDataService.CompetenceWebserviceDTO> childeren = masterDataService.getDepartments(iscRq,resp);
        Set<MasterDataService.CompetenceWebserviceDTOInfoTuple> departments = new HashSet<>(getDepartmentsRoot().getBody());
        Long anccestorId = departments.iterator().next().getId();
        for(MasterDataService.CompetenceWebserviceDTO child : childeren.getResponse().getData()){
            departments.addAll(findDeparmentAnccestor(anccestorId,child.getParentId()));
            departments.add(modelMapper.map(child, MasterDataService.CompetenceWebserviceDTOInfoTuple.class));
        }

        return new ResponseEntity<>(departments, HttpStatus.OK);
    }

    private List<MasterDataService.CompetenceWebserviceDTOInfoTuple> findDeparmentAnccestor(Long anccestorId, Long parentId)  throws IOException {
        List<MasterDataService.CompetenceWebserviceDTOInfoTuple> parents = new ArrayList<>();
        MasterDataService.CompetenceWebserviceDTOInfoTuple parent = modelMapper.map(masterDataService.getDepartmentsById(parentId), MasterDataService.CompetenceWebserviceDTOInfoTuple.class);
        if(parent.getParentId().equals(anccestorId)) {
            parents.add(parent);
            return parents;
        }
        else
            parents.addAll(findDeparmentAnccestor(anccestorId,parent.getParentId()));
        return parents;
    }
}
