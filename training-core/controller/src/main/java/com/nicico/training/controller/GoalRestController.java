package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.dto.search.EOperator;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.GoalDTO;
import com.nicico.training.dto.SyllabusDTO;
import com.nicico.training.iservice.IGoalService;
import com.nicico.training.iservice.ISyllabusService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.JRException;
import org.apache.commons.lang3.StringUtils;
import org.ietf.jgss.GSSName;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/goal")
public class GoalRestController {
    
    private final IGoalService goalService;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_goal')")
    public ResponseEntity<GoalDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(goalService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_goal')")
    public ResponseEntity<List<GoalDTO.Info>> list() {
        return new ResponseEntity<>(goalService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "create/{courseId}")
//    @PreAuthorize("hasAuthority('c_goal')")
    public ResponseEntity<GoalDTO.Info> create(@Validated @RequestBody GoalDTO.Create request,@PathVariable Long courseId) {
        return new ResponseEntity<>(goalService.create(request,courseId), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_goal')")
    public ResponseEntity<GoalDTO.Info> update(@PathVariable Long id, @Validated @RequestBody GoalDTO.Update request) {
        return new ResponseEntity<>(goalService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_goal')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        goalService.delete(id);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_goal')")
    public ResponseEntity<Void> delete(@Validated @RequestBody GoalDTO.Delete request) {
        goalService.delete(request);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_goal')")
    public ResponseEntity<GoalDTO.GoalSpecRs> list(@RequestParam("_startRow") Integer startRow,
                                                   @RequestParam("_endRow") Integer endRow,
                                                   @RequestParam(value = "_constructor", required = false) String constructor,
                                                   @RequestParam(value = "operator", required = false) String operator,
                                                   @RequestParam(value = "criteria", required = false) String criteria,
                                                   @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException
    {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            if (StringUtils.isNotEmpty(sortBy)) {
                request.set_sortBy(sortBy);
            }

            request.setCriteria(criteriaRq);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<GoalDTO.Info> response = goalService.search(request);

        final GoalDTO.SpecRs specResponse = new GoalDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final GoalDTO.GoalSpecRs specRs = new GoalDTO.GoalSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_goal')")
    public ResponseEntity<SearchDTO.SearchRs<GoalDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(goalService.search(request), HttpStatus.OK);
    }

    // ------------------------------

    @Loggable
    @GetMapping(value = "/syllabus/{goalId}")
//    @PreAuthorize("hasAnyAuthority('r_goal')")
    public ResponseEntity<List<SyllabusDTO.Info>> getSyllabusSet(@PathVariable Long goalId) {
        return new ResponseEntity<>(goalService.getSyllabusSet(goalId), HttpStatus.OK);
    }

    //  -------------------------------


    @Loggable
    @GetMapping(value = "{goalId}/syllabus")
//    @PreAuthorize("hasAnyAuthority('r_sub_Category')")
    public ResponseEntity<SyllabusDTO.SyllabusSpecRs> getSyllabus(@PathVariable Long goalId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<SyllabusDTO.Info> syllabusList = goalService.getSyllabusSet(goalId);
        final SyllabusDTO.SpecRs specResponse = new SyllabusDTO.SpecRs();
        specResponse.setData(syllabusList)
                .setStartRow(0)
                .setEndRow( syllabusList.size())
                .setTotalRows(syllabusList.size());

        final SyllabusDTO.SyllabusSpecRs specRs = new SyllabusDTO.SyllabusSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
    // -----------------

    @Loggable
    @GetMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response, @PathVariable String type) throws SQLException, IOException, JRException {
        Map<String, Object> params = new HashMap<>();
        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/Goal.jasper", params, response);
    }
}
