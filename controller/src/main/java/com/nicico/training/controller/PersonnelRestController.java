/*
ghazanfari_f, 8/29/2019, 11:41 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.model.Personnel;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.service.CourseService;
import com.nicico.training.service.PersonnelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/personnel/")
public class PersonnelRestController {

    final ObjectMapper objectMapper;
    final CourseService courseService;
    final DateUtil dateUtil;
    final ReportUtil reportUtil;
    private final PersonnelService personnelService;
    private final PersonnelDAO personnelDAO;
    private final PostDAO postDAO;

    @GetMapping("list")
    public ResponseEntity<List<PersonnelDTO.Info>> list() {
        return new ResponseEntity<>(personnelService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "iscList")
    public ResponseEntity<TotalResponse<PersonnelDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(personnelService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/byPostCode/{postId}")
    public ResponseEntity<PersonnelDTO.PersonnelSpecRs> findPersonnelByPostCode(@PathVariable Long postId) {


        List<PersonnelDTO.Info> list = new ArrayList<>();
        list = personnelService.getByPostCode(postId);

        final PersonnelDTO.SpecRs specResponse = new PersonnelDTO.SpecRs();
        final PersonnelDTO.PersonnelSpecRs specRs = new PersonnelDTO.PersonnelSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/byJobNo/{jobNo}")
    public ResponseEntity<PersonnelDTO.PersonnelSpecRs> findPersonnelByJobNo(@PathVariable String jobNo) {


        List<PersonnelDTO.Info> list = new ArrayList<>();
        list = personnelService.getByJobNo(jobNo);

        final PersonnelDTO.SpecRs specResponse = new PersonnelDTO.SpecRs();
        final PersonnelDTO.PersonnelSpecRs specRs = new PersonnelDTO.PersonnelSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/byPersonnelCode/{personnelCode}")
    public ResponseEntity<PersonnelDTO.PersonalityInfo> findPersonnelByPersonnelCode(@PathVariable String personnelCode) {
        PersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByPersonnelCode(personnelCode);
        return new ResponseEntity<>(personalInfoDTO, HttpStatus.OK);
    }

    @GetMapping("/statisticalReport/{reportType}")
    public ResponseEntity<PersonnelDTO.PersonnelSpecRs> findAllStatisticalReport(@PathVariable String reportType) {
        List<PersonnelDTO.Info> list = personnelService.findAllStatisticalReportFilter(reportType);

        final PersonnelDTO.SpecRs specResponse = new PersonnelDTO.SpecRs();
        final PersonnelDTO.PersonnelSpecRs specRs = new PersonnelDTO.PersonnelSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "/byPersonnelNo/{personnelNo}")
    public ResponseEntity<Personnel> findPersonnelByPersonnelId(@PathVariable String personnelNo) {
        return new ResponseEntity<>(personnelService.findPersonnelByPersonnelNo(personnelNo), HttpStatus.OK);
    }

}
