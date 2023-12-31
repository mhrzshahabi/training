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
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.dto.SysUserInfoModel;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.iservice.IContactInfoService;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.Personnel;

import com.nicico.training.model.Post;
import com.nicico.training.model.ViewActivePersonnel;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.repository.ViewActivePersonnelDAO;
import com.nicico.training.service.CourseService;
import com.nicico.training.service.PersonnelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

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
    private final PersonnelDAO personnelDAO;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final IContactInfoService contactInfoService;

    //Unused
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
    @PostMapping(value = "/checkPersonnelNos/{courseId}")
    public ResponseEntity<List<PersonnelDTO.InfoForStudent>> checkPersonnelNos(@PathVariable Long courseId, @RequestBody List<String> personnelNos) {
        List<PersonnelDTO.InfoForStudent> list = personnelService.checkPersonnelNos(personnelNos, courseId);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    //Unused
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

    //Unused
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

    //Unused
    @Loggable
    @GetMapping(value = "/byPersonnelCode/{personnelCode}")
    public ResponseEntity<PersonnelDTO.PersonalityInfo> findPersonnelByPersonnelCode(@PathVariable String personnelCode) {
        PersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByPersonnelCode(personnelCode);
        return new ResponseEntity<>(personalInfoDTO, HttpStatus.OK);
    }

    //Unused
    @Loggable
    @GetMapping(value = "/byNationalCode/{nationalCode}")
    public ResponseEntity<PersonnelDTO.PersonalityInfo> findPersonnelByNationalCode(@PathVariable String nationalCode) {
        PersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByNationalCode(nationalCode);
        return new ResponseEntity<>(personalInfoDTO, HttpStatus.OK);
    }

    //Unused
    @Loggable
    @GetMapping(value = "/byId/{id}")
    public ResponseEntity<Personnel> findPersonnelById(@PathVariable Long id) {
        Personnel personalInfo = personnelDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return new ResponseEntity<>(personalInfo, HttpStatus.OK);
    }

    //Unused
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


    @GetMapping(value = "/findPersonnel/{personnelType}/{personnelId}/{nationalCode}/{personnelNo}")
    public ResponseEntity<PersonnelDTO.DetailInfo> findPersonnel(@PathVariable Long personnelType, @PathVariable Long personnelId, @PathVariable String nationalCode, @PathVariable String personnelNo) {
        PersonnelDTO.DetailInfo personnel = personnelService.findPersonnel(personnelType, personnelId, nationalCode, personnelNo);
        if (personnel == null) {
            return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
        } else {
            return new ResponseEntity<>(personnel, HttpStatus.OK);
        }


    }

    //TODO:must be check
    @GetMapping("/all-field-values")
    public ResponseEntity<ISC<PersonnelDTO.FieldValue>> findAllValuesOfOneFieldFromPersonnel(@RequestParam String fieldName) {
        return new ResponseEntity<>(ISC.convertToIscRs(personnelService.findAllValuesOfOneFieldFromPersonnel(fieldName), 0), HttpStatus.OK);
    }


    //TODO:must be check
    @Loggable
    @GetMapping(value = "/getOneByNationalCode/{nationalCode}")
    public ResponseEntity getOneByNationalCode(@PathVariable String nationalCode) {
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
        criteria.getCriteria().add(makeNewCriteria("nationalCode", nationalCode, EOperator.equals, null));
        List<PersonnelDTO.Info> personnelList = personnelService.search(new SearchDTO.SearchRq().setCriteria(criteria)).getList();
        if (!personnelList.isEmpty())
            return new ResponseEntity<>(personnelList.get(0), HttpStatus.OK);

        criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(makeNewCriteria("deleted", 0, EOperator.isNull, null));
        criteria.getCriteria().add(makeNewCriteria("nationalCode", nationalCode, EOperator.equals, null));

        List<PersonnelRegisteredDTO.Info> personnelRegisteredList = personnelRegisteredService.search(new SearchDTO.SearchRq().setCriteria(criteria)).getList();
        if (!personnelRegisteredList.isEmpty())
            return new ResponseEntity<>(personnelRegisteredList.get(0), HttpStatus.OK);
        else if (nationalCode.equalsIgnoreCase("null"))
            return new ResponseEntity<>("اطلاعات کاربر در سیستم ناقص می باشد", HttpStatus.NOT_FOUND);
        else
            return new ResponseEntity<>("پرسنلی با این کد ملی در سیستم پیدا نشد", HttpStatus.NOT_FOUND);
    }

    //Unused
    @Loggable
    @GetMapping(value = "/get-user-info")
    public ResponseEntity getUserInfo() {
        if (SecurityUtil.getNationalCode() == null)
            return new ResponseEntity<>(messageSource.getMessage("person.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.NOT_FOUND);
        return getOneByNationalCode(SecurityUtil.getNationalCode());
    }

    @Loggable
    @GetMapping(value = "/personnelFullName/{id}")
    public ResponseEntity<String> personnelFullName(@PathVariable Long id) {
        String result = personnelDAO.getPersonnelFullName(id);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/inDepartmentIsPlanner/{mojtameCode}")
    public ResponseEntity<List<Long>> inDepartmentIsPlanner(@PathVariable String mojtameCode) {
        return new ResponseEntity<>(personnelService.inDepartmentIsPlanner(mojtameCode), HttpStatus.OK);
    }

    @GetMapping(value = "/fetchAndUpdateLastHrMobile/{type}/{id}")
    public ResponseEntity fetchAndUpdateLastHrMobile(HttpServletRequest iscRq, @PathVariable Long id,@PathVariable String type) {
        Long infoId = contactInfoService.fetchAndUpdateLastHrMobile(id, type, iscRq.getHeader("Authorization")).getId();
        return new ResponseEntity(infoId, HttpStatus.OK);
    }

    @GetMapping("/minio/validation")
    public SysUserInfoModel validatingUserRequest() {
        return personnelService.minioValidate();
    }

}
