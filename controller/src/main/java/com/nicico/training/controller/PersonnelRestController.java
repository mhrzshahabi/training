/*
ghazanfari_f, 8/29/2019, 11:41 AM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.model.Personnel;

import com.nicico.training.service.CourseService;
import com.nicico.training.service.PersonnelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/personnel/")
public class PersonnelRestController {

    final ObjectMapper objectMapper;
    final CourseService courseService;
    final DateUtil dateUtil;
    final ReportUtil reportUtil;
    private final MessageSource messageSource;
    private final PersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;

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
    @PostMapping(value = "checkPersonnelNos")
    public ResponseEntity<List<PersonnelDTO.Info>> checkPersonnelNos(@RequestBody List<String> personnelNos) {
        List<PersonnelDTO.Info> list=personnelService.checkPersonnelNos(personnelNos);
        return new ResponseEntity<>(list,HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/byPostCode/{postId}")
    public ResponseEntity<PersonnelDTO.PersonnelSpecRs> findPersonnelByPostCode(@PathVariable Long postId) {

        List<PersonnelDTO.Info> list = personnelService.getByPostCode(postId);

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

        List<PersonnelDTO.Info> list = personnelService.getByJobNo(jobNo);

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

    @Loggable
    @GetMapping(value = "/byNationalCode/{nationalCode}")
    public ResponseEntity<PersonnelDTO.PersonalityInfo> findPersonnelByNationalCode(@PathVariable String nationalCode) {
        PersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByNationalCode(nationalCode);
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

    @GetMapping("/all-field-values")
    public ResponseEntity<ISC<PersonnelDTO.FieldValue>> findAllValuesOfOneFieldFromPersonnel(@RequestParam String fieldName) {
        return new ResponseEntity<>(ISC.convertToIscRs(personnelService.findAllValuesOfOneFieldFromPersonnel(fieldName), 0), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getOneByNationalCode/{nationalCode}")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity getOneByNationalCode(@PathVariable String nationalCode) {
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(makeNewCriteria("active", 1, EOperator.equals, null));
        criteria.getCriteria().add(makeNewCriteria("nationalCode", nationalCode, EOperator.equals, null));
        List<PersonnelDTO.Info> personnelList = personnelService.search(new SearchDTO.SearchRq().setCriteria(criteria)).getList();
        if (!personnelList.isEmpty())
            return new ResponseEntity<>(personnelList.get(0), HttpStatus.OK);
        List<PersonnelRegisteredDTO.Info> personnelRegisteredList = personnelRegisteredService.search(new SearchDTO.SearchRq().setCriteria(criteria)).getList();
        if (!personnelRegisteredList.isEmpty())
            return new ResponseEntity<>(personnelRegisteredList.get(0), HttpStatus.OK);
        return new ResponseEntity<>(messageSource.getMessage("person.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.NOT_FOUND);
    }

    @Loggable
    @GetMapping(value = "/get-user-info")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity getUserInfo() {
        if (SecurityUtil.getNationalCode() == null)
            return new ResponseEntity<>(messageSource.getMessage("person.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.NOT_FOUND);
        return getOneByNationalCode(SecurityUtil.getNationalCode());
    }
}
