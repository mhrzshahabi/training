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
import com.nicico.training.model.*;
import com.nicico.training.repository.PersonalInfoDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.repository.TeacherDAO;
import com.nicico.training.service.TeacherService;
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
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.Charset;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacher")
public class TeacherRestController {

    private final TeacherService teacherService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final ICategoryService categoryService;
    private final ISubcategoryService subCategoryService;
    @Value("${nicico.dirs.upload-person-img}")
    private String personUploadDir;
    private final TeacherDAO teacherDAO;
    private final IAcademicBKService academicBKService;
    private final IEmploymentHistoryService employmentHistoryService;
    private final ITeachingHistoryService teachingHistoryService;
    private final ITeacherCertificationService teacherCertificationService;
    private final IPublicationService publicationService;
    private final IForeignLangKnowledgeService foreignLangService;
    private final TclassDAO tclassDAO;
    private final ITclassService tclassService;


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
        final Optional<Teacher> tById = teacherDAO.findByTeacherCode(request.get("teacherCode").toString());
        Teacher teacher = null;
        if(tById.isPresent())
         teacher = tById.get();
        if(teacher != null) {
            if (teacher.isInBlackList() == true)
                return new ResponseEntity<>("duplicateAndBlackList", HttpStatus.NOT_ACCEPTABLE);
            else if (teacher.isInBlackList() == false)
                return new ResponseEntity<>("duplicateAndNotBlackList", HttpStatus.NOT_ACCEPTABLE);
            else
                return new ResponseEntity<>("", HttpStatus.NOT_ACCEPTABLE);
        }
        else {
            List<CategoryDTO.Info> categories = null;
            List<SubcategoryDTO.Info> subCategories = null;

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
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_teacher')")
    public ResponseEntity update(@PathVariable Long id,@Validated @RequestBody LinkedHashMap request) {
        ((LinkedHashMap) request).remove("attachPic");

        List<CategoryDTO.Info> categories = null;
        List<SubcategoryDTO.Info> subCategories = null;

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
        List<Tclass> tclassList = tclassDAO.getTeacherClasses(id);
        if(tclassList != null && tclassList.size() != 0)
            return new ResponseEntity<>(tclassList.get(0).getTitleClass(), HttpStatus.NOT_ACCEPTABLE);
        else{
            try {
                teacherService.delete(id);
                return new ResponseEntity<>("ok", HttpStatus.OK);
            } catch (Exception e) {
                return new ResponseEntity<>("personalFail", HttpStatus.NOT_ACCEPTABLE);
            }
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
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "/info/{id}")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.Info> info(@PathVariable Long id)throws IOException {
        TeacherDTO.Info response = teacherService.get(id);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/spec-list-grid")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherSpecRsGrid> gridList(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                         @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                         @RequestParam(value = "id", required = false) Long id,
                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);
        request.setDistinct(true);
        SearchDTO.SearchRs<TeacherDTO.Grid> response = teacherService.deepSearchGrid(request);

        final TeacherDTO.SpecRsGrid specResponse = new TeacherDTO.SpecRsGrid();
        final TeacherDTO.TeacherSpecRsGrid specRs = new TeacherDTO.TeacherSpecRsGrid();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list-report")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherSpecRsReport> reportList(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                 @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                                 @RequestParam(value = "id", required = false) Long id,
                                                                 @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);
        request.setDistinct(true);

        List<Object> removedObjects = new ArrayList<>();
        Object evaluationCategory = null;
        Object evaluationSubCategory = null;
        Object evaluationGrade = null;
        Object teachingCategories = null;
        Object teachingSubCategories = null;
        for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
            if(criterion.getFieldName().equalsIgnoreCase("evaluationCategory")){
                evaluationCategory = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if(criterion.getFieldName().equalsIgnoreCase("evaluationSubCategory")){
                evaluationSubCategory = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if(criterion.getFieldName().equalsIgnoreCase("evaluationGrade")){
                evaluationGrade = criterion.getValue().get(0);
                removedObjects.add(criterion);
            }
            if(criterion.getFieldName().equalsIgnoreCase("teachingCategories")){
                teachingCategories = criterion.getValue();
                removedObjects.add(criterion);
            }
            if(criterion.getFieldName().equalsIgnoreCase("teachingSubCategories")){
                teachingSubCategories = criterion.getValue();
                removedObjects.add(criterion);
            }
        }

        for (Object removedObject : removedObjects) {
            request.getCriteria().getCriteria().remove(removedObject);
        }
        SearchDTO.SearchRs<TeacherDTO.Report> response = teacherService.deepSearchReport(request);

        List<TeacherDTO.Report> listRemovedObjects = new ArrayList<>();

        List<Integer> teaching_cats = null;
        List<Integer> teaching_subcats = null;

        if(teachingCategories != null) {
            teaching_cats = modelMapper.map(teachingCategories, List.class);
        }
        if(teachingSubCategories != null) {
            teaching_subcats = modelMapper.map(teachingSubCategories, List.class);
        }

        Float min_evalGrade = null;
        if(evaluationGrade != null)
           min_evalGrade = Float.parseFloat(evaluationGrade.toString());

        if(evaluationGrade!=null && evaluationCategory!=null && evaluationSubCategory!=null) {
            for (TeacherDTO.Report datum : response.getList()) {
                if (evaluationGrade != null) {
                    ResponseEntity<Float> t = evaluateTeacher(datum.getId(), evaluationCategory.toString(), evaluationSubCategory.toString());
                    Float teacher_evalGrade = t.getBody();
                    datum.setEvaluationGrade(""+teacher_evalGrade);
                    if (teacher_evalGrade < min_evalGrade)
                        listRemovedObjects.add(datum);
                }
            }
        }

        for (TeacherDTO.Report listRemovedObject : listRemovedObjects)
            response.getList().remove(listRemovedObject);
        listRemovedObjects.clear();

        if(teachingCategories!=null || teachingSubCategories!=null) {
            for (TeacherDTO.Report datum : response.getList()) {
                boolean relatedTeachingHistory = getRelatedTeachingHistory(datum, teaching_cats, teaching_subcats);
                if (relatedTeachingHistory == false)
                    listRemovedObjects.add(datum);
            }
        }
        for (TeacherDTO.Report listRemovedObject : listRemovedObjects)
            response.getList().remove(listRemovedObject);

        for (TeacherDTO.Report datum : response.getList()) {
            SearchDTO.SearchRq req = new SearchDTO.SearchRq();
            Long tId = datum.getId();
            SearchDTO.SearchRs<TclassDTO.TeachingHistory> resp = tclassService.searchByTeachingHistory(req, tId);
            datum.setNumberOfCourses(""+resp.getList().size());
            if(resp.getList() != null && resp.getList().size() > 0) {
                String startDate = resp.getList().get(0).getStartDate();
                for (TclassDTO.TeachingHistory teachingHistory : resp.getList()) {
                    if (teachingHistory.getStartDate().compareTo(startDate) > 0 || teachingHistory.getStartDate().compareTo(startDate)==0) {
                        datum.setLastCourse(teachingHistory.getCourse().getTitleFa());
                        datum.setLastCourseId(teachingHistory.getId());
                    }
                }
            }
        }
        for (TeacherDTO.Report datum : response.getList()) {
            if(datum.getLastCourse() != null)
                datum.setLastCourseEvaluationGrade(""+tclassService.getClassReactionEvaluationGrade(datum.getLastCourseId(),datum.getId()));
        }

        final TeacherDTO.SpecRsReport specResponse = new TeacherDTO.SpecRsReport();
        final TeacherDTO.TeacherSpecRsReport specRs = new TeacherDTO.TeacherSpecRsReport();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getList().size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    public Boolean getRelatedTeachingHistory(TeacherDTO.Report teacher, List<Integer> related_cats, List<Integer> related_subCats){
        Boolean relation = false;

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.SearchRs<TclassDTO.TeachingHistory> resp = tclassService.searchByTeachingHistory(request, teacher.getId());

        if(resp != null && resp.getList()!= null ) {
            for (TclassDTO.TeachingHistory teachingHistory : resp.getList()) {
                boolean thisTeachingHistoryRelation = true;
                Long teacher_cat = teachingHistory.getCourse().getCategoryId();
                Long teacher_subCat = teachingHistory.getCourse().getSubCategoryId();
                if (teacher_cat != null && related_cats != null) {
                    for (Integer related_cat : related_cats) {
                        if (teacher_cat != Long.parseLong("" + related_cat))
                            thisTeachingHistoryRelation = false;
                    }
                }
                if (teacher_subCat != null && related_subCats != null) {
                    for (Integer related_subCat : related_subCats) {
                        if (teacher_subCat != Long.parseLong("" + related_subCat))
                            thisTeachingHistoryRelation = false;
                    }
                }
                if (thisTeachingHistoryRelation == true)
                    relation = thisTeachingHistoryRelation;
            }
        }

        if(related_cats == null && related_subCats == null)
            relation = true;

        return relation;
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
                .setEndRow(startRow + response.getList().size())
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
                .setEndRow(startRow + response.getList().size())
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
        final SearchDTO.SearchRs<TeacherDTO.Info> searchRs = teacherService.deepSearch(searchRq);

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
        final TeacherDTO.Info teacherDTO = teacherService.get(Id);
        final Teacher teacher = modelMapper.map(teacherDTO, Teacher.class);

        if(teacherDTO.getPersonality().getPhoto() != null) {
            String fileName = personUploadDir + "/" + teacherDTO.getPersonality().getPhoto();
            File file = new File(fileName);
            params.put("personalImg", ImageIO.read(file));
        }
        if(teacherDTO.getPersonality().getPhoto() == null) {
            params.put("personalImg", ImageIO.read(getClass().getResourceAsStream("/reports/reportFiles/personal_photo.png")));
        }
        params.put("name",teacherDTO.getPersonality().getFirstNameFa() + " " + teacherDTO.getPersonality().getLastNameFa());
        params.put("personalNum",teacherDTO.getPersonnelCode());
        params.put("certificateNum", teacherDTO.getPersonality().getBirthCertificate());
        params.put("nationalCode", teacherDTO.getPersonality().getNationalCode());
        params.put("certificateLocation", teacherDTO.getPersonality().getBirthCertificateLocation());
        params.put("birthDate", teacherDTO.getPersonality().getBirthDate());
        params.put("birthLocation", teacherDTO.getPersonality().getBirthLocation());
        Integer genderId = teacherDTO.getPersonality().getGenderId();
        String gender = null;
        if(genderId == 1)
            gender = "مرد";
        if(genderId == 2)
            gender = "زن";
        params.put("gender", gender);
        Integer militaryId = teacherDTO.getPersonality().getMilitaryId();
        String military = null;
        if(militaryId == 1)
            military = "گذرانده";
        if(militaryId == 2)
            military = "معاف";
        if(militaryId == 3)
            military = "مشمول";
        if(genderId == 2)
            military = null;
        params.put("military", military);
        params.put("otherActivity", teacherDTO.getOtherActivities());
        String address = null;
        String connection = null;
        if(teacherDTO.getPersonality().getContactInfo() != null) {
            //connection
            if (teacherDTO.getPersonality().getContactInfo().getMobile() != null)
                connection += "تلفن: " +teacherDTO.getPersonality().getContactInfo().getMobile()+ " ";
            else if(teacherDTO.getPersonality().getContactInfo().getHomeAddress() != null)
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getPhone() != null)
                    connection += "تلفن: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getPhone()+ " ";
            if (teacherDTO.getPersonality().getContactInfo().getEmail() != null)
                connection += "پست الکترونیکی: " +teacherDTO.getPersonality().getContactInfo().getEmail()+ " ";
            if(teacherDTO.getPersonality().getContactInfo().getHomeAddress() != null)
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getFax() != null)
                    connection += "فاکس: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getFax()+ " ";
            //address
            if(teacherDTO.getPersonality().getContactInfo().getHomeAddress() != null) {
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getState() != null)
                    address +=  "استان: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getState().getName() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getCity() != null)
                    address += "شهر: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getCity().getName() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getPostalCode() != null)
                    address +=  "کد پستی: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getPostalCode() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getRestAddr() != null)
                    address += "ادامه ی آدرس: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getRestAddr() + " ";
            }
            else if(teacherDTO.getPersonality().getContactInfo().getWorkAddress() != null) {
                if(teacherDTO.getPersonality().getContactInfo().getWorkAddress().getState() != null)
                    address +=  "استان: " + teacherDTO.getPersonality().getContactInfo().getWorkAddress().getState().getName() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getWorkAddress().getCity() != null)
                    address += "شهر: " + teacherDTO.getPersonality().getContactInfo().getWorkAddress().getCity().getName() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getWorkAddress().getPostalCode() != null)
                    address +=  "کد پستی: " + teacherDTO.getPersonality().getContactInfo().getWorkAddress().getPostalCode() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getWorkAddress().getRestAddr() != null)
                    address += "ادامه ی آدرس: " + teacherDTO.getPersonality().getContactInfo().getWorkAddress().getRestAddr() + " ";
            }
        }
        params.put("address", address);
        params.put("connectionInfo", connection);
        String categories = null;
        List<Category> categoryList = teacher.getCategories();
        List<Subcategory> subCategoryList = teacher.getSubCategories();
        for (Category category : categoryList) {
            categories += category.getTitleFa() + " ";
            for (Subcategory subCategory : subCategoryList) {
                CategoryDTO.Info categoryDTO = subCategoryService.getCategory(subCategory.getId());
                if(categoryDTO.getId() == category.getId()) {
                    categories += subCategory.getTitleFa() + " ";
                }
            }
        }
        params.put("categories", categories);

        List<TeacherCertificationDTO.Info> teacherRelatedCertificate = new ArrayList<>();
        List<TeacherCertificationDTO.Info> teacherAllCertificate = searchRs_teacherCertification.getList();
        for (TeacherCertificationDTO.Info info : teacherAllCertificate) {
            boolean category_related = false;
            boolean subCategory_related = false;
            List<CategoryDTO.CategoryInfoTuple> certificationCategories = info.getCategories();
            List<SubcategoryDTO.SubCategoryInfoTuple> certificationSubCategories = info.getSubCategories();
            for (Category teacher_category : categoryList) {
                for(CategoryDTO.CategoryInfoTuple certificate_category : certificationCategories){
                    if(teacher_category.getId() == certificate_category.getId())
                        category_related = true;
                }
            }
            for (Subcategory teacher_sub_category : subCategoryList) {
                for(SubcategoryDTO.SubCategoryInfoTuple certificate_sub_category : certificationSubCategories){
                    if(teacher_sub_category.getId() == certificate_sub_category.getId())
                        subCategory_related = true;
                }
            }
            if(category_related && subCategory_related)
                teacherRelatedCertificate.add(info);
        }

        String data = "{" +
                "\"academicBK\": " + objectMapper.writeValueAsString(searchRs_academicBk.getList()) + "," +
                "\"empHistory\": " + objectMapper.writeValueAsString(searchRs_employmentHistory.getList()) + "," +
                "\"teachingHistory\": " + objectMapper.writeValueAsString(searchRs_teachingHistory.getList()) + "," +
                "\"teacherCertification\": " + objectMapper.writeValueAsString(teacherRelatedCertificate) + "," +
                "\"publication\": " + objectMapper.writeValueAsString(searchRs_publication.getList()) + "," +
                "\"languages\": " + objectMapper.writeValueAsString(searchRs_foreingLang.getList())  +
                 "}";

        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/TeacherWithDetail.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @PostMapping(value = {"/printEvaluation/{id}/{catId}/{subCatId}"})
    public void printEvaluation(HttpServletResponse response,@PathVariable String id, @PathVariable String catId, @PathVariable String subCatId) throws Exception {
        final Map<String, Object> params = new HashMap<>();

        Long Id = Long.valueOf(id);
        final TeacherDTO.Info teacherDTO = teacherService.get(Id);

        String name = null;
        String personalNum = null;
        String categories = null;
        String address = null;
        String phone = null;

        Map<String,Object> resultSet = teacherService.evaluateTeacher(Id,catId,subCatId);

        name = teacherDTO.getPersonality().getFirstNameFa() + " " + teacherDTO.getPersonality().getLastNameFa();
        personalNum = teacherDTO.getPersonnelCode();
        String categoryName = null;
        String subCategoryName = null;
        if(!catId.equalsIgnoreCase("undefined")) {
            CategoryDTO.Info category = categoryService.get(Long.valueOf(catId));
            categoryName = category.getTitleFa();
        }
        if(!subCatId.equalsIgnoreCase("undefined")) {
            SubcategoryDTO.Info subCategory = subCategoryService.get(Long.valueOf(subCatId));
            subCategoryName = subCategory.getTitleFa();
        }
        categories = categoryName + " " + subCategoryName;
        if(teacherDTO.getPersonality().getContactInfo() != null) {
            //phone
            if (teacherDTO.getPersonality().getContactInfo().getMobile() != null)
                phone = teacherDTO.getPersonality().getContactInfo().getMobile();
            else if(teacherDTO.getPersonality().getContactInfo().getHomeAddress() != null)
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getPhone() != null)
                    phone = teacherDTO.getPersonality().getContactInfo().getHomeAddress().getPhone();
           //address
            if(teacherDTO.getPersonality().getContactInfo().getHomeAddress() != null) {
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getState() != null)
                    address +=  "استان: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getState().getName() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getCity() != null)
                    address += "شهر: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getCity().getName() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getPostalCode() != null)
                    address +=  "کد پستی: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getPostalCode() + " ";
                if(teacherDTO.getPersonality().getContactInfo().getHomeAddress().getRestAddr() != null)
                    address += "ادامه ی آدرس: " + teacherDTO.getPersonality().getContactInfo().getHomeAddress().getRestAddr() + " ";
            }
        }

        params.put("name",name);
        params.put("personalNum",personalNum);
        params.put("address", address);
        params.put("phone", phone);
        params.put("categories",categories);
        params.put("totalGrade", resultSet.get("evaluationGrade"));
        params.put("status", resultSet.get("pass_status"));
        params.put("table1Grade", resultSet.get("table_1_grade"));
        params.put("tbl1License", resultSet.get("table_1_license"));
        params.put("tbl1Work", resultSet.get("table_1_work"));
        params.put("tbl1ReTraining", resultSet.get("table_1_related_training"));
        params.put("tbl1UnReTraining", resultSet.get("table_1_unRelated_training"));
        params.put("tbl1Courses", resultSet.get("table_1_courses"));
        params.put("tbl1Years", resultSet.get("table_1_years"));
        params.put("tbl1ReTrH", resultSet.get("table_1_related_training_hours"));
        params.put("tbl1UReTrH", resultSet.get("table_1_unRelated_training_hours"));
        params.put("table2Grade", resultSet.get("table_2_grade"));
        params.put("table3Grade", resultSet.get("table_3_grade"));
        params.put("table3Book", resultSet.get("table_3_count_book"));
        params.put("table3Project", resultSet.get("table_3_count_project"));
        params.put("table3Article", resultSet.get("table_3_count_article"));
        params.put("table3Translation", resultSet.get("table_3_count_translation"));
        params.put("table3Note", resultSet.get("table_3_count_note"));
        params.put("table4Grade", resultSet.get("table_4_grade"));

        String data = "{" + "\"content\": " + null + "}";

        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/TeacherEvaluation.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = "/evaluateTeacher/{id}/{catId}/{subCatId}")
    public ResponseEntity<Float> evaluateTeacher(@PathVariable Long id,@PathVariable String catId,@PathVariable String subCatId) throws IOException {
       Float evaluationGrade = (Float) teacherService.evaluateTeacher(id,catId,subCatId).get("evaluationGrade");
       return new ResponseEntity<>(evaluationGrade,HttpStatus.OK);
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

    private List<SubcategoryDTO.Info> setSubCats(LinkedHashMap request) {
        SearchDTO.SearchRq subCategoriesRequest = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(EOperator.inSet);
        criteriaRq.setFieldName("id");
        criteriaRq.setValue(request.get("subCategories"));
        subCategoriesRequest.setCriteria(criteriaRq);
        List<SubcategoryDTO.Info> subCategories = subCategoryService.search(subCategoriesRequest).getList();
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
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/all-students-grade-to-teacher")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> getAllStudentsGradeToTeacher(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                             @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                             @RequestParam(value = "_constructor", required = false) String constructor,
                                                             @RequestParam(value = "operator", required = false) String operator,
                                                             @RequestParam(value = "criteria", required = false) String criteria,
                                                             @RequestParam(value = "teacherId", required = true) Long teacherId,
                                                             @RequestParam(value = "courseId", required = true) Long courseId) throws IOException {
        List<TclassDTO.AllStudentsGradeToTeacher> list = teacherService.getAllStudentsGradeToTeacher(courseId, teacherId);
        final TeacherDTO.SpecRs specResponse = new TeacherDTO.SpecRs();
        final TeacherDTO.TeacherSpecRs specRs = new TeacherDTO.TeacherSpecRs();
        specResponse.setData(list)
                .setStartRow(startRow)
                .setEndRow(list.size())
                .setTotalRows(list.size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/blackList/{inBlackList}/{id}")
//    @PreAuthorize("hasAuthority('r_teacher')")
    public void changeBlackListStatus(HttpServletRequest req, @PathVariable Boolean inBlackList, @PathVariable Long id) {
        String reason=req.getParameter("reason");
        teacherService.changeBlackListStatus(reason,inBlackList,id);
    }

}