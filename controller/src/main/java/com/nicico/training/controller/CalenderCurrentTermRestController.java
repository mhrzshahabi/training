package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.NeedsAssessmentReportsDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.service.NeedsAssessmentReportsService;
import com.nicico.training.service.ParameterService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONArray;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/calender-current-term")
public class CalenderCurrentTermRestController {
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final NeedsAssessmentReportsService needsAssessmentReportsService;
    private final TclassService tclassService;
    private final ParameterService parameterService;


    @Loggable
    @PostMapping(value = {"/print"})
    public void print(HttpServletResponse response, @RequestParam(value = "objectId") String objectId, @RequestParam(value = "objectType") String objectType, @RequestParam(value = "personnelNo") String personnelNo, @RequestParam(value = "nationalCode") String nationalCode, @RequestParam(value = "firstName") String firstName, @RequestParam(value = "lastName") String lastName, @RequestParam(value = "companyName") String companyName, @RequestParam(value = "personnelNo2") String personnelNo2, @RequestParam(value = "postTitle") String postTitle, @RequestParam(value = "postCode") String postCode) throws Exception {
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> list;
        List<TclassDTO.PersonnelClassInfo> totalPersonnelClass;
        TotalResponse<ParameterValueDTO.Info> NeedsAssessmentPriorityParameter;
        TotalResponse<ParameterValueDTO.Info> competenceTypeParameter;
        TotalResponse<ParameterValueDTO.Info> NeedsAssessmentDomainParameter;
        Map<String, String> NeedsAssessmentPriorityParameterMap = new HashMap<String, String>();//اولویت نیازسنجی
        Map<String, String> competenceTypeParameterMap = new HashMap<String, String>();//نوع شایستگی
        Map<String, String> NeedsAssessmentDomainParameterMap = new HashMap<String, String>();//حیطه نیازسنجی
        //List<List<TclassDTO.PersonnelClassInfo>> y=null;
        list = needsAssessmentReportsService.search(null, Long.parseLong(objectId), objectType, personnelNo);//دوره های نیازسنجی
        //  totalPersonnelClass=tclassService.findAllPersonnelClass("2559979705");//کل کلاس های فرد
        // Long count=list.getTotalCount();
        // for (int i = 0; i <count ; i++) {
        // (list.getList().get(i).getSkill().getCourse().getCode());
        //  y.add(tclassService.PersonnelClass(list.getList().get(i).getSkill().getCourse().getId()));
        // }

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
        Long count = list.getTotalCount();
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
        reportUtil.export("/reports/CalenderCurrentTerm.jasper", params, jsonDataSource, response);

    }
}
