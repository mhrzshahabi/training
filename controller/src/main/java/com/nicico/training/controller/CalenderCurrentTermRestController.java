package com.nicico.training.controller;

import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONArray;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/calenderCurrentTerm")
public class CalenderCurrentTermRestController {
    private final NeedsAssessmentReportsService needsAssessmentReportsService;

    private final ITclassService tclassService;
    private final IParameterService parameterService;
    private final IClassStudentReportService classStudentReportService;
    private final IPostService postService;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;


    private <T> ResponseEntity<ISC<T>> search1(HttpServletRequest iscRq, SearchDTO.CriteriaRq criteria, Class<T> infoType) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("startDate", DateUtil.todayDate(), EOperator.lessOrEqual, new ArrayList<>());
        SearchDTO.CriteriaRq criteriaRq2 = makeNewCriteria("endDate", DateUtil.todayDate(), EOperator.greaterThan, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        criteriaRq.getCriteria().add(criteriaRq1);
        criteriaRq.getCriteria().add(criteriaRq2);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);

        SearchDTO.SearchRs<CalenderCurrentTermDTO.CourseInfo> x = new SearchDTO.SearchRs<>();

        x.setList((List<CalenderCurrentTermDTO.CourseInfo>) tclassService.search1(searchRq, infoType).getList());

        for (int z = 0; z < x.getList().size(); z++) {
            for (int i = 0; i < x.getList().size(); i++) {
                for (int j = i + 1; j < x.getList().size(); j++) {
                    if (x.getList().get(i).getCourse().getCode().equals(x.getList().get(j).getCourse().getCode())) {
                        x.getList().remove(i);
                    }
                }
            }
        }

        Long personnelId = null;
        Long postId = null;
        SearchDTO.CriteriaRq cri = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        cri.getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
        cri.getCriteria().add(makeNewCriteria("nationalCode", SecurityUtil.getNationalCode(), EOperator.equals, null));
        List<PersonnelDTO.Info> personnelList = personnelService.search(new SearchDTO.SearchRq().setCriteria(cri)).getList();
        if (personnelList.isEmpty()) {
            List<PersonnelRegisteredDTO.Info> personnelRegisteredList = personnelRegisteredService.search(new SearchDTO.SearchRq().setCriteria(cri)).getList();
            if (!personnelRegisteredList.isEmpty()) {
                personnelId = personnelRegisteredList.get(0).getId();
                postId = postService.getByPostCode(personnelRegisteredList.get(0).getPostCode()).getId();
            }
        } else {
            personnelId = personnelList.get(0).getId();
            postId = postService.getByPostCode(personnelList.get(0).getPostCode()).getId();
        }

        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> list = null;
        if (postId != null && personnelId != null)
            list = needsAssessmentReportsService.search(null, postId, "Post", personnelId);


        if (list != null && list.getList().size() > 0) {
            for (int i = 0; i < list.getList().size(); i++) {
                for (int j = 0; j < x.getList().size(); j++) {
                    if (list.getList().get(i).getSkill().getCourse().getCode().equals(x.getList().get(j).getCourse().getCode())) {
                        x.getList().get(j).getCourse().setEvaluation("نیازسنجی");
                    } else if (!(x.getList().get(j).getCourse().getEvaluation().equals("نیازسنجی"))) {
                        x.getList().get(j).getCourse().setEvaluation("غیر نیازسنجی");
                    }
                }
            }
        } else {
            for (int j = 0; j < x.getList().size(); j++) {
                x.getList().get(j).getCourse().setEvaluation("غیر نیازسنجی");
            }
        }


        x.setTotalCount(tclassService.search1(searchRq, infoType).getTotalCount());
        SearchDTO.SearchRs<T> searchRs = (SearchDTO.SearchRs<T>) x;
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<CalenderCurrentTermDTO.CourseInfo>> spectList(HttpServletRequest iscRq) throws IOException {
        return search1(iscRq, makeNewCriteria(null, null, EOperator.or, null), CalenderCurrentTermDTO.CourseInfo.class);
    }


    private <T> ResponseEntity<ISC<T>> search2(HttpServletRequest iscRq, SearchDTO.CriteriaRq criteria, Class<T> infoType) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("startDate", DateUtil.todayDate(), EOperator.lessOrEqual, new ArrayList<>());
        SearchDTO.CriteriaRq criteriaRq2 = makeNewCriteria("endDate", DateUtil.todayDate(), EOperator.greaterThan, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        criteriaRq.getCriteria().add(criteriaRq1);
        criteriaRq.getCriteria().add(criteriaRq2);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<T> searchRs = tclassService.search1(searchRq, infoType);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/speclist")
    public ResponseEntity<ISC<CalenderCurrentTermDTO.CourseInfo>> spectListAllClass(HttpServletRequest iscRq) throws IOException {
        return search2(iscRq, makeNewCriteria(null, null, EOperator.or, null), CalenderCurrentTermDTO.CourseInfo.class);
    }

    @Transactional(readOnly = true)
    @Loggable
    @GetMapping(value = {"/needassessmentClass"})
    public ResponseEntity<CalenderCurrentTermDTO.CalenderCurrentTermSpecRs> print(HttpServletResponse response, @RequestParam(value = "personnelId") Long personnelId, @RequestParam(value = "objectId") String objectId, @RequestParam(value = "objectType") String objectType, @RequestParam(value = "personnelNo") String personnelNo, @RequestParam(value = "nationalCode") String nationalCode, @RequestParam(value = "firstName") String firstName, @RequestParam(value = "lastName") String lastName, @RequestParam(value = "companyName") String companyName, @RequestParam(value = "personnelNo2") String personnelNo2, @RequestParam(value = "postTitle") String postTitle, @RequestParam(value = "postCode") String postCode) throws Exception {
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> list;
        TotalResponse<ParameterValueDTO.Info> NeedsAssessmentPriorityParameter;
        TotalResponse<ParameterValueDTO.Info> competenceTypeParameter;
        TotalResponse<ParameterValueDTO.Info> NeedsAssessmentDomainParameter;
        Map<String, String> NeedsAssessmentPriorityParameterMap = new HashMap<String, String>();//اولویت نیازسنجی
        Map<String, String> competenceTypeParameterMap = new HashMap<>();//نوع شایستگی
        Map<String, String> NeedsAssessmentDomainParameterMap = new HashMap<String, String>();//حیطه نیازسنجی

        List<CalenderCurrentTermDTO.tclass> y = new ArrayList<>();//لیست کلاسهای فرد بر اساس دوره های ترم جاری
        List<ClassStudent> classStudents = null;//لیست کلاس هایی که فرد ثبت نام شده
        list = needsAssessmentReportsService.search(null, Long.parseLong(objectId), objectType, personnelId);//دوره های نیازسنجی
        // totalPersonnelClass=tclassService.findAllPersonnelClass("2559979705");//کل کلاس های فرد
        Long count = list.getTotalCount();
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).size(); j++) {
                Long x0 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getId());
                String x1 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getCourse().getCode());
                String x2 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getTitleClass());
                String x3 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getCode());
                String x4 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getStartDate());
                String x5 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getEndDate());
                Long x6 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getHDuration());
                String x7 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getClassStatus());
                y.add(new CalenderCurrentTermDTO.tclass(x0, x1, x2, x3, x4, x5, x6, x7, "0"));

            }
        }
        SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");

        for (int z = 0; z < y.size(); z++) {
            for (int i = 0; i < y.size(); i++) {
                if (((format.parse(y.get(i).getStartDate()).before(format.parse(DateUtil.todayDate()))) && (format.parse(y.get(i).getEndDate()).after(format.parse(DateUtil.todayDate()))))) {

                } else {
                    y.remove(i);
                }
            }
        }

        classStudents = classStudentReportService.searchClassRegisterOfStudentByNationalCode(nationalCode);


        for (int i = 0; i < y.size(); i++) {
            for (ClassStudent x : classStudents) {
                if (y.get(i).getId().equals(x.getTclassId())) {
                    y.get(i).setStatusRegister("1");
                    //  y.get(i).setScoresState(x.getScoresState());
                } else {
                }
                // y.get(i).setStatusRegister("0");
            }
        }

        for (int z = 0; z < y.size(); z++) {
            for (int i = 0; i < y.size(); i++) {
                for (int j = i + 1; j < y.size(); j++) {
                    if ((y.get(i).getCorseCode().equals(y.get(j).getCorseCode())) && (y.get(i).getStatusRegister().equals("1"))) {
                        y.remove(j);
                    } else {
                        if ((y.get(i).getCorseCode().equals(y.get(j).getCorseCode())) && (y.get(i).getStatusRegister().equals("0") && y.get(j).getStatusRegister().equals("1"))) {
                            y.remove(i);
                        }
                    }
                }
            }
        }

//        List<StudentClassReportViewDTO.InfoTuple> infoList=studentClassReportViewService.listTuple();
//        for (int i=0;i<infoList.size();i++) {
//            for(int j=0;j<y.size();j++)
//            {
//                if((infoList.get(i).getCourseCode().equals(y.get(j))) && (infoList.get(i).getStudentNationalCode().equals(nationalCode)))
//                {
//                   y.get(j).setClassState(infoList.get(i).getClassStudentScoresState());
//                }
//            }
//        }
        final CalenderCurrentTermDTO.SpecRs specResponse = new CalenderCurrentTermDTO.SpecRs();
        final CalenderCurrentTermDTO.CalenderCurrentTermSpecRs specRs = new CalenderCurrentTermDTO.CalenderCurrentTermSpecRs();


        if (y != null) {
            specResponse.setData(y)
                    .setStartRow(0)
                    .setEndRow(y.size())
                    .setTotalRows(y.size());
            specRs.setResponse(specResponse);
        }
        NeedsAssessmentPriorityParameter = parameterService.getByCode("NeedsAssessmentPriority");
        for (int i = 0; i < NeedsAssessmentPriorityParameter.getResponse().getData().size(); i++) {
            NeedsAssessmentPriorityParameter.getResponse().getData().get(i).getTitle();
            NeedsAssessmentPriorityParameterMap.put(String.valueOf(NeedsAssessmentPriorityParameter.getResponse().getData().get(i).getId()), NeedsAssessmentPriorityParameter.getResponse().getData().get(i).getTitle());
        }
        competenceTypeParameter = parameterService.getByCode("competenceType");
        for (int i = 0; i < competenceTypeParameter.getResponse().getData().size(); i++) {
            competenceTypeParameter.getResponse().getData().get(i).getTitle();
            competenceTypeParameterMap.put(String.valueOf(competenceTypeParameter.getResponse().getData().get(i).getId()), competenceTypeParameter.getResponse().getData().get(i).getTitle());
        }
        NeedsAssessmentDomainParameter = parameterService.getByCode("NeedsAssessmentDomain");
        for (int i = 0; i < NeedsAssessmentDomainParameter.getResponse().getData().size(); i++) {
            NeedsAssessmentDomainParameter.getResponse().getData().get(i).getTitle();
            NeedsAssessmentDomainParameterMap.put(String.valueOf(NeedsAssessmentDomainParameter.getResponse().getData().get(i).getId()), NeedsAssessmentDomainParameter.getResponse().getData().get(i).getTitle());
        }

        JSONArray jsonArray = new JSONArray();
        JSONParser parser = new JSONParser();
        for (int i = 0; i < count; i++) {
            String jsonInString = new Gson().toJson(list.getList().get(i));
            //needsAssessmentPriorityId
            JSONObject json = (JSONObject) parser.parse(jsonInString);
            json.put("AssessmentPriority", NeedsAssessmentPriorityParameterMap.get(json.getAsString("needsAssessmentPriorityId")));
            json.put("NeedsAssessmentDomain", NeedsAssessmentDomainParameterMap.get(json.getAsString("needsAssessmentDomainId")));
            json.put("competenceType", competenceTypeParameterMap.get(String.valueOf(list.getList().get(i).getCompetence().getCompetenceTypeId())));
            jsonArray.put(json);
            // jsonArray.getJSONObject(0).getJSONObject("competence").put("1","1");
            // jsonArray.getJSONObject(0).getJSONObject("competence").getString("competenceTypeId");
        }

        //  String data = "{" + "\"calenderCurrentTerm\": " + jsonArray + "," +  "\"PersonnelClass\": " + objectMapper.writeValueAsString(totalPersonnelClass) + "}";
        String data = "{" + "\"calenderCurrentTerm\": " + jsonArray + "}";
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", DateUtil.todayDate());
        params.put("personnelNo", personnelNo);
        params.put("nationalCode", nationalCode);
        params.put("firstName", firstName);
        params.put("lastName", lastName);
        params.put("companyName", companyName);
        params.put("personnelNo2", personnelNo2);
        params.put("postTitle", postTitle);
        params.put("postCode", postCode);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        //  reportUtil.export("/reports/CalenderCurrentTerm.jasper", params, jsonDataSource, response);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
