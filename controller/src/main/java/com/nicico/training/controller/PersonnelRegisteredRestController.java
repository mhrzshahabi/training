package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.dto.StudentClassReportViewDTO;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.mapper.person.PersonnelRegisterBeanMapper;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.PersonnelRegistered;
import com.nicico.training.repository.PersonnelDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/personnelRegistered")
public class PersonnelRegisteredRestController {

    private final IPersonnelRegisteredService personnelRegisteredService;
    private final PersonnelRegisterBeanMapper personnelRegisterBeanMapper;
    private final IPersonnelService iPersonnelService;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;

    //Unused
    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_personnelRegistered')")
    public ResponseEntity<PersonnelRegisteredDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(personnelRegisteredService.get(id), HttpStatus.OK);
    }

    //Unused
    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_personnelRegistered')")
    public ResponseEntity<List<PersonnelRegisteredDTO.Info>> list() {
        return new ResponseEntity<>(personnelRegisteredService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_personnelRegistered')")
    public ResponseEntity<PersonnelRegisteredDTO.Info> create(@Validated @RequestBody PersonnelRegisteredDTO.Create request) {
        return new ResponseEntity<>(personnelRegisteredService.create(request), HttpStatus.CREATED);
    }

    //Unused
    @Loggable
    @GetMapping(value = "/getOneByNationalCode/{nationalCode}")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity<PersonnelRegisteredDTO.Info> getOneByNationalCode(@PathVariable String nationalCode) {

        Optional<PersonnelRegistered> optionalPersonnelReg = personnelRegisteredService.getByNationalCode(nationalCode);
//        Optional<Personnel> optionalPersonnel = iPersonnelService.getOneByNationalCodeAndDeleted(nationalCode, 0);
        if(optionalPersonnelReg.isPresent() && optionalPersonnelReg.get().getDeleted()!=null){
            if(optionalPersonnelReg.get().getDeleted()==0){
                return new ResponseEntity<>(null, HttpStatus.NOT_ACCEPTABLE);
            }
        }



        return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_personnelRegistered')")
    public ResponseEntity<PersonnelRegisteredDTO.Info> update(@PathVariable Long id, @Validated @RequestBody PersonnelRegisteredDTO.Update request) {
        return new ResponseEntity<>(personnelRegisteredService.update(id, request), HttpStatus.OK);
    }
    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_personnelRegistered')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        try {
            personnelRegisteredService.delete(id);
            return new ResponseEntity(true, HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity(false, HttpStatus.NO_CONTENT);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_personnelRegistered')")
    public ResponseEntity<Void> delete(@Validated @RequestBody PersonnelRegisteredDTO.Delete request) {
        personnelRegisteredService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_personnelRegistered')")
    public ResponseEntity<PersonnelRegisteredDTO.PersonnelRegisteredSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
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

        SearchDTO.SearchRs<PersonnelRegisteredDTO.Info> response = personnelRegisteredService.search(request);

        final PersonnelRegisteredDTO.SpecRs specResponse = new PersonnelRegisteredDTO.SpecRs();
        final PersonnelRegisteredDTO.PersonnelRegisteredSpecRs specRs = new PersonnelRegisteredDTO.PersonnelRegisteredSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    //Unused
    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_personnelRegistered')")
    public ResponseEntity<SearchDTO.SearchRs<PersonnelRegisteredDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(personnelRegisteredService.search(request), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/checkPersonnelNos/{courseId}")
    public ResponseEntity<List<PersonnelRegisteredDTO.InfoForStudent>> checkPersonnelNos(@PathVariable Long courseId, @RequestBody List<String> personnelNos) {
        List<PersonnelRegisteredDTO.InfoForStudent> list = personnelRegisteredService.checkPersonnelNos(personnelNos, courseId);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    //unused
    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {
        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }

        final SearchDTO.SearchRs<PersonnelRegisteredDTO.Info> searchRs = personnelRegisteredService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/PersonnelRegisteredByCriteria.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @PostMapping(value = "/checkPersonnelNationalCodes")
    public ResponseEntity<List<PersonnelRegisteredDTO>> checkPersonnelNationalCodes(@RequestBody List<String> personnelNationalCodes) {
         List<PersonnelRegistered> list = personnelRegisteredService.checkPersonnelNationalCodes(personnelNationalCodes);
        List<PersonnelRegisteredDTO> registeredDTOS=personnelRegisterBeanMapper.toPersonnelRegisteredDTOList(list);
        return new ResponseEntity<>(registeredDTOS, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/addList")
//    @PreAuthorize("hasAuthority('c_personnelRegistered')")
    public ResponseEntity<String> createList( @RequestBody List<PersonnelRegisteredDTO> requests) {
        List<PersonnelRegistered> list=personnelRegisterBeanMapper.toPersonnelRegisteredList(requests);
        personnelRegisteredService.createList(list);
        return new ResponseEntity<>("added successful", HttpStatus.CREATED);
    }

}
