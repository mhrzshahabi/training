package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import response.evaluation.dto.EvalAverageResult;

import javax.imageio.ImageIO;
import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.text.DecimalFormat;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

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
    private final ISubcategoryService subCategoryService;
    @Value("${nicico.dirs.upload-person-img}")
    private String personUploadDir;
    private final ITeacherService iTeacherService;
    private final IAcademicBKService academicBKService;
    private final IEmploymentHistoryService employmentHistoryService;
    private final ITeachingHistoryService teachingHistoryService;
    private final ITeacherCertificationService teacherCertificationService;
    private final IPublicationService publicationService;
    private final IForeignLangKnowledgeService foreignLangService;
    private final ITclassService tclassService;
    @Autowired
    protected EntityManager entityManager;
    private final IViewTeacherReportService iViewTeacherReportService;
    private final ITeacherRoleService iTeacherRoleService;
    private static final DecimalFormat df = new DecimalFormat("0.00");

    @Loggable
    @GetMapping(value = "/{id}")
    //@PreAuthorize("hasAuthority('Teacher_R')")
    public ResponseEntity<TeacherDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(teacherService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    //@PreAuthorize("hasAuthority('Teacher_R')")
    public ResponseEntity<List<TeacherDTO.Info>> list() {
        return new ResponseEntity<>(teacherService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    //@PreAuthorize("hasAuthority('Teacher_C')")
    public ResponseEntity create(@Validated @RequestBody LinkedHashMap request) {
        final Optional<Teacher> tById = iTeacherService.findByTeacherCode(request.get("teacherCode").toString());
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
                TeacherDTO.Info info = teacherService.create(create);
                if (request.get("role") != null && !((List)request.get("role")).isEmpty()) {
                    String nationalCode = teacherService.getTeacherNationalCodeById(info.getId());
                    ArrayList<Integer> roles = (ArrayList<Integer>) request.get("role");
                    for (Integer role : roles) {
                        iTeacherRoleService.addRoleByNationalCode(nationalCode, Long.valueOf(role));
                    }
                }
                return new ResponseEntity<>(info, HttpStatus.CREATED);
            } catch (TrainingException ex) {
                return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
            }
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
    //@PreAuthorize("hasAuthority('Teacher_U')")
    public ResponseEntity update(@PathVariable Long id,@Validated @RequestBody LinkedHashMap request) {
        final Optional<Teacher> tById = iTeacherService.findByTeacherCode(request.get("teacherCode").toString());
        Teacher teacher = null;
        if(tById.isPresent())
            teacher = tById.get();
        if(teacher != null && !teacher.getId().equals(id)) {
            if (teacher.isInBlackList() == true)
                return new ResponseEntity<>("duplicateAndBlackList", HttpStatus.NOT_ACCEPTABLE);
            else
                return new ResponseEntity<>("duplicateAndNotBlackList", HttpStatus.NOT_ACCEPTABLE);
        }
        else {
            ((LinkedHashMap) request).remove("attachPic");

            List<CategoryDTO.Info> categories = null;
            List<SubcategoryDTO.Info> subCategories = null;

            if (request.get("categories") != null && !((List) request.get("categories")).isEmpty())
                categories = setCats(request);
            if (request.get("subCategories") != null && !((List) request.get("subCategories")).isEmpty())
                subCategories = setSubCats(request);

            TeacherDTO.Update update = modelMapper.map(request, TeacherDTO.Update.class);
            if (categories != null && categories.size() > 0)
                update.setCategories(categories);
            if (subCategories != null && subCategories.size() > 0)
                update.setSubCategories(subCategories);
            try {
                TeacherDTO.Info info = teacherService.update(id, update);

                List<Role> roles = iTeacherRoleService.findAllRoleByTeacherId(teacher.getId());
                List<Long> roleIds = roles.stream().map(Role::getId).collect(Collectors.toList());
                if (request.get("role") != null && !((List)request.get("role")).isEmpty()) {
                    String nationalCode = teacherService.getTeacherNationalCodeById(teacher.getId());
                    List<Long> newRoleIds = objectMapper.convertValue(request.get("role"), new TypeReference<List<Long>>() {
                    });
                    for (Long roleId : roleIds) {
                        if (!newRoleIds.contains(roleId))
                            iTeacherRoleService.removeTeacherRole(nationalCode, roleId);
                    }
                    for (Long newRoleId : newRoleIds) {
                        if (!roleIds.contains(newRoleId))
                            iTeacherRoleService.addRoleByNationalCode(nationalCode, newRoleId);
                    }
                } else {
                    iTeacherRoleService.removeRolesByTeacherId(teacher.getId(), roles.stream().map(Role::getName).collect(Collectors.toList()));
                }

                return new ResponseEntity<>(info, HttpStatus.OK);
            } catch (TrainingException ex) {
                return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
            }
        }
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    //@PreAuthorize("hasAuthority('Teacher_D')")
    public ResponseEntity delete(@PathVariable Long id) {
        List<Tclass> tclassList = tclassService.getTeacherClasses(id);
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
    //@PreAuthorize("hasAuthority('Teacher_D')")
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
    //@PreAuthorize("hasAuthority('Teacher_R')")
    public ResponseEntity<TeacherDTO.TeacherSpecRs> list(@RequestParam(value = "_startRow", required = false,defaultValue = "0") Integer startRow,
                                                         @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                         @RequestParam(value = "operator", required = false) String operator,
                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                         @RequestParam(value = "id", required = false) Long id,
                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException, NoSuchFieldException, IllegalAccessException {

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
    //@PreAuthorize("hasAuthority('Teacher_R')")
    public ResponseEntity<TeacherDTO.Info> info(@PathVariable Long id) {
        TeacherDTO.Info response = teacherService.get(id);
        List<Long> roleIds = iTeacherRoleService.findAllRoleByTeacherId(id).stream().map(Role::getId).collect(Collectors.toList());
        response.setRoles(roleIds);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/spec-list-grid")
    //@PreAuthorize("hasAuthority('Teacher_R')")
    public ResponseEntity<TeacherDTO.TeacherSpecRsGrid> gridList(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                 @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                                 @RequestParam(value = "id", required = false) Long id,
                                                                 @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq request = setSearchCriteriaNotInBlackList(startRow, endRow, constructor, operator, criteria, id, sortBy);

        for (SearchDTO.CriteriaRq o : request.getCriteria().getCriteria()) {
            if(o.getFieldName().equalsIgnoreCase("categories"))
                o.setValue(Long.parseLong(o.getValue().get(0)+""));
            if(o.getFieldName().equalsIgnoreCase("subCategories"))
                o.setValue(Long.parseLong(o.getValue().get(0)+""));
            if(o.getFieldName().equalsIgnoreCase("personnelStatus")) {
                if (o.getValue().get(0).equals("false")){
                    o.setValue(0);
                } else if (o.getValue().get(0).equals("true")){
                    o.setValue(1);
                }
            }

        }

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
    @GetMapping(value = "/spec-list-satisfaction")
    //@PreAuthorize("hasAuthority('Teacher_R')")
    public ResponseEntity<TeacherDTO.TeacherSpecRsGrid> gridListSatisfaction(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                 @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                                 @RequestParam(value = "id", required = false) Long id,
                                                                 @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq request = setSearchCriteriaNotInBlackList(startRow, endRow, constructor, operator, criteria, id, sortBy);

        for (SearchDTO.CriteriaRq o : request.getCriteria().getCriteria()) {
            if(o.getFieldName().equalsIgnoreCase("categories"))
                o.setValue(Long.parseLong(o.getValue().get(0)+""));
            if(o.getFieldName().equalsIgnoreCase("subCategories"))
                o.setValue(Long.parseLong(o.getValue().get(0)+""));
            if(o.getFieldName().equalsIgnoreCase("personnelStatus")) {
                if (o.getValue().get(0).equals("false")){
                    o.setValue(0);
                } else if (o.getValue().get(0).equals("true")){
                    o.setValue(1);
                }
            }

        }

        SearchDTO.SearchRs<TeacherDTO.Grid> response = teacherService.deepSearchGrid(request);
        if(response.getList()!= null && response.getList().size()>0){
            response.getList().stream().forEach(grid -> {
                Long teacherId=  grid.getId();
                List<Tclass> teacherClasses= tclassService.getTeacherClasses(teacherId);
                if(teacherClasses!=null && teacherClasses.size()>0) {
                    Long teacherClassesNumber = teacherClasses.stream().count();
                    grid.setTeacherClassCount(teacherClassesNumber.toString());
                    List<Tclass> sortedClasses = teacherClasses.stream().sorted(Comparator.comparing(Tclass::getId).reversed()).collect(Collectors.toList());
                    Tclass lastClassByTeacher = sortedClasses.get(0);
                    EvalAverageResult evalAverageResult = tclassService.getEvaluationAverageResultToTeacher(lastClassByTeacher.getId());
                    String totalAverage =df.format(evalAverageResult.getTotalAverage());
                    if(totalAverage.equals("0.00") )
                        grid.setTeacherLastEvalAverageResult("ندارد");
                    else
                    grid.setTeacherLastEvalAverageResult(totalAverage);
                }
            });
        }

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
    //@PreAuthorize("hasAuthority('Teacher_P')")
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
        Object term=null;
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

            if (criterion.getFieldName().equalsIgnoreCase("termId"))
            {
                criterion.setFieldName("tclasse.term.id");
                criterion.setOperator(EOperator.inSet);
            }
        }

        for (Object removedObject : removedObjects) {
            request.getCriteria().getCriteria().remove(removedObject);
        }

       Set<TeacherDTO.Report> set=new HashSet<>();
       SearchDTO.SearchRs<TeacherDTO.Report> response = teacherService.deepSearchReport(request);


//        List<TeacherDTO.Report> listRemovedObjects = new ArrayList<>();
//
//        Float min_evalGrade = null;
//        if(evaluationGrade != null)
//           min_evalGrade = Float.parseFloat(evaluationGrade.toString());
//
//        if(evaluationGrade!=null && evaluationCategory!=null && evaluationSubCategory!=null) {
//            for (TeacherDTO.Report datum : response.getList()) {
//                if (evaluationGrade != null) {
//                    ResponseEntity<Float> t = evaluateTeacher(datum.getId(), evaluationCategory.toString(), evaluationSubCategory.toString());
//                    Float teacher_evalGrade = t.getBody();
//                    datum.setEvaluationGrade(""+teacher_evalGrade);
//                    if (teacher_evalGrade < min_evalGrade)
//                        listRemovedObjects.add(datum);
//                }
//            }
//        }
//
//        for (TeacherDTO.Report listRemovedObject : listRemovedObjects)
//            response.getList().remove(listRemovedObject);
//        listRemovedObjects.clear();

        for (TeacherDTO.Report datum : response.getList()) {
            Long tId = datum.getId();
            List<?> result1 = null;
            Object[] res1 = null;
            String courseId = null;
            String classId = null;
            List<?> result2 = null;
            String courseTitle = null;
            List<?> result3 = null;
            String classCount = null;

//            String sql1 = "select f_course,id from tbl_class where c_start_date = (select MAX(c_start_date) from tbl_class where f_teacher =" +  tId + ") AND ROWNUM = 1";
            String sql1 = "select * from (select f_course,id from tbl_class where  f_teacher =" +  tId + "GROUP BY id,f_course ORDER by max(c_start_date) desc) where rownum =1";
            result1 = (List<?>) entityManager.createNativeQuery(sql1).getResultList();
            if(result1.size() > 0) {
                res1 = (Object[]) result1.get(0);
                courseId = res1[0].toString();
                classId = res1[1].toString();
            }

            if(courseId != null) {
                String sql2 = "select c_title_fa from tbl_course where id =" + courseId;
                result2 = (List<?>) entityManager.createNativeQuery(sql2).getResultList();
                courseTitle = (String) result2.get(0);
            }

            String sql3 = "select count(id) from tbl_class where f_teacher =" + tId;
            result3 = (List<?>) entityManager.createNativeQuery(sql3).getResultList();
            classCount = ((BigDecimal) result3.get(0)).toString();

            datum.setLastCourse(courseTitle);
            datum.setNumberOfCourses(classCount);
            if(datum.getLastCourse() != null)
                datum.setLastCourseEvaluationGrade(""+tclassService.getClassReactionEvaluationGrade(Long.parseLong(classId),tId));
        }

        final TeacherDTO.SpecRsReport specResponse = new TeacherDTO.SpecRsReport();
        final TeacherDTO.TeacherSpecRsReport specRs = new TeacherDTO.TeacherSpecRsReport();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

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
    //@PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherFullNameSpecRs> fullNameList(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", required = false, defaultValue = "50") Integer endRow,
                                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                                         @RequestParam(value = "operator", required = false) String operator,
                                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                                         @RequestParam(value = "id", required = false) Long id,
                                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);

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
        SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> response = teacherService.fullNameSearch(request);
        final TeacherDTO.FullNameSpecRs specResponse = new TeacherDTO.FullNameSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final TeacherDTO.TeacherFullNameSpecRs specRs = new TeacherDTO.TeacherFullNameSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>( specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/fullName-list/{id}")
    //@PreAuthorize("hasAuthority('r_teacher')")
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

    @Loggable
    @GetMapping(value = "/fullName/{id}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherFullNameSpecRs> fullNameList(@PathVariable Long id,
                                                                               @RequestParam("_startRow") Integer startRow,
                                                                               @RequestParam("_endRow") Integer endRow,
                                                                               @RequestParam(value = "_constructor", required = false) String constructor,
                                                                               @RequestParam(value = "operator", required = false) String operator,
                                                                               @RequestParam(value = "criteria", required = false) String criteria,
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
    @GetMapping(value = "/teacherFullName/{id}")
    //@PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<String> teacherFullName(@PathVariable Long id){
        String result =  iTeacherService.getTeacherFullName(id);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/fullName")
    //@PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherFullNameSpecRs> fullNameListTeacher(
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
    //@PreAuthorize("hasAuthority('Teacher_R')")
    public ResponseEntity<SearchDTO.SearchRs<TeacherDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(teacherService.search(request), HttpStatus.OK);
    }


    @Loggable
    @PostMapping(value = {"/printWithCriteria/{type}"})
    //@PreAuthorize("hasAuthority('Teacher_P')")
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
    //@PreAuthorize("hasAuthority('Teacher_P')")
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
            try {
                params.put("personalImg", ImageIO.read(file));
            }
            catch(Exception e){
                params.put("personalImg", ImageIO.read(getClass().getResourceAsStream("/reports/reportFiles/personal_photo.png")));
            }
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
        if(genderId != null && genderId.equals("1"))
            gender = "مرد";
        if(genderId != null && genderId.equals("2"))
            gender = "زن";
        params.put("gender", gender);
        Integer militaryId = teacherDTO.getPersonality().getMilitaryId();
        String military = null;
        if(militaryId != null && militaryId.equals(1))
            military = "گذرانده";
        if(militaryId != null && militaryId.equals(2))
            military = "معاف";
        if(militaryId != null && militaryId.equals(3))
            military = "مشمول";
        if(genderId != null && genderId.equals(2))
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
        Set<Category> categoryList = teacher.getCategories();
        Set<Subcategory> subCategoryList = teacher.getSubCategories();
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
    //@PreAuthorize("hasAuthority('Teacher_P')")
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
        params.put("minEvaluationGrade1",resultSet.get("minEvaluationGrade1"));
        params.put("minEvaluationGrade2",resultSet.get("minEvaluationGrade2"));
        params.put("minEvaluationGrade3",resultSet.get("minEvaluationGrade3"));
        params.put("minEvaluationGrade4",resultSet.get("minEvaluationGrade4"));
        params.put("minEvaluationGrade5",resultSet.get("minEvaluationGrade5"));

        String data = "{" + "\"content\": " + null + "}";

        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/TeacherEvaluation.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @GetMapping(value = "/evaluateTeacher/{id}/{catId}/{subCatId}")
    //@PreAuthorize("hasAuthority('Teacher_E')")
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

    private SearchDTO.SearchRq setSearchCriteriaNotInBlackList(@RequestParam(value = "_startRow", required = false) Integer startRow,
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
            SearchDTO.CriteriaRq ctr =  makeNewCriteria("inBlackList", false, EOperator.equals, null);
            criteriaRq.getCriteria().add(ctr);
            request.setCriteria(criteriaRq);
        }
        else {
            SearchDTO.CriteriaRq ctr =  makeNewCriteria("inBlackList", false, EOperator.equals, null);
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setCriteria(new ArrayList<>());
            criteriaRq.setOperator(EOperator.and);
            criteriaRq.getCriteria().add(ctr);

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
//        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.inSet);
//        criteriaRq.setFieldName("id");
//        criteriaRq.setValue(request.get("categories"));
//        categoriesRequest.setCriteria(criteriaRq);
        categoriesRequest.setCriteria(
                CriteriaUtil.createCriteria(EOperator.inSet, "id", request.get("categories"))
        );
        List<CategoryDTO.Info> categories = categoryService.search(categoriesRequest).getList();
        request.remove("categories");
        return categories;

    }

    private List<SubcategoryDTO.Info> setSubCats(LinkedHashMap request) {
        SearchDTO.SearchRq subCategoriesRequest = new SearchDTO.SearchRq();
//        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.inSet);
//        criteriaRq.setFieldName("id");
//        criteriaRq.setValue(request.get("subCategories"));
//        subCategoriesRequest.setCriteria(criteriaRq);
        subCategoriesRequest.setCriteria(
                CriteriaUtil.createCriteria(EOperator.inSet, "id", request.get("subCategories"))
        );
        List<SubcategoryDTO.Info> subCategories = subCategoryService.search(subCategoriesRequest).getList();
        request.remove("subCategories");
        return subCategories;
    }

    @Loggable
    @GetMapping(value = "/full-spec-list")
    //@PreAuthorize("hasAuthority('r_teacher')")
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
    //@PreAuthorize("hasAuthority('r_teacher')")
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
    //@PreAuthorize("hasAuthority('r_teacher')")
    public void changeBlackListStatus(HttpServletRequest req, @PathVariable Boolean inBlackList, @PathVariable Long id) {
        String reason=req.getParameter("reason");
        teacherService.changeBlackListStatus(reason,inBlackList,id);
    }

    @Loggable
    @GetMapping(value = "/info-tuple-list")
    //@PreAuthorize("hasAuthority('r_teacher')")
    public ResponseEntity<TeacherDTO.TeacherInfoTupleSpecRs> infoTupleList(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", required = false, defaultValue = "50") Integer endRow,
                                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                                         @RequestParam(value = "operator", required = false) String operator,
                                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                                         @RequestParam(value = "id", required = false) Long id,
                                                                         @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq request = setSearchCriteria(startRow, endRow, constructor, operator, criteria, id, sortBy);

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
        SearchDTO.SearchRs<TeacherDTO.TeacherInfoTuple> response = teacherService.infoTupleSearch(request);
        final TeacherDTO.InfoTupleSpecRs specResponse = new TeacherDTO.InfoTupleSpecRs<>();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final TeacherDTO.TeacherInfoTupleSpecRs specRs = new TeacherDTO.TeacherInfoTupleSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>( specRs, HttpStatus.OK);
    }

    @Loggable
    @Transactional
    @GetMapping(value = "/getOneByNationalCode")
    public ResponseEntity getPersonnelInfo(HttpServletRequest iscRq, HttpServletResponse response) throws IOException {
        String restApiUrl = iscRq.getRequestURL().toString().replace(iscRq.getServletPath(), "");
        ViewTeacherReport teacher = iViewTeacherReportService.findFirstByNationalCode(SecurityUtil.getNationalCode());
        if (teacher != null)
            return new ResponseEntity<>(modelMapper.map(teacher,ViewTeacherReportDTO.Info.class), HttpStatus.OK);
        else if(SecurityUtil.getNationalCode() == null)
            return new ResponseEntity<>("اطلاعات کاربر در سیستم ناقص می باشد", HttpStatus.NOT_FOUND);
        else
            return new ResponseEntity<>("استادی با این کد ملی در سیستم پیدا نشد", HttpStatus.NOT_FOUND);
    }



    @DeleteMapping("/role/")
    public ResponseEntity<Boolean> removeRoleByTeacherId(@RequestParam Long teacherId,@RequestParam String role) {
        return ResponseEntity.ok(iTeacherRoleService.removeTeacherRole(teacherId,role));
    }

    @DeleteMapping("/role/remove-all")
    public ResponseEntity<Boolean> removeAllByTeacherId(@RequestParam Long teacherId,@RequestBody List<String> roles) {
        return ResponseEntity.ok(iTeacherRoleService.removeRolesByTeacherId(teacherId,roles));
    }

    @PostMapping("/role/")
    public ResponseEntity<Boolean> addRoleByTeacherId(@RequestParam Long teacherId,@RequestParam String role) {
        return ResponseEntity.ok(iTeacherRoleService.addRoleByTeacherId(teacherId,role));
    }

    @PostMapping("/role/add-all")
    public ResponseEntity<Boolean> addGroupRolesByTeacherId(@RequestParam Long teacherId,@RequestBody List<String> roles) {
        return ResponseEntity.ok(iTeacherRoleService.addRolesByTeacherId(teacherId,roles));
    }


    @GetMapping("/role/")
    public ResponseEntity<List<Role>> findAllByTeacherId(@RequestParam Long teacherId) {
        return ResponseEntity.ok(iTeacherRoleService.findAllRoleByTeacherId(teacherId));
    }

    @GetMapping("/getAllTeacherByCurrentTerm/")
    public ResponseEntity<List<TclassDTO.TClassCurrentTerm>> getAllTeacherByCurrentTerm(@RequestParam Long termId) throws NoSuchFieldException, IllegalAccessException {
        return ResponseEntity.ok(tclassService.getAllTeacherByCurrentTerm(termId));
    }

    @Loggable
    @GetMapping(value = "/spec-list-agreement")
    public ResponseEntity<ISC<TeacherDTO.ForAgreementInfo>> forAgreementList(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                             @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                             @RequestParam(value = "_constructor", required = false) String constructor,
                                                                             @RequestParam(value = "operator", required = false) String operator,
                                                                             @RequestParam(value = "criteria", required = false) String criteria,
                                                                             @RequestParam(value = "id", required = false) Long id,
                                                                             @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            searchRq.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            searchRq.setSortBy(sortBy);
        }

        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            searchRq.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        searchRq.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TeacherDTO.ForAgreementInfo> result = teacherService.forAgreementInfoSearch(searchRq);

        ISC.Response<TeacherDTO.ForAgreementInfo> response = new ISC.Response<>();
        response.setData(result.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + result.getList().size())
                .setTotalRows(result.getTotalCount().intValue());
        ISC<TeacherDTO.ForAgreementInfo> infoISC = new ISC<>(response);

        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

}
