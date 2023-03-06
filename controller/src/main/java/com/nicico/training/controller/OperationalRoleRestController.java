package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalRoleDTO;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.iservice.ISynonymOAUserService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.mapper.operationalRole.OperationalRoleBeanMapper;
import com.nicico.training.model.OperationalRole;
import com.nicico.training.model.Subcategory;
import com.nicico.training.model.SynonymOAUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/operational-role")
public class OperationalRoleRestController {

    private final IOperationalRoleService operationalRoleService;
    private final ITclassService iTclassService;
    private final ISynonymOAUserService synonymOAUserService;
    private final ObjectMapper objectMapper;
    private final OperationalRoleBeanMapper mapper;
    private final ModelMapper modelMapper;

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody OperationalRoleDTO.Create request) {
        try {
            OperationalRole creating = mapper.toOperationalRole(request);
            OperationalRoleDTO.Info info = mapper.toOperationalRoleInfoDto(operationalRoleService.create(creating));
            return new ResponseEntity<>(info, HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update( @RequestBody OperationalRoleDTO.Update request, @PathVariable Long id) {
        try {
            final OperationalRole operationalRole = operationalRoleService.getOperationalRole(id);
            OperationalRole updating;
            OperationalRole arrivedUpdate = mapper.toOperationalRoleFromOperationalRoleUpdateDto(request);
            updating = mapper.copyOperationalRoleFrom(operationalRole);
            /*
                    avoid re-update of "TBL_OPERATIONAL_ROLE_POST_IDS" after assigning
                    individual post to user
             */
            updating.setUserIds(request.getUserIds());

            updating.setObjectType(request.getObjectType());
            updating.setTitle(request.getTitle());
            updating.setComplexId(request.getComplexId());
            updating.setOperationalUnitId(request.getOperationalUnitId());
            updating.setCode(request.getCode());
            updating.setDescription(request.getDescription());

            updating.setCategories(arrivedUpdate.getCategories());
            if (!arrivedUpdate.getCategories().isEmpty() && arrivedUpdate.getCategories().size() != 0) {
                updating.setSubCategories(arrivedUpdate.getSubCategories());
            } else {
                Set<Subcategory> subcategories = new HashSet<>();
                updating.setSubCategories(subcategories);
            }
            OperationalRole result1 = operationalRoleService.update(id, updating);
            OperationalRoleDTO.Info result = mapper.toOperationalRoleInfoDto(result1);
            return new ResponseEntity<>(result, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<OperationalRoleDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        searchRq.setDistinct(true);
        SearchDTO.SearchRs<OperationalRoleDTO.Info> searchRs = null;
        try {
            searchRs = operationalRoleService.deepSearch(searchRq);
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{request}")
    public ResponseEntity deleteAll(@PathVariable List<Long> request) {
        try {
            operationalRoleService.deleteAll(request);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/3spec-list3")
    public ResponseEntity<OperationalRoleDTO.OperationalRoleSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<OperationalRoleDTO.Info> response = operationalRoleService.search(request);

        final OperationalRoleDTO.SpecRs specResponse = new OperationalRoleDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final OperationalRoleDTO.OperationalRoleSpecRs specRs = new OperationalRoleDTO.OperationalRoleSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/findAllByObjectType/{type}")
    public ResponseEntity<OperationalRoleDTO.OathUserSpecRs> findAllByObjectType( @PathVariable String type) throws IOException {
        final OperationalRoleDTO.SpecOauthRs specResponse = new OperationalRoleDTO.SpecOauthRs();
        Set<Long>  data=operationalRoleService.findAllByObjectType(type);
        List<SynonymOAUser> list=  synonymOAUserService.listOfUser(data.stream().toList());
          List<OperationalRoleDTO.OathInfo> dtoList=modelMapper.map(list, new TypeToken<List<OperationalRoleDTO.OathInfo>>() {
          }.getType());
        specResponse.setData(dtoList)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final OperationalRoleDTO.OathUserSpecRs specRs = new OperationalRoleDTO.OathUserSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);

    }
    @Loggable
    @GetMapping(value = "/findAllByObjectTypeAndPermission/{type}/{code}")
    public ResponseEntity<OperationalRoleDTO.OathUserSpecRs> findAllByObjectTypeAndPermission( @PathVariable String type, @PathVariable String code) throws IOException {
        final OperationalRoleDTO.SpecOauthRs specResponse = new OperationalRoleDTO.SpecOauthRs();
        Set<Long>  data=operationalRoleService.findAllByObjectTypeAndPermission(type,code);
        List<SynonymOAUser> list=  synonymOAUserService.listOfUser(data.stream().toList());
          List<OperationalRoleDTO.OathInfo> dtoList=modelMapper.map(list, new TypeToken<List<OperationalRoleDTO.OathInfo>>() {
          }.getType());
        specResponse.setData(dtoList)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final OperationalRoleDTO.OathUserSpecRs specRs = new OperationalRoleDTO.OathUserSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);

    }

    @Loggable
    @GetMapping(value = "/findAllByClassTypeAndPermission/{type}/{code}")
    public ResponseEntity<OperationalRoleDTO.OathUserSpecRs> findAllByClassTypeAndPermission( @PathVariable String type, @PathVariable String code) throws IOException {
        final OperationalRoleDTO.SpecOauthRs specResponse = new OperationalRoleDTO.SpecOauthRs();
        String courseCode="";
        String courseCodeOptional=iTclassService.getCourseCodeByClassByCode(code);
        if (courseCodeOptional != null)
            courseCode=courseCodeOptional;


        Set<Long>  data=operationalRoleService.findAllByObjectTypeAndPermission(type,courseCode);

        List<SynonymOAUser> list=  synonymOAUserService.listOfUser(data.stream().toList());
        List<OperationalRoleDTO.OathInfo> dtoList=modelMapper.map(list, new TypeToken<List<OperationalRoleDTO.OathInfo>>() {
        }.getType());
        specResponse.setData(dtoList)
                .setStartRow(0)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        final OperationalRoleDTO.OathUserSpecRs specRs = new OperationalRoleDTO.OathUserSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);

    }




}
