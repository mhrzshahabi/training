package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeacherCertification;
import com.nicico.training.repository.PersonalInfoDAO;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacher")
public class TeacherRestController {

    private final ITeacherService teacherService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final ICategoryService categoryService;
    private final ISubCategoryService subCategoryService;
    @Value("${nicico.dirs.upload-person-img}")
    private String personUploadDir;
    private final PersonalInfoDAO personalInfoDAO;
    private final IAcademicBKService academicBKService;
    private final IEmploymentHistoryService employmentHistoryService;
    private final ITeachingHistoryService teachingHistoryService;
    private final ITeacherCertificationService teacherCertificationService;
    private final IPublicationService publicationService;
    private final IForeignLangKnowledgeService foreignLangService;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(teacherService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<List<TeacherDTO.Info>> list() {
        return new ResponseEntity<>(teacherService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_teacher')")
    public ResponseEntity create(@Validated @RequestBody LinkedHashMap request) {
        List<CategoryDTO.Info> categories = null;
        List<SubCategoryDTO.Info> subCategories = null;

        if (request.get("categories") != null)
            categories = setCats(request);
        if (request.get("subCategories") != null)
            subCategories = setSubCats(request);
        TeacherDTO.Create create = modelMapper.map(request, TeacherDTO.Create.class);
        if (categories != null && categories.size() > 0)
            create.setCategories(categories);
        if (subCategories != null && subCategories.size() > 0)
            create.setSubCategories(subCategories);
        create.setInBlackList(false);
        try {
            return new ResponseEntity<>(teacherService.create(create), HttpStatus.CREATED);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_teacher')")
    public ResponseEntity update(@PathVariable Long id,@Validated @RequestBody LinkedHashMap request) {
        ((LinkedHashMap) request).remove("attachPic");

        List<CategoryDTO.Info> categories = null;
        List<SubCategoryDTO.Info> subCategories = null;

        if (request.get("categories") != null)
            categories = setCats(request);
        if (request.get("subCategories") != null)
            subCategories = setSubCats(request);

        TeacherDTO.Update update = modelMapper.map(request, TeacherDTO.Update.class);
        if (categories != null && categories.size() > 0)
            update.setCategories(categories);
        if (subCategories != null && subCategories.size() > 0)
            update.setSubCategories(subCategories);
        try {
            return new ResponseEntity<>(teacherService.update(id, update), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_teacher')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            teacherService.delete(id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }


    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_teacher')")
    public ResponseEntity delete(@Validated @RequestBody TeacherDTO.Delete request) {
        try {
            teacherService.delete(request);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> list(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                         @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                         @RequestParam(value = "id", required = false) Long id,
                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);

        SearchDTO.SearchRs<TeacherDTO.Info> response = teacherService.deepSearch(request);

        final TeacherDTO.SpecRs specResponse = new TeacherDTO.SpecRs();
        final TeacherDTO.TeacherSpecRs specRs = new TeacherDTO.TeacherSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/fullName-list")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherFullNameSpecRs> fullNameList(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", required = false, defaultValue = "50") Integer endRow,
                                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                                         @RequestParam(value = "operator", required = false) String operator,
                                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                                         @RequestParam(value = "id", required = false) Long id,
                                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);

        SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> response = teacherService.fullNameSearch(request);

        final TeacherDTO.FullNameSpecRs specResponse = new TeacherDTO.FullNameSpecRs();
        final TeacherDTO.TeacherFullNameSpecRs specRs = new TeacherDTO.TeacherFullNameSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/fullName-list/{id}")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherFullNameSpecRs> fullNameListFilter(@PathVariable Long id,
                                                                               @RequestParam("_startRow") Integer startRow,
                                                                               @RequestParam("_endRow") Integer endRow,
                                                                               @RequestParam(value = "_constructor", required = false) String constructor,
                                                                               @RequestParam(value = "operator", required = false) String operator,
                                                                               @RequestParam(value = "criteria", required = false) String criteria,
                                                                               @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, null, sortBy);

        SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> response = teacherService.fullNameSearch(request);

        final TeacherDTO.FullNameSpecRs specResponse = new TeacherDTO.FullNameSpecRs();
        final TeacherDTO.TeacherFullNameSpecRs specRs = new TeacherDTO.TeacherFullNameSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<SearchDTO.SearchRs<TeacherDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(teacherService.search(request), HttpStatus.OK);
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

        final SearchDTO.SearchRs<TeacherDTO.Info> searchRs = teacherService.search(searchRq);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/TeacherByCriteria.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @PostMapping(value = {"/printWithDetail/{id}"})
    public void printWithDetail(HttpServletResponse response,@PathVariable String id) throws Exception {
//        final SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
//        final SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
//        criteriaRq1.setFieldName("id");
//        criteriaRq1.setOperator(EOperator.equals);
//        criteriaRq1.setValue(id);
//        List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
//        criteriaRqList.add(criteriaRq1);
//        criteriaRq.setOperator(EOperator.and);
//        criteriaRq.setCriteria(criteriaRqList);
//        final SearchDTO.SearchRq searchRq;
//        searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
//        final SearchDTO.SearchRs<TeacherDTO.Info> searchRs = teacherService.search(searchRq);


        final SearchDTO.SearchRq searchRq_academicBk = new SearchDTO.SearchRq();
        final SearchDTO.SearchRs<AcademicBKDTO.Info> searchRs_academicBk = academicBKService.search(searchRq_academicBk, Long.valueOf(id));

        final SearchDTO.SearchRq searchRq_employmentHistory = new SearchDTO.SearchRq();
        final SearchDTO.SearchRs<EmploymentHistoryDTO.Info> searchRs_employmentHistory = employmentHistoryService.search(searchRq_employmentHistory, Long.valueOf(id));

        final SearchDTO.SearchRq searchRq_teachingHistory = new SearchDTO.SearchRq();
        final SearchDTO.SearchRs<TeachingHistoryDTO.Info> searchRs_teachingHistory = teachingHistoryService.search(searchRq_teachingHistory, Long.valueOf(id));

        final SearchDTO.SearchRq searchRq_teacherCertification = new SearchDTO.SearchRq();
        final SearchDTO.SearchRs<TeacherCertificationDTO.Info> searchRs_teacherCertification = teacherCertificationService.search(searchRq_teacherCertification, Long.valueOf(id));

        final SearchDTO.SearchRq searchRq_publication = new SearchDTO.SearchRq();
        final SearchDTO.SearchRs<PublicationDTO.Info> searchRs_publication = publicationService.search(searchRq_publication, Long.valueOf(id));

        final SearchDTO.SearchRq searchRq_foreingLang = new SearchDTO.SearchRq();
        final SearchDTO.SearchRs<ForeignLangKnowledgeDTO.Info> searchRs_foreingLang = foreignLangService.search(searchRq_foreingLang, Long.valueOf(id));


        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        Long Id = Long.valueOf(id);
        final Teacher teacher = teacherService.getTeacher(Id);
        final Optional<PersonalInfo> cById = personalInfoDAO.findById(teacher.getPersonalityId());
        final PersonalInfo personalInfo = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        String fileName = personUploadDir + "/" + personalInfo.getPhoto();
        File file = new File(fileName);
        params.put("personalImg",  ImageIO.read(file));

        params.put("name",personalInfo.getFirstNameFa() + " " + personalInfo.getLastNameFa());
        params.put("personalNum",teacher.getPersonnelCode());
        params.put("certificateNum", personalInfo.getBirthCertificate());
        params.put("nationalCode", personalInfo.getNationalCode());
        params.put("certificateLocation", personalInfo.getBirthCertificateLocation());
        params.put("birthDate", personalInfo.getBirthDate());
        params.put("birthLocation", personalInfo.getBirthLocation());
        params.put("gender", personalInfo.getGender().getTitleFa());
        params.put("military", personalInfo.getMilitary().getTitleFa());
        params.put("address", "");
        params.put("connectionInfo", "");
        params.put("categories", "");
        params.put("otherActivity", "");

        String data = "{" +
                    "\"content\": " + objectMapper.writeValueAsString(searchRs_teachingHistory.getList()) + "," +
                    "\"academicBK\": " + objectMapper.writeValueAsString(searchRs_academicBk.getList()) + "," +
                "\"empHistory\": " + objectMapper.writeValueAsString(searchRs_employmentHistory.getList()) + "," +
                "\"teachingHistory\": " + objectMapper.writeValueAsString(searchRs_teachingHistory.getList()) + "," +
                "\"teacherCertification\": " + objectMapper.writeValueAsString(searchRs_teacherCertification.getList()) + "," +
                "\"publication\": " + objectMapper.writeValueAsString(searchRs_publication.getList()) + "," +
                "\"languages\": " + objectMapper.writeValueAsString(searchRs_foreingLang.getList())  +
                 "}";

        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/TeacherWithDetail.jasper", params, jsonDataSource, response);
    }

    private SearchDTO.SearchRq setSearchCriteria(@RequestParam(value = "_startRow", required = false) Integer startRow,
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
        return request;
    }


    private List<CategoryDTO.Info> setCats(LinkedHashMap request) {
        SearchDTO.SearchRq categoriesRequest = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.inSet);
        criteriaRq.setFieldName("id");
        criteriaRq.setValue(request.get("categories"));
        categoriesRequest.setCriteria(criteriaRq);
        List<CategoryDTO.Info> categories = categoryService.search(categoriesRequest).getList();
        request.remove("categories");
        return categories;

    }

    private List<SubCategoryDTO.Info> setSubCats(LinkedHashMap request) {
        SearchDTO.SearchRq subCategoriesRequest = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.inSet);
        criteriaRq.setFieldName("id");
        criteriaRq.setValue(request.get("subCategories"));
        subCategoriesRequest.setCriteria(criteriaRq);
        List<SubCategoryDTO.Info> subCategories = subCategoryService.search(subCategoriesRequest).getList();
        request.remove("subCategories");
        return subCategories;
    }

    @Loggable
    @GetMapping(value = "/full-spec-list")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> fullList(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                         @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                         @RequestParam(value = "id", required = false) Long id,
                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);

        SearchDTO.SearchRs<TeacherDTO.Info> response = teacherService.search(request);

        final TeacherDTO.SpecRs specResponse = new TeacherDTO.SpecRs();
        final TeacherDTO.TeacherSpecRs specRs = new TeacherDTO.TeacherSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/blackList/{inBlackList}/{id}")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public void changeBlackListStatus(@PathVariable Boolean inBlackList, @PathVariable Long id) {
        teacherService.changeBlackListStatus(inBlackList,id);
    }

    @Loggable
    @GetMapping(value = "/evaluateTeacher/{id}/{catId}/{subCatId}")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<Long> evaluateTeacher(@PathVariable Long id,@PathVariable String catId,@PathVariable String subCatId) throws IOException {
        Long evaluationGrade = null;
        Long CatId = null;
        Long SubCatId = null;
        CatId = Long.parseLong(catId);
        if(!subCatId.equalsIgnoreCase("undefined"))
            SubCatId = Long.parseLong(subCatId);
        TeacherDTO.Info teacherDTO = teacherService.get(id);

        return new ResponseEntity<>(evaluationGrade,HttpStatus.OK);
    }



}