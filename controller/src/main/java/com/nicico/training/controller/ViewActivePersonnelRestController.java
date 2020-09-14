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
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.Post;
import com.nicico.training.model.ViewActivePersonnel;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.repository.ViewActivePersonnelDAO;
import com.nicico.training.service.CourseService;
import com.nicico.training.service.MasterDataService;
import com.nicico.training.service.ViewActivePersonnelService;
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
@RequestMapping("/api/view_active_personnel/")
public class ViewActivePersonnelRestController {

    final ObjectMapper objectMapper;
    final CourseService courseService;
    final DateUtil dateUtil;
    final ReportUtil reportUtil;
    private final MessageSource messageSource;
    private final ViewActivePersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final ModelMapper modelMapper;
    private final ViewActivePersonnelDAO viewActivePersonnelDAO;
    private final PostDAO postDAO;

    @GetMapping("list")
    public ResponseEntity<List<ViewActivePersonnelDTO.Info>> list() {
        return new ResponseEntity<>(personnelService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "iscList")
    public ResponseEntity<ISC<ViewActivePersonnelDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        return new ResponseEntity<>(ISC.convertToIscRs(personnelService.search(searchRq), searchRq.getStartIndex()), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "checkPersonnelNos")
    public ResponseEntity<List<ViewActivePersonnelDTO.Info>> checkPersonnelNos(@RequestBody List<String> personnelNos) {
        List<ViewActivePersonnelDTO.Info> list = personnelService.checkPersonnelNos(personnelNos);
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/byPostCode/{postId}")
    public ResponseEntity<ViewActivePersonnelDTO.PersonnelSpecRs> findPersonnelByPostCode(@PathVariable Long postId) {
        List<ViewActivePersonnelDTO.Info> list = personnelService.getByPostCode(postId);
        final ViewActivePersonnelDTO.SpecRs specResponse = new ViewActivePersonnelDTO.SpecRs();
        final ViewActivePersonnelDTO.PersonnelSpecRs specRs = new ViewActivePersonnelDTO.PersonnelSpecRs();

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
    public ResponseEntity<ViewActivePersonnelDTO.PersonnelSpecRs> findPersonnelByJobNo(@PathVariable String jobNo) {

        List<ViewActivePersonnelDTO.Info> list = personnelService.getByJobNo(jobNo);

        final ViewActivePersonnelDTO.SpecRs specResponse = new ViewActivePersonnelDTO.SpecRs();
        final ViewActivePersonnelDTO.PersonnelSpecRs specRs = new ViewActivePersonnelDTO.PersonnelSpecRs();

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
    public ResponseEntity<ViewActivePersonnelDTO.PersonalityInfo> findPersonnelByPersonnelCode(@PathVariable String personnelCode) {
        ViewActivePersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByPersonnelCode(personnelCode);
        return new ResponseEntity<>(personalInfoDTO, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/byNationalCode/{nationalCode}")
    public ResponseEntity<ViewActivePersonnelDTO.PersonalityInfo> findPersonnelByNationalCode(@PathVariable String nationalCode) {
        ViewActivePersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByNationalCode(nationalCode);
        return new ResponseEntity<>(personalInfoDTO, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/byId/{id}")
    public ResponseEntity<ViewActivePersonnel> findPersonnelById(@PathVariable Long id) {
        ViewActivePersonnel personalInfo = viewActivePersonnelDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return new ResponseEntity<>(personalInfo, HttpStatus.OK);
    }

    @GetMapping("/statisticalReport/{reportType}")
    public ResponseEntity<ViewActivePersonnelDTO.PersonnelSpecRs> findAllStatisticalReport(@PathVariable String reportType) {
        List<ViewActivePersonnelDTO.Info> list = personnelService.findAllStatisticalReportFilter(reportType);

        final ViewActivePersonnelDTO.SpecRs specResponse = new ViewActivePersonnelDTO.SpecRs();
        final ViewActivePersonnelDTO.PersonnelSpecRs specRs = new ViewActivePersonnelDTO.PersonnelSpecRs();

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
    public ResponseEntity<ViewActivePersonnel> findPersonnelByPersonnelId(@PathVariable Long personnelId, @PathVariable String personnelNo) {
        return new ResponseEntity<>(personnelService.findPersonnelByPersonnelId(personnelId, personnelNo), HttpStatus.OK);
    }

    @GetMapping("/all-field-values")
    public ResponseEntity<ISC<ViewActivePersonnelDTO.FieldValue>> findAllValuesOfOneFieldFromPersonnel(@RequestParam String fieldName) {
        return new ResponseEntity<>(ISC.convertToIscRs(personnelService.findAllValuesOfOneFieldFromPersonnel(fieldName), 0), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/getOneByNationalCode/{nationalCode}")
    public ResponseEntity getOneByNationalCode(@PathVariable String nationalCode) {
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(makeNewCriteria("active", 1, EOperator.equals, null));
        criteria.getCriteria().add(makeNewCriteria("nationalCode", nationalCode, EOperator.equals, null));
        List<ViewActivePersonnelDTO.Info> personnelList = personnelService.search(new SearchDTO.SearchRq().setCriteria(criteria)).getList();
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
    public ResponseEntity getUserInfo() {
        if (SecurityUtil.getNationalCode() == null)
            return new ResponseEntity<>(messageSource.getMessage("person.not.found", null, LocaleContextHolder.getLocale()), HttpStatus.NOT_FOUND);
        return getOneByNationalCode(SecurityUtil.getNationalCode());
    }

    @Loggable
    @GetMapping(value = "/personnelFullName/{id}")
    public ResponseEntity<String> personnelFullName(@PathVariable Long id){
        String result =  viewActivePersonnelDAO.getPersonnelFullName(id);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }


    //---------------------------------------------------------------------------------------------------------------//

    @GetMapping(value = "getParentEmployee/{personnelNationalCode}")
    @Transactional
    public ResponseEntity<ISC<ViewActivePersonnelDTO.Info>> getParentEmployee(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String personnelNationalCode) throws IOException {
        ViewActivePersonnel[] personnelArray = viewActivePersonnelDAO.findByNationalCode(personnelNationalCode);
        if (personnelArray != null && personnelArray.length != 0) {
            ViewActivePersonnel personnel = personnelArray[0];
            Optional<Post> optional = postDAO.findById(personnel.getPostId());
            Post personnelPost = null;
            if(optional.isPresent())
                personnelPost = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            ViewActivePersonnelDTO.Info finalResult = null;
            if(personnelPost.getParentID() != null) {
                ViewActivePersonnel result = viewActivePersonnelDAO.findFirstByPostId(personnelPost.getParentID());
                if (result != null)
                    finalResult = modelMapper.map(result, ViewActivePersonnelDTO.Info.class);
            }
            SearchDTO.SearchRs<ViewActivePersonnelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(new ArrayList<>());
            searchRs.getList().add(finalResult);
            searchRs.setTotalCount((long) 1);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
        } else
            return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @GetMapping(value = "getSiblingsEmployee/{personnelNationalCode}")
    public ResponseEntity<ISC<ViewActivePersonnelDTO.Info>> getSiblingsEmployee(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String personnelNationalCode) throws IOException {
        ViewActivePersonnel[] personnelArray = viewActivePersonnelDAO.findByNationalCode(personnelNationalCode);
        if (personnelArray != null && personnelArray.length != 0) {
            ViewActivePersonnel personnel = personnelArray[0];
            Optional<Post> optional = postDAO.findById(personnel.getPostId());
            Post personnelPost = null;
            if (optional.isPresent())
                personnelPost = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            List<Post> siblingsPost = postDAO.findByParentID(personnelPost.getParentID());
            List<ViewActivePersonnel> result = new ArrayList<>();
            for (Post post : siblingsPost) {
                ViewActivePersonnel personnel1 = viewActivePersonnelDAO.findFirstByPostId(post.getId());
                if (personnel1 != null && !personnel1.getNationalCode().equalsIgnoreCase(personnelNationalCode))
                    result.add(personnel1);
            }

            if (result != null && result.size() != 0) {
                int count = 0;
                SearchDTO.SearchRs<ViewActivePersonnelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
                searchRs.setList(new ArrayList<>());
                for (ViewActivePersonnel info : result) {
                    searchRs.getList().add(modelMapper.map(info, ViewActivePersonnelDTO.Info.class));
                    count++;
                }
                searchRs.setTotalCount((long) count);
                return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
            }
            else
                return new ResponseEntity<>(null, HttpStatus.OK);

        }else
                return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @GetMapping(value = "getTraining/{trainorNationalCode}")
    public ResponseEntity<ISC<ViewActivePersonnelDTO.Info>> getTraining(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String trainorNationalCode) throws IOException {
        ViewActivePersonnel[] tempResult = viewActivePersonnelDAO.findByNationalCode(trainorNationalCode);
        if (tempResult != null && tempResult.length != 0) {
            ViewActivePersonnelDTO.Info result = modelMapper.map(tempResult[0], ViewActivePersonnelDTO.Info.class);
            SearchDTO.SearchRs<ViewActivePersonnelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(new ArrayList<>());
            searchRs.getList().add(result);
            searchRs.setTotalCount((long) 1);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
        } else
            return new ResponseEntity<>(null, HttpStatus.OK);
    }

    @GetMapping(value = "getStudent/{studentNationalCode}")
    public ResponseEntity<ISC<ViewActivePersonnelDTO.Info>> getStudent(@RequestParam MultiValueMap<String, String> criteria, @PathVariable String studentNationalCode) throws IOException {
        ViewActivePersonnel[] tempResult = viewActivePersonnelDAO.findByNationalCode(studentNationalCode);
        if (tempResult != null && tempResult.length != 0) {
            ViewActivePersonnelDTO.Info result = modelMapper.map(tempResult[0], ViewActivePersonnelDTO.Info.class);
            SearchDTO.SearchRs<ViewActivePersonnelDTO.Info> searchRs = new SearchDTO.SearchRs<>();
            searchRs.setList(new ArrayList<>());
            searchRs.getList().add(result);
            searchRs.setTotalCount((long) 1);
            return new ResponseEntity<>(ISC.convertToIscRs(searchRs, 0), HttpStatus.OK);
        }
        else
            return new ResponseEntity<>(null, HttpStatus.OK);
    }

}
