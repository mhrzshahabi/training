package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.NeedsAssessmentReportsDTO;
import com.nicico.training.dto.CalenderCurrentTermDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.service.ClassAlarmService;
import com.nicico.training.service.NeedsAssessmentReportsService;
import com.nicico.training.service.ParameterService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONArray;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final NeedsAssessmentReportsService needsAssessmentReportsService;
    private final ClassAlarmService classAlarmService;
    private final TclassService tclassService;
    private final ParameterService parameterService;


    private <T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, SearchDTO.CriteriaRq criteria, Class<T> infoType) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
       startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("startDate", dateUtil.todayDate(), EOperator.lessOrEqual, new ArrayList<>());
        SearchDTO.CriteriaRq criteriaRq2 = makeNewCriteria("endDate", dateUtil.todayDate(), EOperator.greaterThan, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        criteriaRq.getCriteria().add(criteriaRq1);
        criteriaRq.getCriteria().add(criteriaRq2);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<T> searchRs = tclassService.search1(searchRq, infoType);
        return new ResponseEntity<ISC<T>>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

       @Loggable
    @GetMapping(value = "/spec-list")
    public ResponseEntity<ISC<TclassDTO.Info>> attendanceList(HttpServletRequest iscRq) throws IOException {
        return search(iscRq, makeNewCriteria(null, null, EOperator.or, null),TclassDTO.Info.class);
    }

    @Loggable
    //@GetMapping(value = "/spec-list")

    public ResponseEntity<TclassDTO.TclassSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                       @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                       @RequestParam(value = "_constructor", required = false) String constructor,
                                                       @RequestParam(value = "operator", required = false) String operator,
                                                       @RequestParam(value = "criteria", required = false) String criteria,
                                                       @RequestParam(value = "_sortBy", required = false) String sortBy, HttpServletResponse httpResponse, HttpServletRequest iscRq) throws IOException {


        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));

              SearchDTO.CriteriaRq criteriaRq0 = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
              SearchDTO.CriteriaRq criteriaRq1 = makeNewCriteria("startDate", dateUtil.todayDate(), EOperator.lessOrEqual, new ArrayList<>());
              SearchDTO.CriteriaRq criteriaRq2 = makeNewCriteria("endDate", dateUtil.todayDate(), EOperator.greaterThan, new ArrayList<>());
              criteriaRq0.getCriteria().add(criteriaRq);
              criteriaRq0.getCriteria().add(criteriaRq1);
              criteriaRq0.getCriteria().add(criteriaRq2);

            request.setCriteria(criteriaRq0);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TclassDTO.Info> response = tclassService.search(request);

        for (TclassDTO.Info tclassDTO : response.getList()) {
            if (classAlarmService.hasAlarm(tclassDTO.getId(), httpResponse).size() > 0)
                tclassDTO.setHasWarning("alarm");
            else
                tclassDTO.setHasWarning("");
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
    @GetMapping(value = {"/print"})
    public  ResponseEntity<CalenderCurrentTermDTO.CalenderCurrentTermSpecRs> print(HttpServletResponse response, @RequestParam(value = "objectId") String objectId, @RequestParam(value = "objectType") String objectType, @RequestParam(value = "personnelNo") String personnelNo, @RequestParam(value = "nationalCode") String nationalCode, @RequestParam(value = "firstName") String firstName, @RequestParam(value = "lastName") String lastName, @RequestParam(value = "companyName") String companyName, @RequestParam(value = "personnelNo2") String personnelNo2, @RequestParam(value = "postTitle") String postTitle, @RequestParam(value = "postCode") String postCode) throws Exception {
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> list;
        List<TclassDTO.PersonnelClassInfo> totalPersonnelClass;
        TotalResponse<ParameterValueDTO.Info> NeedsAssessmentPriorityParameter;
        TotalResponse<ParameterValueDTO.Info> competenceTypeParameter;
        TotalResponse<ParameterValueDTO.Info> NeedsAssessmentDomainParameter;
        Map<String, String> NeedsAssessmentPriorityParameterMap = new HashMap<String, String>();//اولویت نیازسنجی
        Map<String, String> competenceTypeParameterMap = new HashMap<String, String>();//نوع شایستگی
        Map<String, String> NeedsAssessmentDomainParameterMap = new HashMap<String, String>();//حیطه نیازسنجی

        List<CalenderCurrentTermDTO.tclass> y = new ArrayList<>();

        list = needsAssessmentReportsService.search(null, Long.parseLong(objectId), objectType, personnelNo);//دوره های نیازسنجی
        // totalPersonnelClass=tclassService.findAllPersonnelClass("2559979705");//کل کلاس های فرد
        Long count = list.getTotalCount();
        for (int i = 0; i < count; i++) {
            for (int j = 0; j < tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).size(); j++) {
                String x1 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getCourse().getCode());
                String x2 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getTitleClass());
                String x3 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getCode());
                String x4 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getStartDate());
                String x5 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getEndDate());
                Long x6 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getHDuration());
                String x7 = (tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()).get(j).getClassStatus());
                y.add(new CalenderCurrentTermDTO.tclass(x1, x2, x3, x4, x5, x6, x7));

            }
        }
        SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
       for(int i=0;i<=y.size();i++)
       {

       if(!((format.parse(y.get(i).getStartDate()).before(format.parse(dateUtil.todayDate())))  && (format.parse(y.get(i).getEndDate()).after(format.parse(dateUtil.todayDate())))))
           {
            y.remove(i);
           }
       }

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
        params.put("todayDate", dateUtil.todayDate());
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
