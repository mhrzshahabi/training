package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.model.TrainingPlace;
import com.nicico.training.service.InstituteService;
import com.nicico.training.service.TrainingPlaceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/institute")
public class InstituteRestController {

    private final InstituteService instituteService;
    private final ReportUtil reportUtil;
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final TrainingPlaceService trainingPlaceService;


    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<InstituteDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(instituteService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<List<InstituteDTO.Info>> list() {
        return new ResponseEntity<>(instituteService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_institute')")
    public ResponseEntity<InstituteDTO.Info> create(@RequestBody InstituteDTO.Create request, HttpServletResponse response) {
        return new ResponseEntity<>(instituteService.create(request, response), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_institute')")
    public ResponseEntity<InstituteDTO.Info> update(@PathVariable Long id, @RequestBody InstituteDTO.Update request, HttpServletResponse response) {
        return new ResponseEntity<>(instituteService.update(id, request, response), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_institute')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);

    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_institute')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody InstituteDTO.Delete request) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<InstituteDTO.InstituteSpecRs> list(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                             @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                             @RequestParam(value = "_constructor", required = false) String constructor,
                                                             @RequestParam(value = "operator", required = false) String operator,
                                                             @RequestParam(value = "criteria", required = false) String criteria,
                                                             @RequestParam(value = "id", required = false) Long id,
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

        boolean flag = true;

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<InstituteDTO.Info> response;
        InstituteDTO.SpecRs specResponse;
        InstituteDTO.InstituteSpecRs specRs = null;
        try {
            response = instituteService.search(request);
            specResponse = new InstituteDTO.SpecRs();
            specRs = new InstituteDTO.InstituteSpecRs();
            specResponse.setData(response.getList())
                    .setStartRow(startRow)
                    .setEndRow(startRow + response.getList().size())
                    .setTotalRows(response.getTotalCount().intValue());
            specRs.setResponse(specResponse);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<SearchDTO.SearchRs<InstituteDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(instituteService.search(request), HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "{instituteId}/equipments")
//    @PreAuthorize("hasAnyAuthority('r_equipment')")
    public ResponseEntity<EquipmentDTO.EquipmentSpecRs> getEquipments(@PathVariable Long instituteId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<EquipmentDTO.Info> equipments = instituteService.getEquipments(instituteId);

        final EquipmentDTO.SpecRs specResponse = new EquipmentDTO.SpecRs();
        specResponse.setData(equipments)
                .setStartRow(0)
                .setEndRow(equipments.size())
                .setTotalRows(equipments.size());

        final EquipmentDTO.EquipmentSpecRs specRs = new EquipmentDTO.EquipmentSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "{instituteId}/unattached-equipments")
//    @PreAuthorize("hasAnyAuthority('r_equipment')")
    public ResponseEntity<EquipmentDTO.EquipmentSpecRs> getUnAttachedEquipments(@RequestParam("_startRow") Integer startRow,
                                                                                @RequestParam("_endRow") Integer endRow,
                                                                                @RequestParam(value = "_constructor", required = false) String constructor,
                                                                                @RequestParam(value = "operator", required = false) String operator,
                                                                                @RequestParam(value = "criteria", required = false) String criteria,
                                                                                @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                                @PathVariable Long instituteId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();


        Integer pageSize = endRow - startRow;
        Integer pageNumber = (endRow - 1) / pageSize;
        Pageable pageable = PageRequest.of(pageNumber, pageSize);

        List<EquipmentDTO.Info> equipments = instituteService.getUnAttachedEquipments(instituteId, pageable);

        final EquipmentDTO.SpecRs specResponse = new EquipmentDTO.SpecRs();
        specResponse.setData(equipments)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(instituteService.getUnAttachedEquipmentsCount(instituteId));

        final EquipmentDTO.EquipmentSpecRs specRs = new EquipmentDTO.EquipmentSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/equipments")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<EquipmentDTO.EquipmentSpecRs> getAttachedEquipments(@RequestParam("instituteId") String instituteID) {
        Long instituteId = Long.parseLong(instituteID);

        List<EquipmentDTO.Info> equipments = instituteService.getEquipments(instituteId);

        final EquipmentDTO.SpecRs specResponse = new EquipmentDTO.SpecRs();
        specResponse.setData(equipments)
                .setStartRow(0)
                .setEndRow(equipments.size())
                .setTotalRows(equipments.size());

        final EquipmentDTO.EquipmentSpecRs specRs = new EquipmentDTO.EquipmentSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/unattached-equipments")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<EquipmentDTO.EquipmentSpecRs> getOtherEquipments(@RequestParam("_startRow") Integer startRow,
                                                                           @RequestParam("_endRow") Integer endRow,
                                                                           @RequestParam(value = "_constructor", required = false) String constructor,
                                                                           @RequestParam(value = "operator", required = false) String operator,
                                                                           @RequestParam(value = "criteria", required = false) String criteria,
                                                                           @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                           @RequestParam("instituteId") String instituteID) {
        Long instituteId = Long.parseLong(instituteID);

        Integer pageSize = endRow - startRow;
        Integer pageNumber = (endRow - 1) / pageSize;
        Pageable pageable = PageRequest.of(pageNumber, pageSize);


        List<EquipmentDTO.Info> equipments = instituteService.getUnAttachedEquipments(instituteId, pageable);

        final EquipmentDTO.SpecRs specResponse = new EquipmentDTO.SpecRs();
        specResponse.setData(equipments)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(instituteService.getUnAttachedEquipmentsCount(instituteId));

        final EquipmentDTO.EquipmentSpecRs specRs = new EquipmentDTO.EquipmentSpecRs();

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-equipment/{equipmentId}/{instituteId}")
    public ResponseEntity<Boolean> removeEquipment(@PathVariable Long equipmentId, @PathVariable Long instituteId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.removeEquipment(equipmentId, instituteId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/remove-equipment-list/{equipmentIds}/{instituteId}")
    public ResponseEntity<Boolean> removeEquipments(@PathVariable List<Long> equipmentIds, @PathVariable Long instituteId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.removeEquipments(equipmentIds, instituteId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @PostMapping(value = "/add-equipment/{equipmentId}/{instituteId}")
    public ResponseEntity<Boolean> addEquipment(@PathVariable Long equipmentId, @PathVariable Long instituteId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.addEquipment(equipmentId, instituteId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @PostMapping(value = "/add-equipment-list/{instituteId}")
    public ResponseEntity<Boolean> addEquipments(@Validated @RequestBody EquipmentDTO.EquipmentIdList request, @PathVariable Long instituteId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.addEquipments(request.getIds(), instituteId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "{instituteId}/teachers")
//    @PreAuthorize("hasAnyAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> getTeachers(@PathVariable Long instituteId) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<TeacherDTO.Info> teachers = instituteService.getTeachers(instituteId);

        final TeacherDTO.SpecRs specResponse = new TeacherDTO.SpecRs();
        specResponse.setData(teachers)
                .setStartRow(0)
                .setEndRow(teachers.size())
                .setTotalRows(teachers.size());

        final TeacherDTO.TeacherSpecRs specRs = new TeacherDTO.TeacherSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "{instituteId}/unattached-teachers")
    public ResponseEntity<ISC<TeacherDTO.Info>> getUnAttachedTeachers(HttpServletRequest iscRq, @PathVariable Long instituteId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<TeacherDTO.Info> searchRs = instituteService.getUnAttachedTeachers(searchRq, instituteId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/teachers")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> getAttachedTeachers(@RequestParam("instituteId") String instituteID) {
        Long instituteId = Long.parseLong(instituteID);

        List<TeacherDTO.Info> teachers = instituteService.getTeachers(instituteId);

        final TeacherDTO.SpecRs specResponse = new TeacherDTO.SpecRs();
        specResponse.setData(teachers)
                .setStartRow(0)
                .setEndRow(teachers.size())
                .setTotalRows(teachers.size());

        final TeacherDTO.TeacherSpecRs specRs = new TeacherDTO.TeacherSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/unattached-teachers")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> getOtherTeachers(@RequestParam("_startRow") Integer startRow,
                                                                     @RequestParam("_endRow") Integer endRow,
                                                                     @RequestParam(value = "_constructor", required = false) String constructor,
                                                                     @RequestParam(value = "operator", required = false) String operator,
                                                                     @RequestParam(value = "criteria", required = false) String criteria,
                                                                     @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                     @RequestParam("instituteId") String instituteID) {
        Long instituteId = Long.parseLong(instituteID);

        Integer pageSize = endRow - startRow;
        Integer pageNumber = (endRow - 1) / pageSize;
        Pageable pageable = PageRequest.of(pageNumber, pageSize);


        List<TeacherDTO.Info> teachers = instituteService.getUnAttachedTeachers(instituteId, pageable);

        final TeacherDTO.SpecRs specResponse = new TeacherDTO.SpecRs();
        specResponse.setData(teachers)
                .setStartRow(startRow)
                .setEndRow(endRow)
                .setTotalRows(instituteService.getUnAttachedTeachersCount(instituteId));

        final TeacherDTO.TeacherSpecRs specRs = new TeacherDTO.TeacherSpecRs();

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/remove-teacher/{teacherId}/{instituteId}")
    public ResponseEntity<Boolean> removeTeacher(@PathVariable Long teacherId, @PathVariable Long instituteId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.removeTeacher(teacherId, instituteId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/remove-teacher-list/{teacherIds}/{instituteId}")
    public ResponseEntity<Boolean> removeTeachers(@PathVariable List<Long> teacherIds, @PathVariable Long instituteId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.removeTeachers(teacherIds, instituteId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @PostMapping(value = "/add-teacher/{teacherId}/{instituteId}")
    public ResponseEntity<Boolean> addTeacher(@PathVariable Long teacherId, @PathVariable Long instituteId) {
        boolean flag = false;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            instituteService.addTeacher(teacherId, instituteId);
            flag = true;
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/teacher-dummy")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> teacherDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<>(new TeacherDTO.TeacherSpecRs(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/equipment-dummy")
//    @PreAuthorize("hasAuthority('r_equipment')")
    public ResponseEntity<EquipmentDTO.EquipmentSpecRs> equipmentDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<>(new EquipmentDTO.EquipmentSpecRs(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "{instituteId}/trainingPlaces")
//    @PreAuthorize("hasAnyAuthority('r_teacher')")
    public ResponseEntity<TrainingPlaceDTO.TrainingPlaceSpecRs> getTrainingPlaces(@PathVariable Long instituteId) {
        SearchDTO.SearchRq request=new SearchDTO.SearchRq();
        request.setStartIndex(null);
        request.setSortBy("-id");
        SearchDTO.CriteriaRq criteriaRq = null;

        criteriaRq =new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.equals);
        criteriaRq.setFieldName("instituteId");
        criteriaRq.setValue(instituteId);

        request.setCriteria(criteriaRq);
        SearchDTO.SearchRs<TrainingPlaceDTO.Info> response = trainingPlaceService.search(request);

        final TrainingPlaceDTO.SpecRs specResponse = new TrainingPlaceDTO.SpecRs();
        final TrainingPlaceDTO.TrainingPlaceSpecRs specRs = new TrainingPlaceDTO.TrainingPlaceSpecRs();

        specResponse.setData(response.getList())
                .setStartRow(0)
                .setEndRow(response.getList().size())
                .setTotalRows(response.getList().size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/account-dummy")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<InstituteAccountDTO.AccountSpecRs> accountDummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<InstituteAccountDTO.AccountSpecRs>(new InstituteAccountDTO.AccountSpecRs(), HttpStatus.OK);
    }


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

        searchRq.setSortBy("-id");

        final SearchDTO.SearchRs<InstituteDTO.Info> searchRs = instituteService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/InstituteList.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = "/trainingPlaces")
//    @PreAuthorize("hasAuthority('r_institute')")
    public ResponseEntity<InstituteDTO.InstituteSpecRs> listOfInstituteWithTrainingPlace(
            @RequestParam(value = "_startRow", required = false) Integer startRow,
            @RequestParam(value = "_endRow", required = false) Integer endRow,
            @RequestParam(value = "_constructor", required = false) String constructor,
            @RequestParam(value = "operator", required = false) String operator,
            @RequestParam(value = "criteria", required = false) String criteria,
            @RequestParam(value = "id", required = false) Long id,
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
        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        SearchDTO.SearchRs<InstituteDTO.Info> response;
//        InstituteDTO.SpecRs specResponse;
        InstituteDTO.InstituteSpecRs specRs = null;
        try {
            response = instituteService.search(request);
            InstituteDTO.SpecRs<InstituteDTO.InstituteWithTrainingPlace> specResponse = new InstituteDTO.SpecRs<>();
            specRs = new InstituteDTO.InstituteSpecRs();
            List<InstituteDTO.Info> list = response.getList();

            specResponse.setData(new ModelMapper().map(list, new TypeToken<List<InstituteDTO.InstituteWithTrainingPlace>>() {
            }.getType()))
                    .setStartRow(startRow)
                    .setEndRow(startRow + response.getList().size())
                    .setTotalRows(response.getTotalCount().intValue());
            specRs.setResponse(specResponse);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<InstituteDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(instituteService.search(nicicoCriteria), HttpStatus.OK);
    }

    @GetMapping(value = "/iscTupleList")
    public ResponseEntity<ISC<InstituteDTO.InstituteInfoTuple>> list(HttpServletRequest iscRq, @RequestParam(required = false) Long id) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (id != null) {
            searchRq.setCriteria(makeNewCriteria("id", id, EOperator.equals, null));
        }
        SearchDTO.SearchRs<InstituteDTO.InstituteInfoTuple> searchRs = instituteService.search(searchRq, i -> modelMapper.map(i, InstituteDTO.InstituteInfoTuple.class));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @GetMapping(value = "/iscSessionTupleList")
    public ResponseEntity<ISC<InstituteDTO.InstituteSessionTuple>> sessionlist(HttpServletRequest iscRq, @RequestParam(required = false) Long id) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (id != null) {
            searchRq.setCriteria(makeNewCriteria("id", id, EOperator.equals, null));
        }
        SearchDTO.SearchRs<InstituteDTO.InstituteSessionTuple> searchRs = instituteService.search(searchRq, i -> modelMapper.map(i, InstituteDTO.InstituteSessionTuple.class));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }
}
