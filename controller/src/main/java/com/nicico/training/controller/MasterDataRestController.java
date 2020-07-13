/**
 * Author:    Mehran Golrokhi
 * Created:    1399.03.24
 * Description:    Use of WebService
 */


package com.nicico.training.controller;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.service.MasterDataService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
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
        List<MasterDataService.CompetenceWebserviceDTOInfoTuple> roots = modelMapper.map(masterDataService.getDepartmentsByParentCode("RootByType?peopleType=Personal"),new TypeToken<List<MasterDataService.CompetenceWebserviceDTOInfoTuple>>() {}.getType());
        for(MasterDataService.CompetenceWebserviceDTOInfoTuple root : roots)
            root.setParentId(new Long(0));
        return new ResponseEntity<>(roots  , HttpStatus.OK);
    }

    @GetMapping(value = "post/iscList")
    public ResponseEntity<TotalResponse<ViewPostDTO.Info>> getposts(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getPosts(iscRq,resp), HttpStatus.OK);
    }

    @GetMapping(value = "department/getDepartmentsChilderenAndParents")
    public ResponseEntity<Set<MasterDataService.CompetenceWebserviceDTOInfoTuple>> getDepartmentsChilderenAndParents(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        TotalResponse<MasterDataService.CompetenceWebserviceDTO> childeren = masterDataService.getDepartments(iscRq,resp);
        Set<MasterDataService.CompetenceWebserviceDTOInfoTuple> departments = new HashSet<>();//getDepartmentsRoot().getBody()
        //Long anccestorId = departments.iterator().next().getId();//
//        getDepartmentsRoot().getBody().get(0).setParentId(new Long(0));
        Long anccestorId = getDepartmentsRoot().getBody().get(0).getId();
        departments.add(getDepartmentsRoot().getBody().get(0));
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
        else {
            parents.add(parent);
            parents.addAll(findDeparmentAnccestor(anccestorId, parent.getParentId()));
        }
        return parents;
    }

    ////////////////////////////////////////////////////
    //Amin HK

    @GetMapping(value = "getIDPersonByNationalCode/{nationalCode}")
    public ResponseEntity<List<PersonnelDTO.Info>> getIDPersonByNationalCode(@PathVariable String nationalCode) throws IOException {
        List<PersonnelDTO.Info> results=modelMapper.map(masterDataService.getPersonByNationalCode(nationalCode), new TypeToken<List<PersonnelDTO.Info>>(){}.getType());
        return new ResponseEntity<>(results , HttpStatus.OK);
    }

    /*@GetMapping(value = "parentEmployeeById/{peopleId}")
    public ResponseEntity<PersonnelDTO.Info> getParentEmployeeById(@PathVariable Long peopleId) throws IOException {
        PersonnelDTO.Info result= modelMapper.map(masterDataService.getParentEmployee(peopleId), new TypeToken<PersonnelDTO.Info>(){}.getType());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }*/

    @GetMapping(value = "parentEmployee/{nationalCode}")
    public ResponseEntity<PersonnelDTO.Info> getParentEmployee(@PathVariable String nationalCode) throws IOException {
        List<PersonnelDTO.Info> tempResult=modelMapper.map(masterDataService.getPersonByNationalCode(nationalCode), new TypeToken<List<PersonnelDTO.Info>>(){}.getType());

        PersonnelDTO.Info result= modelMapper.map(masterDataService.getParentEmployee(tempResult.get(0).getId()), new TypeToken<PersonnelDTO.Info>(){}.getType());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    /*@GetMapping(value = "siblingsEmployeeById/{peopleId}")
    public ResponseEntity<List<PersonnelDTO.Info>> getSiblingsEmployeeById(@PathVariable Long peopleId) throws IOException {
        List<PersonnelDTO.Info> results=modelMapper.map(masterDataService.getSiblingsEmployee(peopleId), new TypeToken<List<PersonnelDTO.Info>>(){}.getType());
        return new ResponseEntity<>(results , HttpStatus.OK);
    }*/

    @GetMapping(value = "siblingsEmployee/{nationalCode}")
    public ResponseEntity<List<PersonnelDTO.Info>> getSiblingsEmployee(@PathVariable String nationalCode) throws IOException {
        List<PersonnelDTO.Info> tempResult=modelMapper.map(masterDataService.getPersonByNationalCode(nationalCode), new TypeToken<List<PersonnelDTO.Info>>(){}.getType());

        List<PersonnelDTO.Info> results=modelMapper.map(masterDataService.getSiblingsEmployee(tempResult.get(0).getId()), new TypeToken<List<PersonnelDTO.Info>>(){}.getType());
        return new ResponseEntity<>(results , HttpStatus.OK);
    }
}
