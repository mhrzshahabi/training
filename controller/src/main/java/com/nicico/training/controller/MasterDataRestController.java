/**
 * Author:    Mehran Golrokhi
 * Created:    1399.03.24
 * Description:    Use of WebService
 */


package com.nicico.training.controller;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.masterData.MasterDataClient;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.CompetenceWebserviceDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.service.MasterDataService;
import com.nicico.training.service.PersonnelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import response.masterData.JobExpResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/masterData/")
public class MasterDataRestController {

    private final MasterDataService masterDataService;
    private final MasterDataClient masterDataClient;
    private final PersonnelService personnelService;
    private final ModelMapper modelMapper;


    @GetMapping(value = "personnel/iscList")
    public ResponseEntity<TotalResponse<PersonnelDTO.Info>> getPersonnel(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getPeople(iscRq, resp), HttpStatus.OK);
    }

    @GetMapping(value = "competence/iscList")
    public ResponseEntity<TotalResponse<CompetenceDTO.Info>> getCompetences(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getCompetencies(iscRq, resp), HttpStatus.OK);
    }

    @GetMapping(value = "department/iscList")
    public ResponseEntity<TotalResponse<CompetenceWebserviceDTO>> getDepartments(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getDepartments(iscRq, resp), HttpStatus.OK);
    }

    @GetMapping(value = "department/touple-iscList")
    public ResponseEntity<TotalResponse<CompetenceWebserviceDTO.TupleInfo>> getToupleDepartments(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {

        TotalResponse<CompetenceWebserviceDTO> departments = masterDataService.getDepartments(iscRq, resp);
        departments.getResponse().setData(modelMapper.map(departments.getResponse().getData(), new TypeToken<List<CompetenceWebserviceDTO.TupleInfo>>() {
        }.getType()));
        return new ResponseEntity<>((TotalResponse<CompetenceWebserviceDTO.TupleInfo>) (Object) departments, HttpStatus.OK);
    }

    @GetMapping(value = "department/getDepartmentsByParentId/{parentId}")
    public ResponseEntity<List<CompetenceWebserviceDTO.TupleInfo>> getDepartmentsByParentCode(@PathVariable String parentId) throws IOException {
        List<CompetenceWebserviceDTO.TupleInfo> result = modelMapper.map(masterDataService.getDepartmentsByParentCode("ParentId?parentId=" + parentId), new TypeToken<List<CompetenceWebserviceDTO.TupleInfo>>() {
        }.getType());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @PostMapping(value = "department/getDepartmentsChilderen")
    public ResponseEntity<List<CompetenceWebserviceDTO.TupleInfo>> getDepartmentsChilderen(@RequestBody List<Long> childeren) throws IOException {
        List<CompetenceWebserviceDTO.TupleInfo> result = modelMapper.map(masterDataService.getDepartmentsChilderenByParentCode(childeren), new TypeToken<List<CompetenceWebserviceDTO.TupleInfo>>() {
        }.getType());
        return new ResponseEntity<>(result, HttpStatus.OK);

    }

    @GetMapping(value = "department/getDepartmentsRoot")
    public ResponseEntity<List<CompetenceWebserviceDTO.TupleInfo>> getDepartmentsRoot() throws IOException {
        List<CompetenceWebserviceDTO.TupleInfo> roots = modelMapper.map(masterDataService.getDepartmentsByParentCode("RootByType?peopleType=Personal"), new TypeToken<List<CompetenceWebserviceDTO.TupleInfo>>() {
        }.getType());
        for (CompetenceWebserviceDTO.TupleInfo root : roots)
            root.setParentId(new Long(0));
        return new ResponseEntity<>(roots, HttpStatus.OK);
    }

    @GetMapping(value = "post/iscList")
    public ResponseEntity<TotalResponse<ViewPostDTO.Info>> getposts(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        return new ResponseEntity<>(masterDataService.getPosts(iscRq, resp), HttpStatus.OK);
    }

    @GetMapping(value = "department/getDepartmentsChilderenAndParents")
    public ResponseEntity<Set<CompetenceWebserviceDTO.TupleInfo>> getDepartmentsChilderenAndParents(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        TotalResponse<CompetenceWebserviceDTO> childeren = masterDataService.getDepartments(iscRq, resp);
        Set<CompetenceWebserviceDTO.TupleInfo> departments = new HashSet<>();
        Long anccestorId = null;
        if (childeren.getResponse().getData().size() > 0) {
            anccestorId = getDepartmentsRoot().getBody().get(0).getId();
            departments.add(getDepartmentsRoot().getBody().get(0));
        }
        for (CompetenceWebserviceDTO child : childeren.getResponse().getData()) {
            departments.addAll(findDeparmentAnccestor(anccestorId, child.getParentId()));
            departments.add(modelMapper.map(child, CompetenceWebserviceDTO.TupleInfo.class));
        }

        return new ResponseEntity<>(departments, HttpStatus.OK);
    }

    private List<CompetenceWebserviceDTO.TupleInfo> findDeparmentAnccestor(Long anccestorId, Long parentId) throws IOException {
        List<CompetenceWebserviceDTO.TupleInfo> parents = new ArrayList<>();
        CompetenceWebserviceDTO.TupleInfo parent = modelMapper.map(masterDataService.getDepartmentsById(parentId), CompetenceWebserviceDTO.TupleInfo.class);
        if (parent.getParentId().equals(anccestorId)) {
            parents.add(parent);
            return parents;
        } else {
            parents.add(parent);
            parents.addAll(findDeparmentAnccestor(anccestorId, parent.getParentId()));
        }
        return parents;
    }

    ////////////////////////////////////////////////////
    //Amin HK

    @GetMapping(value = "getIDPersonByNationalCode/{nationalCode}")
    public ResponseEntity<List<PersonnelDTO.Info>> getIDPersonByNationalCode(@PathVariable String nationalCode) throws IOException {
        List<PersonnelDTO.Info> results = modelMapper.map(masterDataService.getPersonByNationalCode(nationalCode), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
        return new ResponseEntity<>(results, HttpStatus.OK);
    }

    /*@GetMapping(value = "parentEmployeeById/{peopleId}")
    public ResponseEntity<PersonnelDTO.Info> getParentEmployeeById(@PathVariable Long peopleId) throws IOException {
        PersonnelDTO.Info result= modelMapper.map(masterDataService.getParentEmployee(peopleId), new TypeToken<PersonnelDTO.Info>(){}.getType());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }*/

    @GetMapping(value = "parentEmployee/{nationalCode}")
    public ResponseEntity<PersonnelDTO.Info> getParentEmployee(@PathVariable String nationalCode) throws IOException {
        List<PersonnelDTO.Info> tempResult = modelMapper.map(masterDataService.getPersonByNationalCode(nationalCode), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());

        PersonnelDTO.Info result = modelMapper.map(masterDataService.getParentEmployee(tempResult.get(0).getId()), new TypeToken<PersonnelDTO.Info>() {
        }.getType());
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    /*@GetMapping(value = "siblingsEmployeeById/{peopleId}")
    public ResponseEntity<List<PersonnelDTO.Info>> getSiblingsEmployeeById(@PathVariable Long peopleId) throws IOException {
        List<PersonnelDTO.Info> results=modelMapper.map(masterDataService.getSiblingsEmployee(peopleId), new TypeToken<List<PersonnelDTO.Info>>(){}.getType());
        return new ResponseEntity<>(results , HttpStatus.OK);
    }*/

    @GetMapping(value = "siblingsEmployee/{nationalCode}")
    public ResponseEntity<List<PersonnelDTO.Info>> getSiblingsEmployee(@PathVariable String nationalCode) throws IOException {
        List<PersonnelDTO.Info> tempResult = modelMapper.map(masterDataService.getPersonByNationalCode(nationalCode), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());

        List<PersonnelDTO.Info> results = modelMapper.map(masterDataService.getSiblingsEmployee(tempResult.get(0).getId()), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
        return new ResponseEntity<>(results, HttpStatus.OK);
    }

    @GetMapping(value = "job/{nationalCode}")
    public ResponseEntity<ISC<JobExpResponse>> getJobExperiences(HttpServletRequest request, @PathVariable String nationalCode) {
        try {

            String token = request.getHeader("Authorization");
            if (token != null && !token.contains("Bearer "))
                token = "Bearer " + token;

            List<JobExpResponse> jobExperiences = masterDataClient.getJobExperiences(nationalCode, token);

            ISC.Response response = new ISC.Response();
            response.setData(jobExperiences);
            response.setStartRow(0);
            response.setEndRow(jobExperiences.size());
            response.setTotalRows(jobExperiences.size());
            response.setStatus(200);

            ISC<JobExpResponse> isc = new ISC<>(response);
            return new ResponseEntity<>(isc, HttpStatus.OK);

        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.Unauthorized);
        }
    }

    @GetMapping(value = "post")
    public ResponseEntity<ISC<JobExpResponse.postInfo>> getPostRecords(HttpServletRequest request) {
        try {

            String postCode = request.getParameter("postCode");
            String token = request.getHeader("Authorization");
            if (token != null && !token.contains("Bearer "))
                token = "Bearer " + token;

            List<JobExpResponse> jobExperiences = masterDataClient.getPostRecords(postCode, token);
            List<JobExpResponse.postInfo> postInfoList = new ArrayList<>();
            jobExperiences.stream().filter(q -> q.getSsn() != null).collect(Collectors.toList()).forEach(item -> {
                PersonnelDTO.PersonalityInfo personalityInfo = personnelService.getByNationalCode(item.getSsn());
                JobExpResponse.postInfo postInfo = modelMapper.map(item, JobExpResponse.postInfo.class);
                postInfo.setFirstName(personalityInfo.getFirstName());
                postInfo.setLastName(personalityInfo.getLastName());
                postInfo.setNationalCode(personalityInfo.getNationalCode());
                postInfoList.add(postInfo);
            });

            ISC.Response response = new ISC.Response();
            response.setData(postInfoList);
            response.setStartRow(0);
            response.setEndRow(postInfoList.size());
            response.setTotalRows(postInfoList.size());
            response.setStatus(200);
            ISC<JobExpResponse.postInfo> isc = new ISC<>(response);
            return new ResponseEntity<>(isc, HttpStatus.OK);

        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.Unauthorized);
        }
    }
}
