package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lowagie.text.pdf.codec.Base64;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.tclass.TclassAuditMapper;
import com.nicico.training.model.*;
import dto.ScoringClassDto;
import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.util.JRLoader;
import org.modelmapper.TypeToken;
import org.springframework.core.io.ClassPathResource;
import request.exam.ElsExamRequest;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.dto.*;
import com.nicico.training.repository.InstituteDAO;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.StudentDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.service.*;
import dto.LockClassDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.commons.lang3.StringUtils;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import response.BaseResponse;
import response.evaluation.dto.EvalAverageResult;
import response.tclass.TclassCreateResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/tclass")
public class TclassRestController {

    private final ITclassService tClassService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final IClassAlarmService classAlarmService;
    private final IStudentService iStudentService;
    private final IParameterService parameterService;
    private final IInstituteService instituteService;
    private final IWorkGroupService workGroupService;
    private final ViewEvaluationStaticalReportService viewEvaluationStaticalReportService;
    private final IClassSessionService classSessionService;
    private final IPersonnelService iPersonnelService;
    private final IInstituteService iInstituteService;
    private final MessageSource messageSource;
    private final ElsClient client;
    private final EvaluationBeanMapper evaluationBeanMapper;
    private final TclassAuditMapper tclassAuditMapper;
    private final PersonnelService personnelService;

    private final CriteriaUtil criteriaUtil;

    private static final DecimalFormat df = new DecimalFormat("0.00");

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<TclassDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(tClassService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    public ResponseEntity<List<TclassDTO.Info>> list() {
        return new ResponseEntity<>(tClassService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
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
    public ResponseEntity safeCreate(@Validated @RequestBody TclassDTO.Create request, HttpServletResponse response) {

        TclassCreateResponse createResponse = new TclassCreateResponse();
        try {
            createResponse.setRecord(tClassService.safeCreate(request, response));
            createResponse.setMessage("عملیات ایجاد با موفقیت انجام شد.");
            createResponse.setStatus(200);
        } catch (Exception e) {
            createResponse.setStatus(409);
            if (e.getLocalizedMessage().contains("UC_TBL_CLASSC_CODE_COL")) {
                createResponse.setMessage("کد کلاس تکراری است. احتمالا فرایند ایجاد کلاس همزمان توسط چندین کاربر انجام شده است.");
            }
        }

        //*****check alarms*****
//// cancel alarms
//        if (infoResponseEntity.getStatusCodeValue() == 201) {
//            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmCheckListConflict(infoResponseEntity.getBody().getId());
//            classAlarmService.alarmPreCourseTestQuestion(infoResponseEntity.getBody().getId());
//            classAlarmService.saveAlarms();
//        }
        return new ResponseEntity<>(createResponse, HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/update/{id}")
    public ResponseEntity safeUpdate(@PathVariable Long id,
                                     @RequestBody TclassDTO.Update request,
                                     @RequestParam(required = false) List<Long> cancelClassesIds) {

        TclassCreateResponse response = new TclassCreateResponse();
        try {
            response.setRecord(tClassService.update(id, request, cancelClassesIds));
            if (request.getClassToOnlineStatus() != null && request.getClassToOnlineStatus()) {

                ElsExamRequest elsExamRequest = evaluationBeanMapper.toElsExamRequest(id);
                BaseResponse baseResponse = client.sendClass(elsExamRequest);
                if (baseResponse.getStatus() == HttpStatus.OK.value())
                    response.setMessage("عملیات ویرایش کلاس با موفقیت انجام و برای آزمون آنلاین ارسال شد");
                else
                    response.setMessage("عملیات ویرایش کلاس با موفقیت انجام شد ولی اطلاعات ویرایش شده برای آزمون آنلاین ارسال نشد");
            } else
                response.setMessage("عملیات ویرایش کلاس با موفقیت انجام شد.");
            response.setStatus(200);
        } catch (Exception e) {
            response.setStatus(409);
            response.setMessage("عملیات با مشکل مواجه شد.");
        }

        //*****check alarms*****
      /* //// cancel alarms
        if (infoResponseEntity.getStatusCodeValue() == 200) {
            classAlarmService.alarmSumSessionsTimes(infoResponseEntity.getBody().getId());
            classAlarmService.alarmClassCapacity(infoResponseEntity.getBody().getId());
            classAlarmService.saveAlarms();
        }*/

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody TclassDTO.Update request) {

        ResponseEntity infoResponseEntity = new ResponseEntity<>(tClassService.update(id, request, null), HttpStatus.OK);

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
    public BaseResponse delete(@PathVariable Long id, HttpServletResponse resp) throws IOException {
        BaseResponse baseResponse=new BaseResponse();
        try {
            if (workGroupService.isAllowUseId("Tclass", id)) {
                baseResponse   = tClassService.delete(id);
                return baseResponse;
            }}
         catch (Exception e) {
             baseResponse.setStatus(406);
        }
        return baseResponse;
    }

    @Loggable
    @DeleteMapping(value = "/list")
    public ResponseEntity delete(@Validated @RequestBody TclassDTO.Delete request, HttpServletResponse resp) throws IOException {
        tClassService.delete(request, resp);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<TclassDTO.TclassSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "id", required = false) List<Long> ids,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
           criteria=criteria.replaceAll("\\s","");
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
        }

        //criteriaRq=(SearchDTO.SearchRq[])request.getCriteria().getCriteria().stream().filter(p->p.getFieldName().equals("term.id")&&p.getValue().get(0).equals("[]")).toArray();

        if (request.getCriteria() != null) {
            if (request.getCriteria().getCriteria().stream().filter(p -> (p.getFieldName() == null ? false : p.getFieldName().equals("term.id")) && p.getValue().size() == 0).toArray().length > 0) {
                ArrayList list = new ArrayList<>();
                list.add("-1000");
                ((SearchDTO.CriteriaRq) request.getCriteria().getCriteria().stream().filter(p -> p.getFieldName().equals("term.id") && p.getValue().size() == 0).toArray()[0]).setValue(list);
            }
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        if (ids != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.inSet)
                    .setFieldName("id")
                    .setValue(ids);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = ids.size();
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        request.setCriteria(workGroupService.addPermissionToCriteria("course.categoryId", request.getCriteria()));

        SearchDTO.SearchRs<TclassDTO.Info> response = tClassService.search(request);

        List<Long> classIdForCheckMessage = new ArrayList<>();

        for (TclassDTO.Info tclassDTO : response.getList()) {
            tclassDTO.setPlannerFullName("");
            tclassDTO.setSupervisorFullName("");
            tclassDTO.setOrganizerName("");

            if (tclassDTO.getPlannerId() != null) {
                Personnel planner = iPersonnelService.getPersonnel(tclassDTO.getPlannerId());
                if (planner != null) {
                    tclassDTO.setPlannerFullName(planner.getFirstName() + " " + planner.getLastName());
                }

                Personnel supervisor = iPersonnelService.getPersonnel(tclassDTO.getPlannerId());
                if (supervisor != null) {
                    tclassDTO.setSupervisorFullName(supervisor.getFirstName() + " " + supervisor.getLastName());
                }
            }
            if (tclassDTO.getOrganizerId() != null) {
                Institute institute = iInstituteService.getInstitute(tclassDTO.getOrganizerId());
                if (institute != null) {
                    tclassDTO.setOrganizerName(institute.getTitleFa());
                }
            }

            if (tclassDTO.getStudentCount() > 0 && (tclassDTO.getClassStatus().equals("1") || tclassDTO.getClassStatus().equals("2"))) {
                SearchDTO.SearchRq csSearchRq = new SearchDTO.SearchRq();
                csSearchRq.setCount(1);
                csSearchRq.setStartIndex(0);

                List<String> csSortBy = new ArrayList<>();
                csSortBy.add("sessionDate");
                csSortBy.add("sessionStartHour");
                csSearchRq.setSortBy(csSortBy);
                SearchDTO.SearchRs<ClassSessionDTO.Info> result = classSessionService.searchWithCriteria(csSearchRq, tclassDTO.getId());

                if (result.getList().size() > 0) {
                    String str = DateUtil.convertKhToMi1(result.getList().get(0).getSessionDate());
                    LocalDate date = LocalDate.parse(str);

                    if ((date.isBefore(LocalDate.now().plusDays(7)) || date.equals(LocalDate.now().plusDays(7))) && (date.isAfter(LocalDate.now()) || date.equals(LocalDate.now()))) {
                        classIdForCheckMessage.add(tclassDTO.getId());
                    }
                }
            }
        }

        if (classIdForCheckMessage.size() > 0) {
            Map<Long, Integer> classIds = tClassService.checkClassesForSendMessage(classIdForCheckMessage);

            response.getList().forEach(p -> {
                if (classIds != null && classIds.get(p.getId()) != null && classIds.get(p.getId()) > 0) {
                    p.setIsSentMessage("alarm");
                } else {
                    p.setIsSentMessage("");
                }
            });
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

    @Loggable
    @GetMapping(value = "/end_group/{courseId}/{termId}")
    public ResponseEntity<Long> getEndGroup(@PathVariable Long courseId, @PathVariable Long termId) {
        return new ResponseEntity<>(tClassService.getEndGroup(courseId, termId), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/checkStudentInClass/{nationalCode}/{classId}")
    public ResponseEntity<Long> checkStudentInClass(@PathVariable String nationalCode, @PathVariable Long classId) {
        List<Long> classIdList = iStudentService.findOneClassByNationalCodeInClass(nationalCode, classId);

        if (classIdList != null) {
            return null;
        }
        return new ResponseEntity<Long>((MultiValueMap<String, String>) classIdList, HttpStatus.OK);

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
    @GetMapping(value = "/executionEvaluationResult/{classId}")
    public ResponseEntity<TclassDTO.ExecutionEvaluationResult> getExecutionEvaluationResult(@PathVariable Long classId) {
        return new ResponseEntity<TclassDTO.ExecutionEvaluationResult>(tClassService.getExecutionEvaluationResult(classId), HttpStatus.OK);
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

        List<TclassDTO.PersonnelClassInfo> list = tClassService.findAllPersonnelClass(national_code, personnel_no);

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
    @GetMapping(value = "/get-reaction-evaluation-formula")
    public Map<String, Double> getClassReactionEvaluationFormula(@PathVariable Long classId) {

        Map<String, Double> classReactionEvaluationFormula = tClassService.getClassReactionEvaluationFormula(classId);
        return classReactionEvaluationFormula;
    }

    @Loggable
    @GetMapping(value = "/listByteacherID/{teacherId}")
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
        List<TclassDTO.TeachingHistory> finalList=new ArrayList<>();
        if(response.getList()!= null && response.getList().size()>0){
            response.getList().stream().forEach(teachingHistory -> {

                EvalAverageResult evalAverageResult =tClassService .getEvaluationAverageResultToTeacher(teachingHistory.getId());
                    String totalAverage =df.format(evalAverageResult.getTotalAverage());
                    teachingHistory.setEvaluationGrade(Double.valueOf(totalAverage));
                if(totalAverage.equals("0.00") )
                    teachingHistory.setTeacherEvalGrade("ندارد");

                else
                    teachingHistory.setTeacherEvalGrade(totalAverage);



            });
            finalList=response.getList().stream().sorted(Comparator.comparing(TclassDTO.TeachingHistory::getId).reversed()).collect(Collectors.toList());
        }

        final TclassDTO.TeachingHistorySpecRs specResponse = new TclassDTO.TeachingHistorySpecRs();
        final TclassDTO.TclassTeachingHistorySpecRs specRs = new TclassDTO.TclassTeachingHistorySpecRs();
        specResponse.setData(finalList)
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());
        
        
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/defaultExecutor/{parameterCode}/{cTitle}")
    public ResponseEntity<InstituteDTO.Info> defaultExecutor(@PathVariable String parameterCode, @PathVariable String cTitle) {
        TotalResponse<ParameterValueDTO.Info> totalResponse = parameterService.getByCode(parameterCode);
        ParameterValueDTO.Info parameterInfo = totalResponse.getResponse().getData().stream().filter(i -> i.getTitle().equals(cTitle)).findFirst().orElse(null);
        SearchDTO.SearchRs<InstituteDTO.Info> infoSearchRs = null;
        if (parameterInfo != null) {
            infoSearchRs = instituteService.search(new SearchDTO.SearchRq().setCriteria(makeNewCriteria("titleFa", parameterInfo.getValue(), EOperator.equals, null)));
        }
        return new ResponseEntity<>((infoSearchRs == null || infoSearchRs.getList().size() == 0) ? new InstituteDTO.Info() : infoSearchRs.getList().get(0), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = {"/reportPrint/{type}"})
    public void reportPrint(HttpServletResponse response,
                            @PathVariable String type,
                            @RequestParam String CriteriaStr,
                            @RequestParam String courseInfo,
                            @RequestParam String classTimeInfo,
                            @RequestParam String executionInfo,
                            @RequestParam String evaluationInfo
    ) throws Exception {
        SearchDTO.CriteriaRq criteriaRq = null;
        SearchDTO.SearchRq request = null;
        if (CriteriaStr.equalsIgnoreCase("{}")) {
            request = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(CriteriaStr, SearchDTO.CriteriaRq.class);
            request = new SearchDTO.SearchRq().setCriteria(criteriaRq).setSortBy("-tclassStartDate");
        }
        if (request.getCriteria() != null && request.getCriteria().getCriteria() != null) {
            for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                if (criterion.getValue().get(0).equals("true"))
                    criterion.setValue(true);
                if (criterion.getValue().get(0).equals("false"))
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
    public void setReactionStatus(@PathVariable Integer teacherReactionStatus, @PathVariable Integer trainingReactionStatus, @PathVariable Long classId) {
        if (teacherReactionStatus == 10)
            tClassService.updateTrainingReactionStatus(trainingReactionStatus, classId);
        if (trainingReactionStatus == 10)
            tClassService.updateTrainingReactionStatus(trainingReactionStatus, classId);
    }

    @Loggable
    @Transactional
    @GetMapping(value = "/getTeacherReactionStatus/{classId}")
    public ResponseEntity<Integer> getTeacherReactionStatus(@PathVariable Long classId) {
        Integer result = tClassService.getTeacherReactionStatus(classId);
        if (result != null)
            return new ResponseEntity<>(result, HttpStatus.OK);
        else
            return new ResponseEntity<>(0, HttpStatus.OK);
    }

    @Loggable
    @Transactional
    @GetMapping(value = "/getTrainingReactionStatus/{classId}")
    public ResponseEntity<Integer> getTrainingReactionStatus(@PathVariable Long classId) {
        Integer result = tClassService.getTrainingReactionStatus(classId);
        if (result != null)
            return new ResponseEntity<>(result, HttpStatus.OK);
        else
            return new ResponseEntity<>(0, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/hasSessions/{classId}")
    public ResponseEntity<Boolean> hasSessions(@PathVariable Long classId) {
        return new ResponseEntity<>(tClassService.hasSessions(classId), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/updateCostInfo/{id}")
//    @PreAuthorize("hasAuthority('u_tclass')")
    public ResponseEntity<Void> updateCostInfo(@PathVariable Long id, @RequestBody TclassDTO.Update request) {

        tClassService.updateCostInfo(id, request);

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/hasAccessToGroups/{groupIds}")
    public ResponseEntity<Map<String, Boolean>> hasAccessToGroups(@PathVariable String groupIds) {
        return new ResponseEntity(tClassService.hasAccessToGroups(groupIds), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/hasAccessToChangeClassStatus/{groupIds}")
    public ResponseEntity<Boolean> hasAccessToChangeClassStatus(@PathVariable String groupIds) {
        return new ResponseEntity<>(tClassService.hasAccessToChangeClassStatus(groupIds), HttpStatus.OK);
    }


    //    every class after finish can edit but when lock it we can not edit that
    @Loggable
    @GetMapping("/changeClassStatusToUnLock/{classId}/{groupId}")
    public ResponseEntity changeClassStatusToFinish(@PathVariable Long classId, @PathVariable Long groupId) {
        BaseResponse response = new BaseResponse();
        if (tClassService.hasAccessToChangeClassStatus(String.valueOf(groupId))) {
            response = tClassService.changeClassStatus(classId, "unLock", null);
        } else {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage(messageSource.getMessage("hasNotAccessToUnLock", null, LocaleContextHolder.getLocale()));
        }
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    //every class after finish can edit but when lock it we can not edit that
    @Loggable
    @PostMapping("/changeClassStatusToLock")
    public ResponseEntity changeClassStatusToLock(@RequestBody LockClassDto lockClassDto) {
        BaseResponse response = new BaseResponse();
        if (tClassService.hasAccessToChangeClassStatus(String.valueOf(lockClassDto.getGroupId()))) {
            response = tClassService.changeClassStatus(lockClassDto.getClassId(), "lock", lockClassDto.getReason());
        } else {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage(messageSource.getMessage("hasNotAccessToLock", null, LocaleContextHolder.getLocale()));
        }
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    @Loggable
    @GetMapping(value = "/defaultYear")
    public String getDefaultYear() {
        return tClassService.getClassDefaultYear();
    }

    @Loggable
    @GetMapping(value = "/defaultTerm/{year}")
    public Long getDefaultTerm(@PathVariable String year) {
        return tClassService.getClassDefaultTerm(year);
    }

    @Loggable
    @GetMapping(value = "/termScope")
    public List<String> getDefaultTermScope() {
        return tClassService.getClassDefaultTermScope();
    }

    @Loggable
    @GetMapping(value = "/isValidForExam/{id}")
    public BaseResponse isValidForExam(@PathVariable long id) {
        BaseResponse response = new BaseResponse();
        boolean isValidForExam = tClassService.isValidForExam(id);

        if (isValidForExam)
            response.setStatus(200);
        else
            response.setStatus(406);
        return response;
    }
    @Loggable
    @PostMapping(value = "/get-class-scoring")
    public BaseResponse checkClassScoring(@RequestBody ScoringClassDto scoringClassDto) {
        BaseResponse response = new BaseResponse();
        boolean isValidForExam = tClassService.checkClassScoring(scoringClassDto);

        if (isValidForExam)
            response.setStatus(200);
        else
            response.setStatus(406);
        return response;
    }

    @Loggable
    @GetMapping("/changeClassStatusToInProcess/{classId}")
    public ResponseEntity changeClassStatusToInProcess(@PathVariable Long classId) {

        BaseResponse response = tClassService.changeClassStatusToInProcess(classId);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/getTClassDataForScoresInEval/{classCode}")
    public TclassDTO.TClassScoreEval getTClassDataForScoresInEval(@PathVariable String classCode) {
        return tClassService.getTClassDataForScoresInEval(classCode);
    }


    @Loggable
    @GetMapping(value = "/audit/{classId}")
    public ResponseEntity<TclassDTO.InfoForAudit.TclassAuditSpecRs> getClassAuditData(@PathVariable Long classId) {
        List<TClassAudit> list=tClassService.getAuditData(classId);
        List<TclassDTO.InfoForAudit> dto = tclassAuditMapper.toTclassesResponse(list);
        final TclassDTO.SpecAuditRs specResponse = new TclassDTO.SpecAuditRs();
        final TclassDTO.TclassAuditSpecRs specRs = new TclassDTO.TclassAuditSpecRs();
        specResponse.setData(dto)
                .setStartRow(0)
                .setEndRow(dto.size())
                .setTotalRows( dto.size());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/evalAudit/{classId}/{type}")
    public ResponseEntity<TclassDTO.TClassAuditEvalSpecRs> getClassEvalAudit(@PathVariable Long classId, @PathVariable String type) {
        List<TClassAudit> list = tClassService.getAuditData(classId);
        List<TclassDTO.InfoForEvalAudit> infoList;
        List<TclassDTO.InfoForEvalAudit> data = tclassAuditMapper.toEvalAuditList(list);
        if (type.equalsIgnoreCase("student")) {
            infoList = data.stream().filter(item -> item.getStudentOnlineEvalStatus() != null).collect(Collectors.toList());
        } else
            infoList = data.stream().filter(item -> item.getTeacherOnlineEvalStatus() != null).collect(Collectors.toList());
        final TclassDTO.SpecAuditEvalRs specResponse = new TclassDTO.SpecAuditEvalRs();
        final TclassDTO.TClassAuditEvalSpecRs specRs = new TclassDTO.TClassAuditEvalSpecRs();
        specResponse.setData(infoList)
                .setStartRow(0)
                .setEndRow(infoList.size())
                .setTotalRows(infoList.size());
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/scoreDependsOnEvaluation")
    public boolean getScoreDependency() {
        return tClassService.getScoreDependency();
    }

    @Loggable
    @GetMapping(value = "/teacherForceToHasOhone")
    public boolean getTeacherForceToHasPhone() {
        return tClassService.getTeacherForceToHasPhone();
    }

    @Loggable
    @GetMapping(value = "/studentForceToHasPhone")
    public boolean getStudentForceToHasPhone() {
        return tClassService.getStudentForceToHasPhone();
    }

    @PutMapping(value = "/release-date")
    public BaseResponse updateReleaseDate(@RequestParam String date, @RequestBody List<Long> classIds) {
        BaseResponse response = new BaseResponse();
        try {
            tClassService.updateReleaseDate(classIds, date);
            response.setStatus(HttpStatus.OK.value());
        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
        }
        return response;
    }

    @Loggable
    @GetMapping(value = "/calender-spec-list")
    public ResponseEntity<TclassDTO.TclassSpecRs> listByCalender(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       HttpServletRequest iscRq) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq request = ISC.convertToSearchRq(iscRq);


        request.setStartIndex(startRow)
                .setCount(endRow - startRow);



        SearchDTO.SearchRs<TclassDTO.Info> response = tClassService.search(request);

        List<Long> classIdForCheckMessage = new ArrayList<>();

        for (TclassDTO.Info tclassDTO : response.getList()) {
            tclassDTO.setPlannerFullName("");
            tclassDTO.setSupervisorFullName("");
            tclassDTO.setOrganizerName("");

            if (tclassDTO.getPlannerId() != null) {
                Personnel planner = iPersonnelService.getPersonnel(tclassDTO.getPlannerId());
                if (planner != null) {
                    tclassDTO.setPlannerFullName(planner.getFirstName() + " " + planner.getLastName());
                }

                Personnel supervisor = iPersonnelService.getPersonnel(tclassDTO.getPlannerId());
                if (supervisor != null) {
                    tclassDTO.setSupervisorFullName(supervisor.getFirstName() + " " + supervisor.getLastName());
                }
            }
            if (tclassDTO.getOrganizerId() != null) {
                Institute institute = iInstituteService.getInstitute(tclassDTO.getOrganizerId());
                if (institute != null) {
                    tclassDTO.setOrganizerName(institute.getTitleFa());
                }
            }

            if (tclassDTO.getStudentCount() > 0 && (tclassDTO.getClassStatus().equals("1") || tclassDTO.getClassStatus().equals("2"))) {
                SearchDTO.SearchRq csSearchRq = new SearchDTO.SearchRq();
                csSearchRq.setCount(1);
                csSearchRq.setStartIndex(0);

                List<String> csSortBy = new ArrayList<>();
                csSortBy.add("sessionDate");
                csSortBy.add("sessionStartHour");
                csSearchRq.setSortBy(csSortBy);
                SearchDTO.SearchRs<ClassSessionDTO.Info> result = classSessionService.searchWithCriteria(csSearchRq, tclassDTO.getId());

                if (result.getList().size() > 0) {
                    String str = DateUtil.convertKhToMi1(result.getList().get(0).getSessionDate());
                    LocalDate date = LocalDate.parse(str);

                    if ((date.isBefore(LocalDate.now().plusDays(7)) || date.equals(LocalDate.now().plusDays(7))) && (date.isAfter(LocalDate.now()) || date.equals(LocalDate.now()))) {
                        classIdForCheckMessage.add(tclassDTO.getId());
                    }
                }
            }
        }

        if (classIdForCheckMessage.size() > 0) {
            Map<Long, Integer> classIds = tClassService.checkClassesForSendMessage(classIdForCheckMessage);

            response.getList().forEach(p -> {
                if (classIds != null && classIds.get(p.getId()) != null && classIds.get(p.getId()) > 0) {
                    p.setIsSentMessage("alarm");
                } else {
                    p.setIsSentMessage("");
                }
            });
        }

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
    @PostMapping(value = "/add-classes-educationalCalender/{eCalenderId}/{classIds}")
    public ResponseEntity<Void> addEducationalCalender( @PathVariable Long eCalenderId, @PathVariable List<Long> classIds) {
        tClassService.addEducationalCalender(eCalenderId, classIds);

        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value="deleteEducationalCalFromClass/{classId}")
    public  ResponseEntity<Void> removeEducationalCalFromClass(@PathVariable Long classId){
        tClassService.removeEducationalCalender(classId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/add-permission/spec-list")
    public ResponseEntity<TclassDTO.TclassSpecRs> listWithPermission(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "id", required = false) List<Long> ids,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse) throws IOException, NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria=criteria.replaceAll("\\s","");
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
        }

        //criteriaRq=(SearchDTO.SearchRq[])request.getCriteria().getCriteria().stream().filter(p->p.getFieldName().equals("term.id")&&p.getValue().get(0).equals("[]")).toArray();

        if (request.getCriteria() != null) {
            if (request.getCriteria().getCriteria().stream().filter(p -> (p.getFieldName() == null ? false : p.getFieldName().equals("term.id")) && p.getValue().size() == 0).toArray().length > 0) {
                ArrayList list = new ArrayList<>();
                list.add("-1000");
                ((SearchDTO.CriteriaRq) request.getCriteria().getCriteria().stream().filter(p -> p.getFieldName().equals("term.id") && p.getValue().size() == 0).toArray()[0]).setValue(list);
            }
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        if (ids != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.inSet)
                    .setFieldName("id")
                    .setValue(ids);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = ids.size();
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.CriteriaRq categoryCriteriaRq = criteriaUtil.addPermissionToCriteria("Category","course.categoryId");
        SearchDTO.CriteriaRq subCategoryCriteriaRq  = criteriaUtil.addPermissionToCriteria("SubCategory","course.subCategoryId");

        List<SearchDTO.CriteriaRq> catAndSubCatCriteriaList = new ArrayList<>();
        catAndSubCatCriteriaList.add(categoryCriteriaRq);
        catAndSubCatCriteriaList.add(subCategoryCriteriaRq);

        SearchDTO.CriteriaRq catAndSubCatCriteria = BaseService.makeNewCriteria(null,null,EOperator.or,catAndSubCatCriteriaList);
        BaseService.setCriteria(request,catAndSubCatCriteria);

        SearchDTO.SearchRs<TclassDTO.Info> response = tClassService.search(request);

        List<Long> classIdForCheckMessage = new ArrayList<>();

        for (TclassDTO.Info tclassDTO : response.getList()) {
            tclassDTO.setPlannerFullName("");
            tclassDTO.setSupervisorFullName("");
            tclassDTO.setOrganizerName("");

            if (tclassDTO.getPlannerId() != null) {
                Personnel planner = iPersonnelService.getPersonnel(tclassDTO.getPlannerId());
                if (planner != null) {
                    tclassDTO.setPlannerFullName(planner.getFirstName() + " " + planner.getLastName());
                }

                Personnel supervisor = iPersonnelService.getPersonnel(tclassDTO.getPlannerId());
                if (supervisor != null) {
                    tclassDTO.setSupervisorFullName(supervisor.getFirstName() + " " + supervisor.getLastName());
                }
            }
            if (tclassDTO.getOrganizerId() != null) {
                Institute institute = iInstituteService.getInstitute(tclassDTO.getOrganizerId());
                if (institute != null) {
                    tclassDTO.setOrganizerName(institute.getTitleFa());
                }
            }

            if (tclassDTO.getStudentCount() > 0 && (tclassDTO.getClassStatus().equals("1") || tclassDTO.getClassStatus().equals("2"))) {
                SearchDTO.SearchRq csSearchRq = new SearchDTO.SearchRq();
                csSearchRq.setCount(1);
                csSearchRq.setStartIndex(0);

                List<String> csSortBy = new ArrayList<>();
                csSortBy.add("sessionDate");
                csSortBy.add("sessionStartHour");
                csSearchRq.setSortBy(csSortBy);
                SearchDTO.SearchRs<ClassSessionDTO.Info> result = classSessionService.searchWithCriteria(csSearchRq, tclassDTO.getId());

                if (result.getList().size() > 0) {
                    String str = DateUtil.convertKhToMi1(result.getList().get(0).getSessionDate());
                    LocalDate date = LocalDate.parse(str);

                    if ((date.isBefore(LocalDate.now().plusDays(7)) || date.equals(LocalDate.now().plusDays(7))) && (date.isAfter(LocalDate.now()) || date.equals(LocalDate.now()))) {
                        classIdForCheckMessage.add(tclassDTO.getId());
                    }
                }
            }
        }

        if (classIdForCheckMessage.size() > 0) {
            Map<Long, Integer> classIds = tClassService.checkClassesForSendMessage(classIdForCheckMessage);

            response.getList().forEach(p -> {
                if (classIds != null && classIds.get(p.getId()) != null && classIds.get(p.getId()) > 0) {
                    p.setIsSentMessage("alarm");
                } else {
                    p.setIsSentMessage("");
                }
            });
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
    @GetMapping(value = "/is-personnel-registered/{national_code}")
    public Boolean isPersonnelRegistered(@PathVariable String national_code) {

        return personnelService.isPresentByNationalCodeAndActiveAndDeleted(national_code);
    }

}
