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
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.Personnel;

import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.service.CourseService;
import com.nicico.training.service.MasterDataService;
import com.nicico.training.service.PersonnelService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
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
    private final PersonnelDAO personnelDAO;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final MasterDataService masterDataService;
    private final ModelMapper modelMapper;

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
    public ResponseEntity<List<PersonnelDTO.InfoForStudent>> checkPersonnelNos(@PathVariable Long courseId,@RequestBody List<String> personnelNos) {
        List<PersonnelDTO.InfoForStudent> list = personnelService.checkPersonnelNos(personnelNos, courseId);
        return new ResponseEntity<>(list, HttpStatus.OK);
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


    @Loggable
    @GetMapping(value = "/byId/{id}")
    public ResponseEntity<Personnel> findPersonnelById(@PathVariable Long id) {
        Personnel personalInfo = personnelDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return new ResponseEntity<>(personalInfo, HttpStatus.OK);
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

    @GetMapping(value = "/byPersonnelNo/{personnelId}/{personnelNo}")
    public ResponseEntity<PersonnelDTO.DetailInfo> findPersonnelByPersonnelId(@PathVariable Long personnelId, @PathVariable String personnelNo) {
        return new ResponseEntity<>(personnelService.findPersonnelByPersonnelId(personnelId, personnelNo), HttpStatus.OK);
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
        else if (nationalCode.equalsIgnoreCase("null"))
            return new ResponseEntity<>("اطلاعات کاربر در سیستم ناقص می باشد", HttpStatus.NOT_FOUND);
        else
            return new ResponseEntity<>("پرسنلی با این کد ملی در سیستم پیدا نشد", HttpStatus.NOT_FOUND);
    }

    @Loggable
    @GetMapping(value = "/get-user-info")
//    @PreAuthorize("hasAuthority('r_personalInfo')")
    public ResponseEntity getUserInfo() {
        if (SecurityUtil.getNationalCode() == null)
            return new ResponseEntity<>(messageSource.getMessage("person.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.NOT_FOUND);
        return getOneByNationalCode(SecurityUtil.getNationalCode());
    }

    @GetMapping(value = "getParentEmployee/{personnelNationalCode}")
    public ResponseEntity<ISC<PersonnelDTO.Info>> getParentEmployee(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String personnelNationalCode) throws IOException {
        List<PersonnelDTO.Info> tempResult1 = modelMapper.map(masterDataService.getPersonByNationalCode(personnelNationalCode), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
        if (tempResult1 != null && tempResult1.size() != 0) {
            PersonnelDTO.Info tempResult2 = modelMapper.map(masterDataService.getParentEmployee(tempResult1.get(0).getId()), new TypeToken<PersonnelDTO.Info>() {
            }.getType());
            if (tempResult2 != null && tempResult2.getNationalCode() != null) {
                PersonnelDTO.Info result = modelMapper.map(personnelDAO.findByNationalCode(tempResult2.getNationalCode())[0], PersonnelDTO.Info.class);
                SearchDTO.SearchRs<PersonnelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
                searchRs.setList(new ArrayList<>());
                searchRs.getList().add(result);
                searchRs.setTotalCount((long) 1);
                return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
            } else
                return new ResponseEntity<>(null, HttpStatus.OK);
        } else
            return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @GetMapping(value = "getSiblingsEmployee/{personnelNationalCode}")
    public ResponseEntity<ISC<PersonnelDTO.Info>> getSiblingsEmployee(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String personnelNationalCode) throws IOException {
        List<PersonnelDTO.Info> tempResult1 = modelMapper.map(masterDataService.getPersonByNationalCode(personnelNationalCode), new TypeToken<List<PersonnelDTO.Info>>() {
        }.getType());
        if (tempResult1 != null && tempResult1.size() != 0) {
            List<PersonnelDTO.Info> tempResult2 = modelMapper.map(masterDataService.getSiblingsEmployee(tempResult1.get(0).getId()), new TypeToken<List<PersonnelDTO.Info>>() {
            }.getType());
            if (tempResult2 != null && tempResult2.size() != 0) {
                SearchDTO.SearchRs<PersonnelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
                searchRs.setList(new ArrayList<>());
                int count = 0;
                for (PersonnelDTO.Info info : tempResult2) {
                    PersonnelDTO.Info result = modelMapper.map(personnelDAO.findByNationalCode(info.getNationalCode())[0], PersonnelDTO.Info.class);
                    searchRs.getList().add(result);
                    count++;
                }
                searchRs.setTotalCount((long) count);
                return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
            } else
                return new ResponseEntity<>(null, HttpStatus.OK);
        } else
            return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @GetMapping(value = "getTraining/{trainorNationalCode}")
    public ResponseEntity<ISC<PersonnelDTO.Info>> getTraining(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String trainorNationalCode) throws IOException {
        Personnel[] tempResult = personnelDAO.findByNationalCode(trainorNationalCode);
        if (tempResult != null && tempResult.length != 0) {
            PersonnelDTO.Info result = modelMapper.map(tempResult[0], PersonnelDTO.Info.class);
            SearchDTO.SearchRs<PersonnelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(new ArrayList<>());
            searchRs.getList().add(result);
            searchRs.setTotalCount((long) 1);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
        } else
            return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @GetMapping(value = "getStudent/{studentNationalCode}")
    public ResponseEntity<ISC<PersonnelDTO.Info>> getStudent(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String studentNationalCode) throws IOException {
        Personnel[] tempResult = personnelDAO.findByNationalCode(studentNationalCode);
        if (tempResult != null && tempResult.length != 0) {
            PersonnelDTO.Info result = modelMapper.map(tempResult[0], PersonnelDTO.Info.class);
            SearchDTO.SearchRs<PersonnelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(new ArrayList<>());
            searchRs.getList().add(result);
            searchRs.setTotalCount((long) 1);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
        } else
            return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/personnelFullName/{id}")
    public ResponseEntity<String> personnelFullName(@PathVariable Long id) {
        String result = personnelDAO.getPersonnelFullName(id);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

}
