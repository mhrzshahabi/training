package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.InstituteDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.dto.ViewEvaluationStaticalReportDTO;
import com.nicico.training.iservice.IInstituteService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.Institute;
import com.nicico.training.model.Personnel;
import com.nicico.training.repository.*;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/tclass")
public class TclassRestController {

    private final TclassService tClassService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final ClassAlarmService classAlarmService;
    private final StudentDAO studentDAO;
    private final CourseDAO courseDAO;
    private final EvaluationAnalysistLearningService evaluationAnalysistLearningService;
    private final ParameterService parameterService;
    private final IInstituteService instituteService;
    private final TclassDAO tclassDAO;
    private final WorkGroupService workGroupService;
    private final ViewEvaluationStaticalReportService viewEvaluationStaticalReportService;
    private final PersonnelDAO personnelDAO;
    private final InstituteDAO instituteDAO;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(tClassService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<List<TclassDTO.Info>> list() {
        return new ResponseEntity<>(tClassService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<TclassDTO.Info> create(@Validated @RequestBody TclassDTO.Create request) {

        ResponseEntity<TclassDTO.Info> infoResponseEntity = new ResponseEntity<>(tClassService.create(request), HttpStatus.CREATED);

        //*****check alarms*****
//// cancel alarms
//        if (infoResponseEntity.getStatusCodeValue() == 201) {
//            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmCheckListConflict(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmPreCourseTestQuestion(infoResponseEntity.getBody().getId());
//            classAlarmService.saveAlarms();
//        }
        return infoResponseEntity;
    }

    @Loggable
    @PostMapping("/safeCreate")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<TclassDTO.Info> safeCreate(@Validated @RequestBody TclassDTO.Create request, HttpServletResponse response) {

        ResponseEntity<TclassDTO.Info> infoResponseEntity = new ResponseEntity<>(tClassService.safeCreate(request, response), HttpStatus.CREATED);

        //*****check alarms*****
//// cancel alarms
//        if (infoResponseEntity.getStatusCodeValue() == 201) {
//            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmCheckListConflict(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmPreCourseTestQuestion(infoResponseEntity.getBody().getId());
//            classAlarmService.saveAlarms();
//        }
        return infoResponseEntity;
    }

    @Loggable
    @PutMapping(value = "/update/{id}")
//    @PreAuthorize("hasAuthority('u_tclass')")
    public ResponseEntity<TclassDTO.Info> safeUpdate(@PathVariable Long id,
                                                     @RequestBody TclassDTO.Update request,
                                                     @RequestParam(required = false) List<Long> cancelClassesIds) {

        ResponseEntity<TclassDTO.Info> infoResponseEntity = new ResponseEntity<>(tClassService.update(id, request, cancelClassesIds), HttpStatus.OK);

        //*****check alarms*****
      /* //// cancel alarms
        if (infoResponseEntity.getStatusCodeValue() == 200) {
            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
            classAlarmService.saveAlarms();
        }*/

        return infoResponseEntity;
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_tclass')")
    public ResponseEntity<TclassDTO.Info> update(@PathVariable Long id, @RequestBody TclassDTO.Update request) {

        ResponseEntity<TclassDTO.Info> infoResponseEntity = new ResponseEntity<>(tClassService.update(id, request, null), HttpStatus.OK);

        //*****check alarms*****
        //// cancel alarms
//        if (infoResponseEntity.getStatusCodeValue() == 200) {
//            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
//            classAlarmService.saveAlarms();
//        }

        return infoResponseEntity;
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@PathVariable Long id, HttpServletResponse resp) throws IOException {
        try {
            if(workGroupService.isAllowUseId("Tclass",id)){
                tClassService.delete(id, resp);
                return new ResponseEntity(HttpStatus.OK);
            }else{
//                tClassService.delete(id);
                return new ResponseEntity(HttpStatus.UNAUTHORIZED);
            }

        } catch (DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity delete(@Validated @RequestBody TclassDTO.Delete request, HttpServletResponse resp) throws IOException {
        tClassService.delete(request, resp);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "id", required = false) Long id,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException, NoSuchFieldException, IllegalAccessException {

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

        //criteriaRq=(SearchDTO.SearchRq[])request.getCriteria().getCriteria().stream().filter(p->p.getFieldName().equals("term.id")&&p.getValue().get(0).equals("[]")).toArray();

        if(request.getCriteria() != null) {
            if (request.getCriteria().getCriteria().stream().filter(p -> p.getFieldName().equals("term.id") && p.getValue().size() == 0).toArray().length > 0) {
                ArrayList list = new ArrayList<>();
                list.add("-1000");
                ((SearchDTO.CriteriaRq) request.getCriteria().getCriteria().stream().filter(p -> p.getFieldName().equals("term.id") && p.getValue().size() == 0).toArray()[0]).setValue(list);
            }
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

        request.setCriteria(workGroupService.addPermissionToCriteria("course.categoryId", request.getCriteria()));

        SearchDTO.SearchRs<TclassDTO.Info> response = tClassService.search(request);

        for (TclassDTO.Info tclassDTO : response.getList()) {
            tclassDTO.setPlannerFullName("");
            tclassDTO.setSupervisorFullName("");
            tclassDTO.setOrganizerName("");

            if (tclassDTO.getPlanner()!=null) {
                Optional<Personnel> planner = personnelDAO.findById(tclassDTO.getPlanner());
                   if (planner.isPresent()) {
                       tclassDTO.setPlannerFullName(planner.get().getFirstName() + " " + planner.get().getLastName());
                   }

                Optional<Personnel> supervisor = personnelDAO.findById(tclassDTO.getSupervisor());
                if (supervisor.isPresent()) {
                    tclassDTO.setSupervisorFullName(supervisor.get().getFirstName() + " " + supervisor.get().getLastName());
                }
            }
            if(tclassDTO.getOrganizerId() != null){
                Optional<Institute> institute = instituteDAO.findById(tclassDTO.getOrganizerId());
                if(institute.isPresent()){
                    tclassDTO.setOrganizerName(institute.get().getTitleFa());
                }
            }
        }

        //*********************************
        //******old code for alarms********
////        for (TclassDTO.Info tclassDTO : response.getList()) {
////            if (classAlarmService.hasAlarm(tclassDTO.getId(), httpResponse).size() > 0)
////                tclassDTO.setHasWarning("alarm");
////           else
////              tclassDTO.setHasWarning("");
////        }
        //*********************************

        final TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        final TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/tuple-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassSpecRs> tupleList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                            @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                            @RequestParam(value = "_constructor", required = false) String constructor,
                                                            @RequestParam(value = "operator", required = false) String operator,
                                                            @RequestParam(value = "criteria", required = false) String criteria,
                                                            @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException, NoSuchFieldException, IllegalAccessException {

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
        request.setStartIndex(startRow).setCount(endRow - startRow);
        request.setDistinct(true);

        SearchDTO.SearchRs<TclassDTO.Info> response = tClassService.search(request);
        final TclassDTO.SpecRs specResponse = new TclassDTO.SpecRs();
        final TclassDTO.TclassSpecRs specRs = new TclassDTO.TclassSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/info-tuple-list")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassInfoTupleSpecRs> infoTupleList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                            @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                            @RequestParam(value = "_constructor", required = false) String constructor,
                                                            @RequestParam(value = "operator", required = false) String operator,
                                                            @RequestParam(value = "criteria", required = false) String criteria,
                                                            @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

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
        request.setStartIndex(startRow).setCount(endRow - startRow);
        request.setDistinct(true);

        SearchDTO.SearchRs<TclassDTO.InfoTuple> response = tClassService.searchInfoTuple(request);
        final TclassDTO.InfoTupleSpecRs specResponse = new TclassDTO.InfoTupleSpecRs();
        final TclassDTO.TclassInfoTupleSpecRs specRs = new TclassDTO.TclassInfoTupleSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list-evaluated")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassEvaluatedSpecRs> evaluatedList(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                         @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                         @RequestParam(value = "_constructor", required = false) String constructor,
                                                                         @RequestParam(value = "operator", required = false) String operator,
                                                                         @RequestParam(value = "criteria", required = false) String criteria,
                                                                         @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException {

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
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TclassDTO.EvaluatedInfoGrid> response = tClassService.evaluatedSearch(request);

        final TclassDTO.EvaluatedSpecRs specResponse = new TclassDTO.EvaluatedSpecRs();
        final TclassDTO.TclassEvaluatedSpecRs specRs = new TclassDTO.TclassEvaluatedSpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<SearchDTO.SearchRs<TclassDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException {
        return new ResponseEntity<>(tClassService.search(request), HttpStatus.OK);
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

        final SearchDTO.SearchRs<TclassDTO.Info> searchRs = tClassService.search(searchRq);
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/ClassByCriteria.jasper", params, jsonDataSource, response);
    }
    //----------------------------------------------------

    @Loggable
    @GetMapping(value = "/end_group/{courseId}/{termId}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<Long> getEndGroup(@PathVariable Long courseId, @PathVariable Long termId) {
        return new ResponseEntity<>(tClassService.getEndGroup(courseId, termId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/checkStudentInClass/{nationalCode}/{classId}")
//    @PreAuthorize("hasAuthority('c_tclass')")
    public ResponseEntity<Long> checkStudentInClass(@PathVariable String nationalCode, @PathVariable Long classId) {

        if (((studentDAO.findOneByNationalCodeInClass(nationalCode, classId)) != null)) {
            return null;
        }
        List<Long> classList = (studentDAO.findOneByNationalCodeInClass(nationalCode, classId));
        return new ResponseEntity<Long>((MultiValueMap<String, String>) classList, HttpStatus.OK);

    }


    @Loggable
    @GetMapping(value = "/checkEndingClass/{classId}/{endDate}")
    public String checkEndingClass(@PathVariable Long classId, @PathVariable String endDate, HttpServletResponse response) throws IOException {
        return classAlarmService.checkAlarmsForEndingClass(classId, endDate, response);
    }

    @Loggable
    @GetMapping(value = "/hasClassStarted/{classId}")
    public boolean hasClassStarted(@PathVariable Long classId) throws IOException {
        return tClassService.compareTodayDate(classId);
    }

    @Loggable
    @GetMapping(value = "/getWorkflowEndingStatusCode/{classId}")
    public Integer getWorkflowEndingStatusCode(@PathVariable Long classId) {
        return tClassService.getWorkflowEndingStatusCode(classId);
    }

    @Loggable
    @GetMapping(value = "/reactionEvaluationResult/{classId}")
    public ResponseEntity<TclassDTO.ReactionEvaluationResult> getReactionEvaluationResult(@PathVariable Long classId) {
        return new ResponseEntity<TclassDTO.ReactionEvaluationResult>(tClassService.getReactionEvaluationResult(classId), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/preCourse-test-questions/{classId}")
    public ResponseEntity<List<String>> getPreCourseTestQuestions(@PathVariable Long classId) {
        return new ResponseEntity<>(tClassService.getPreCourseTestQuestions(classId), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/preCourse-test-questions/{classId}")
    public ResponseEntity updatePreCourseTestQuestions(@PathVariable Long classId, @RequestBody List<String> request) {
        try {
            tClassService.updatePreCourseTestQuestions(classId, request);
            //// cancel alarms
//            classAlarmService.alarmPreCourseTestQuestion(classId);
//            classAlarmService.saveAlarms();
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @GetMapping(value = "/personnel-training/{national_code}/{personnel_no}")
    public ResponseEntity<TclassDTO.PersonnelClassInfo_TclassSpecRs> personnelTraining(@PathVariable String national_code, @PathVariable String personnel_no) {

        List<TclassDTO.PersonnelClassInfo> list = tClassService.findAllPersonnelClass(national_code,personnel_no);

        final TclassDTO.PersonnelClassInfo_SpecRs specResponse = new TclassDTO.PersonnelClassInfo_SpecRs();
        final TclassDTO.PersonnelClassInfo_TclassSpecRs specRs = new TclassDTO.PersonnelClassInfo_TclassSpecRs();

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
    @GetMapping(value = "/listByteacherID/{teacherId}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public ResponseEntity<TclassDTO.TclassTeachingHistorySpecRs> listByTeacherID(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                                 @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                                                 @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                                 HttpServletResponse httpResponse,
                                                                                 @PathVariable Long teacherId) throws IOException {

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

        SearchDTO.SearchRs<TclassDTO.TeachingHistory> response = tClassService.searchByTeachingHistory(request, teacherId);

        final TclassDTO.TeachingHistorySpecRs specResponse = new TclassDTO.TeachingHistorySpecRs();
        final TclassDTO.TclassTeachingHistorySpecRs specRs = new TclassDTO.TclassTeachingHistorySpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/defaultExecutor/{parameterCode}/{cTitle}")
    public ResponseEntity<InstituteDTO.Info> defaultExecutor(@PathVariable String parameterCode, @PathVariable String cTitle){
        TotalResponse<ParameterValueDTO.Info> totalResponse = parameterService.getByCode(parameterCode);
        ParameterValueDTO.Info parameterInfo = totalResponse.getResponse().getData().stream().filter(i -> i.getTitle().equals(cTitle)).findFirst().orElse(null);
        SearchDTO.SearchRs<InstituteDTO.Info> infoSearchRs = instituteService.search(new SearchDTO.SearchRq().setCriteria(makeNewCriteria("titleFa",parameterInfo.getValue(),EOperator.equals,null)));
        return new ResponseEntity<InstituteDTO.Info>(infoSearchRs.getList().get(0), HttpStatus.OK);
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


//    @Loggable
//    @GetMapping(value = "/list-training-report")
//    public ResponseEntity<TclassDTO.TclassReportSpecRs> reportList(@RequestParam(value = "_startRow", required = false) Integer startRow,
//                                                                   @RequestParam(value = "_endRow", required = false) Integer endRow,
//                                                                   @RequestParam(value = "_constructor", required = false) String constructor,
//                                                                   @RequestParam(value = "operator", required = false) String operator,
//                                                                   @RequestParam(value = "criteria", required = false) String criteria,
//                                                                   @RequestParam(value = "id", required = false) Long id,
//                                                                   @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
//
//        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
//
//        SearchDTO.CriteriaRq criteriaRq;
//        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
//            criteria = "[" + criteria + "]";
//            criteriaRq = new SearchDTO.CriteriaRq();
//            criteriaRq.setOperator(EOperator.valueOf(operator))
//                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
//                    }));
//
//            SearchDTO.CriteriaRq addedObject = null;
//            SearchDTO.CriteriaRq removedObject = null;
//            for (SearchDTO.CriteriaRq criterion : criteriaRq.getCriteria()) {
//                if (criterion.getFieldName().equalsIgnoreCase("startDate") && criterion.getOperator().equals(EOperator.inSet)) {
//                    SearchDTO.CriteriaRq ctr = makeNewCriteria("year", null, EOperator.or, new ArrayList<>());
//                    for (Object o : criterion.getValue()) {
//                        ctr.getCriteria().add(makeNewCriteria("startDate", o, EOperator.iContains, null));
//                    }
//                    addedObject = ctr;
//                    removedObject = criterion;
//                }
//            }
//            if (removedObject != null)
//                criteriaRq.getCriteria().remove(removedObject);
//            if (addedObject != null)
//                criteriaRq.getCriteria().add(addedObject);
//            request.setCriteria(criteriaRq);
//        }
//
//        if (StringUtils.isNotEmpty(sortBy)) {
//            request.setSortBy(sortBy);
//        }
//        request.setStartIndex(0)
//                .setCount(100000);
//
//        List<Object> removedObjects = new ArrayList<>();
//        Object courseStatus = null;
//        Object reactionEvaluationOperator = null;
//        Object reactionEvaluationGrade = null;
//        Object behavioralEvaluationOperator = null;
//        Object behavioralEvaluationGrade = null;
//        Object learningEvaluationOperator = null;
//        Object learningEvaluationGrade = null;
//        Object evaluationOperator = null;
//        Object evaluationGrade = null;
//
//        for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
//            if (criterion.getFieldName().equalsIgnoreCase("courseStatus")) {
//                courseStatus = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("reactionEvaluationOperator")) {
//                reactionEvaluationOperator = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("reactionEvaluationGrade")) {
//                reactionEvaluationGrade = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("behavioralEvaluationOperator")) {
//                behavioralEvaluationOperator = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("behavioralEvaluationGrade")) {
//                behavioralEvaluationGrade = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("learningEvaluationOperator")) {
//                learningEvaluationOperator = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("learningEvaluationGrade")) {
//                learningEvaluationGrade = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("evaluationOperator")) {
//                evaluationOperator = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("evaluationGrade")) {
//                evaluationGrade = criterion.getValue().get(0);
//                removedObjects.add(criterion);
//            }
//            if (criterion.getFieldName().equalsIgnoreCase("classStatus") && criterion.getValue().get(0).toString().equalsIgnoreCase("4")) {
//                removedObjects.add(criterion);
//            }
//        }
//
//        for (Object removedObject : removedObjects) {
//            request.getCriteria().getCriteria().remove(removedObject);
//        }
//
//        SearchDTO.SearchRs<TclassDTO.TClassReport> response = tClassService.reportSearch(request);
//
//        List<TclassDTO.TClassReport> listRemovedObjects = new ArrayList<>();
//        if (courseStatus != null && !courseStatus.equals("3")) {
//
//            List<Long> ids=new ArrayList<>();
//
//            for (TclassDTO.TClassReport datum : response.getList()) {
//                ids.add(datum.getCourse().getId());
//            }
//
//            List<Long> courseNeedAssessmentStatus = courseDAO.isExistInNeedsAssessment(ids);
//
//            for (TclassDTO.TClassReport datum : response.getList()) {
//                if (courseStatus.equals("1") && courseNeedAssessmentStatus.stream().filter(p->p==datum.getCourse().getId()).toArray().length == 0)
//                    listRemovedObjects.add(datum);
//                if (courseStatus.equals("2") && courseNeedAssessmentStatus.stream().filter(p->p==datum.getCourse().getId()).toArray().length != 0)
//                    listRemovedObjects.add(datum);
//            }
//        }
//        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
//            response.getList().remove(listRemovedObject);
//        listRemovedObjects.clear();
//
//        if (reactionEvaluationOperator != null && reactionEvaluationGrade != null) {
//            double grade = Double.parseDouble(reactionEvaluationGrade.toString());
//            for (TclassDTO.TClassReport datum : response.getList()) {
//                double classReactionGrade = tClassService.getClassReactionEvaluationGrade(datum.getId(), datum.getTeacherId());
//                if (reactionEvaluationOperator.equals("1")) {
//                    if (classReactionGrade >= grade)
//                        listRemovedObjects.add(datum);
//                }
//                if (reactionEvaluationOperator.equals("2")) {
//                    if (classReactionGrade <= grade)
//                        listRemovedObjects.add(datum);
//                }
//            }
//        }
//        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
//            response.getList().remove(listRemovedObject);
//        listRemovedObjects.clear();
//
//        if (behavioralEvaluationOperator != null && behavioralEvaluationGrade != null) {
//            double grade = Double.parseDouble(behavioralEvaluationGrade.toString());
//            for (TclassDTO.TClassReport datum : response.getList()) {
//                double classBehavioralGrade = tClassService.getBehavioralEvaluationResult(datum.getId()).getFEBGrade();
//                if (behavioralEvaluationOperator.equals("1")) {
//                    if (classBehavioralGrade >= grade)
//                        listRemovedObjects.add(datum);
//                }
//                if (behavioralEvaluationOperator.equals("2")) {
//                    if (classBehavioralGrade <= grade)
//                        listRemovedObjects.add(datum);
//                }
//            }
//        }
//        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
//            response.getList().remove(listRemovedObject);
//        listRemovedObjects.clear();
//
//        if (learningEvaluationOperator != null && learningEvaluationGrade != null) {
//            double grade = Double.parseDouble(learningEvaluationGrade.toString());
//            for (TclassDTO.TClassReport datum : response.getList()) {
//                double classLearningGrade = evaluationAnalysistLearningService.getStudents(datum.getId(), datum.getScoringMethod())[3];
//                if (learningEvaluationOperator.equals("1")) {
//                    if (classLearningGrade >= grade)
//                        listRemovedObjects.add(datum);
//                }
//                if (learningEvaluationOperator.equals("2")) {
//                    if (classLearningGrade <= grade)
//                        listRemovedObjects.add(datum);
//                }
//            }
//        }
//        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
//            response.getList().remove(listRemovedObject);
//        listRemovedObjects.clear();
//
//        if (evaluationOperator != null && evaluationGrade != null) {
//            double grade = Double.parseDouble(evaluationGrade.toString());
//            for (TclassDTO.TClassReport datum : response.getList()) {
//                double classEvaluationGrade = tClassService.getBehavioralEvaluationResult(datum.getId()).getFECBGrade();
//                if (evaluationOperator.equals("1")) {
//                    if (classEvaluationGrade >= grade)
//                        listRemovedObjects.add(datum);
//                }
//                if (evaluationOperator.equals("2")) {
//                    if (classEvaluationGrade <= grade)
//                        listRemovedObjects.add(datum);
//                }
//            }
//        }
//        for (TclassDTO.TClassReport listRemovedObject : listRemovedObjects)
//            response.getList().remove(listRemovedObject);
//        listRemovedObjects.clear();
//
//
//        final TclassDTO.ReportSpecRs specResponse = new TclassDTO.ReportSpecRs();
//        final TclassDTO.TclassReportSpecRs specRs = new TclassDTO.TclassReportSpecRs();
//        specResponse.setData(response.getList())
//                .setStartRow(0)
//                .setEndRow(response.getList().size())
//                .setTotalRows(response.getList().size());
//
//        specRs.setResponse(specResponse);
//
//        return new ResponseEntity<>(specRs, HttpStatus.OK);
//    }


    @Loggable
    @PostMapping(value = {"/reportPrint/{type}"})
    public void reportPrint(HttpServletResponse response,
                            @PathVariable String type,
                            @RequestParam String CriteriaStr,
                            @RequestParam String courseInfo,
                            @RequestParam String classTimeInfo,
                            @RequestParam String executionInfo,
                            @RequestParam String evaluationInfo
    ) throws Exception
    {
         SearchDTO.CriteriaRq criteriaRq = null;
         SearchDTO.SearchRq request = null;
        if (CriteriaStr.equalsIgnoreCase("{}")) {
            request = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(CriteriaStr, SearchDTO.CriteriaRq.class);
            request = new SearchDTO.SearchRq().setCriteria(criteriaRq).setSortBy("-tclassStartDate");
        }
        if(request.getCriteria() != null && request.getCriteria().getCriteria() != null){
            for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                if(criterion.getValue().get(0).equals("true"))
                    criterion.setValue(true);
                if(criterion.getValue().get(0).equals("false"))
                    criterion.setValue(false);
            }
        }
        SearchDTO.SearchRs<ViewEvaluationStaticalReportDTO.Info> searchRs = viewEvaluationStaticalReportService.search(request);

        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());
        params.put("courseInfo", courseInfo);
        params.put("classTimeInfo", classTimeInfo);
        params.put("executionInfo", executionInfo);
        params.put("evaluationInfo", evaluationInfo);

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        params.put(ConstantVARs.REPORT_TYPE, type);
        reportUtil.export("/reports/TClassReportPrint.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @Transactional
    @GetMapping(value = "/setReactionStatus/{teacherReactionStatus}/{trainingReactionStatus}/{classId}")
//    @PreAuthorize("hasAuthority('r_tclass')")
    public void setReactionStatus(@PathVariable Integer teacherReactionStatus, @PathVariable Integer trainingReactionStatus, @PathVariable Long classId) {
        if(teacherReactionStatus == 10)
            tclassDAO.updateTrainingReactionStatus(trainingReactionStatus,classId);
        if(trainingReactionStatus == 10)
            tclassDAO.updateTeacherReactionStatus(teacherReactionStatus,classId);
    }

    @Loggable
    @Transactional
    @GetMapping(value = "/getTeacherReactionStatus/{classId}")
    public ResponseEntity<Integer> getTeacherReactionStatus(@PathVariable Long classId) {
        Integer result = tclassDAO.getTeacherReactionStatus(classId);
        if(result != null)
            return new ResponseEntity<>(result, HttpStatus.OK);
        else
            return new ResponseEntity<>(0, HttpStatus.OK);
    }

    @Loggable
    @Transactional
    @GetMapping(value = "/getTrainingReactionStatus/{classId}")
    public ResponseEntity<Integer> getTrainingReactionStatus(@PathVariable Long classId) {
        Integer result = tclassDAO.getTrainingReactionStatus(classId);
        if(result != null)
            return new ResponseEntity<>(result, HttpStatus.OK);
        else
            return new ResponseEntity<>(0, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/hasSessions/{classId}")
    public ResponseEntity<Boolean> hasSessions(@PathVariable Long classId) {
        return new ResponseEntity<>(tClassService.hasSessions(classId),HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/updateCostInfo/{id}")
//    @PreAuthorize("hasAuthority('u_tclass')")
    public ResponseEntity<Void> updateCostInfo(@PathVariable Long id, @RequestBody TclassDTO.Update request) {

        tClassService.updateCostInfo(id, request);

        return new ResponseEntity<>(HttpStatus.OK);
    }


    }
