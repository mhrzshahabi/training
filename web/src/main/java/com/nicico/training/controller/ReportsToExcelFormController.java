package com.nicico.training.controller;

import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.RequestItem;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.model.ViewTrainingNeedAssessment;
import com.nicico.training.repository.ViewTrainingNeedAssessmentDAO;
import com.nicico.training.utility.MakeExcelOutputUtil;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/reportsToExcel")
public class ReportsToExcelFormController {

    private final ModelMapper modelMapper;
    private final ITclassService iTclassService;
    private final IRequestItemService requestItemService;
    private final MakeExcelOutputUtil makeExcelOutputUtil;
    private final IRequestItemService iRequestItemService;
    private final INeedsAssessmentService needsAssessmentService;
    private final ISynonymPersonnelService synonymPersonnelService;
    private final ViewTrainingNeedAssessmentDAO viewTrainingNeedAssessmentDAO;
    private final IViewNeedAssessmentInRangeTimeService iViewNeedAssessmentInRangeTimeService;

    @PostMapping(value = {"/courseNeedAssessment"})
    public void courseNeedAssessmentExcel(HttpServletResponse response, @RequestParam MultiValueMap<String, String> criteria) throws Exception {

        List<Object> resp = new ArrayList<>();

        String[] fields = Objects.requireNonNull(criteria.getFirst("fields")).split(",");
        String[] headers = Objects.requireNonNull(criteria.getFirst("headers")).split(",");
        Long categoryId = Long.valueOf(criteria.get("category").get(0));

        List<ViewTrainingNeedAssessment> viewTrainingNeedAssessments = viewTrainingNeedAssessmentDAO.findAllByCategoryId(categoryId);

        List<ViewTrainingNeedAssessmentDTO.Info> trainingNeedAssessmentData = viewTrainingNeedAssessments.stream().map(item -> modelMapper.map(item, ViewTrainingNeedAssessmentDTO.Info.class)).collect(Collectors.toList());
        resp.addAll(trainingNeedAssessmentData);

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, ViewTrainingNeedAssessmentDTO.Info.class, fields, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @PostMapping(value = {"/needsAssessmentsPerformed"})
    public void needsAssessmentsPerformed(HttpServletResponse response, @RequestParam MultiValueMap<String, String> criteria) throws Exception {

        List<Object> resp = new ArrayList<>();

        String[] fields = Objects.requireNonNull(criteria.getFirst("fields")).split(",");
        String[] headers = Objects.requireNonNull(criteria.getFirst("headers")).split(",");
        String start = String.valueOf(criteria.get("start").get(0));
        String end = String.valueOf(criteria.get("end").get(0));

        List<ViewNeedAssessmentInRangeDTO.Info> viewTrainingNeedAssessments = iViewNeedAssessmentInRangeTimeService.getList(start, end);

        resp.addAll(viewTrainingNeedAssessments);

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, ViewNeedAssessmentInRangeDTO.Info.class, fields, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @PostMapping(value = {"/masterDetail"})
    public void masterDetail(HttpServletResponse response, @RequestParam MultiValueMap<String, Object> req) throws Exception {

        Gson gson = new Gson();
        HashMap masterData = gson.fromJson((String) Objects.requireNonNull(req.getFirst("masterData")), new TypeToken<HashMap<String, String>>() {
        }.getType());
        String[] detailFields = ((String) Objects.requireNonNull(req.getFirst("detailFields"))).split(",");
        String[] detailHeaders = ((String) Objects.requireNonNull(req.getFirst("detailHeaders"))).split(",");
        String detailDto = ((String) Objects.requireNonNull(req.getFirst("detailDto")));
        String title = ((String) Objects.requireNonNull(req.getFirst("title")));
        List<Object> resp = new ArrayList<>(gson.fromJson((String) Objects.requireNonNull(req.getFirst("detailData")), new TypeToken<List<Object>>() {
        }.getType()));
        List list = new ArrayList();
        for (Object obj : resp) {
            String s = gson.toJson(obj);
            list.add(gson.fromJson(s, Class.forName(detailDto)));
        }
        byte[] bytes = makeExcelOutputUtil.makeOutputWithExtraHeader(list, Class.forName(detailDto), detailFields, detailHeaders, true, title, masterData);
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @RequestMapping("/export")
    public void exportExcel(@RequestParam("headers") String[] headers, @RequestParam("fieldNames") String[] fieldNames, HttpServletResponse response) throws Exception {

        byte[] bytes = makeExcelOutputUtil.makeOutput(new ArrayList<>(), RequestItem.class, fieldNames, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @Loggable
    @PostMapping("/competenceRequestWithItems")
    public void exportToExcel(@RequestParam("headers") String[] headers,
                              @RequestParam("fieldNames") String[] fieldNames,
                              @RequestParam("compReqId") Long compReqId,
                              @RequestParam("state") String state,
                              HttpServletResponse response) throws Exception {

        List<Object> resp = new ArrayList<>();
        List<RequestItemDTO.ExcelOutputInfo> requestItems = iRequestItemService.getItemListWithCompetenceRequest(compReqId);
        if (requestItems != null) {
            if (state.contains("گذراندن")) {
                resp.addAll(requestItems.stream().filter(item -> item.getPlanningChiefOpinion().contains("گذراندن")).collect(Collectors.toList()));
            } else if (state.contains("مانع")) {
                resp.addAll(requestItems.stream().filter(item -> item.getPlanningChiefOpinion().contains("مانع")).collect(Collectors.toList()));
            } else {
                resp.addAll(requestItems);
            }
        }

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, RequestItemDTO.ExcelOutputInfo.class, fieldNames, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @Loggable
    @PostMapping("/currentTermTeacher")
    public void currentTermTeacher(@RequestParam("termId") Long termId,
                                   HttpServletResponse response) throws Exception {

        List<Object> resp = new ArrayList<>();
        List<TclassDTO.TClassCurrentTerm> currentTermResult = iTclassService.getAllTeacherByCurrentTerm(termId);
        if (currentTermResult != null) resp.addAll(currentTermResult);

        String[] fieldNames = {"teacher.personality.nationalCode", "teacher.personality.firstNameFa", "teacher.personality.lastNameFa", "code", "titleClass", "startDate", "endDate"};
        String[] headerNames = {"کدملی استاد", "نام استاد", "نام خانوادگی استاد", "کدکلاس", "عنوان کلاس", "تاریخ شروع", "تاریخ پایان"};

        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, TclassDTO.TClassCurrentTerm.class, fieldNames, headerNames, false, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

    @Loggable
    @PostMapping("/planningExperts")
    public void planningExpertsExportToExcel(@RequestParam("headers") String[] headers,
                              @RequestParam("fieldNames") String[] fieldNames,
                              @RequestParam("requestItemIds") List<Long> requestItemIds,
                              HttpServletResponse response) throws Exception {

        List<NeedsAssessmentDTO.PlanningExpertsExcel> data = new ArrayList<>();
        for (Long requestItemId : requestItemIds) {

            SynonymPersonnel synonymPersonnel;
            SynonymPersonnel synonymPersonnelByNationalCode = null;
            SynonymPersonnel synonymPersonnelByPersonnelNo2 = null;
            RequestItem requestItem = requestItemService.get(requestItemId);

            if (requestItem != null) {
                if (requestItem.getNationalCode() != null)
                    synonymPersonnelByNationalCode = synonymPersonnelService.getByNationalCode(requestItem.getNationalCode());
                if (requestItem.getPersonnelNo2() != null)
                    synonymPersonnelByPersonnelNo2 = synonymPersonnelService.getByPersonnelNo2(requestItem.getPersonnelNo2());

                if (synonymPersonnelByNationalCode != null)
                    synonymPersonnel = synonymPersonnelByNationalCode;
                else
                    synonymPersonnel = synonymPersonnelByPersonnelNo2;

                List<NeedsAssessmentDTO.PlanningExpertsExcel> needsAssessmentDTOList = needsAssessmentService.findCoursesForPlanningExpertsByTrainingPostCode(requestItem);

                List<String> list = iTclassService.findAllPersonnelClass(synonymPersonnel.getNationalCode(), synonymPersonnel.getPersonnelNo()).stream()
                        .filter(course -> course.getScoreStateId() == 400 || course.getScoreStateId() == 401).map(TclassDTO.PersonnelClassInfo::getCourseCode).collect(Collectors.toList());
                for (NeedsAssessmentDTO.PlanningExpertsExcel course : needsAssessmentDTOList) {
                    if (!list.contains(course.getCourseCode()))
                        data.add(course);
                }
            }
        }
        List<Object> resp = new ArrayList<>(data);
        byte[] bytes = makeExcelOutputUtil.makeOutput(resp, NeedsAssessmentDTO.PlanningExpertsExcel.class, fieldNames, headers, true, "");
        makeExcelOutputUtil.makeExcelResponse(bytes, response);
    }

}

