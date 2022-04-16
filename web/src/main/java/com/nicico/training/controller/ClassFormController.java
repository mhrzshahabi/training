package com.nicico.training.controller;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.model.Coordinate;
import com.nicico.training.utility.PersianCharachtersUnicode;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JsonDataSource;
import net.sf.jasperreports.engine.util.JRLoader;
import org.activiti.engine.impl.util.json.JSONObject;
import org.codehaus.jackson.annotate.JsonMethod;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.sql.SQLException;
import java.util.*;

@RequiredArgsConstructor
@Controller
@RequestMapping("/tclass")
public class ClassFormController {
    private final OAuth2AuthorizedClientService authorizedClientService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;


    @RequestMapping("/show-form")
    public String showForm() {
        return "base/class";
    }

    @GetMapping("/printWithCriteria/{type}")
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String type) {
        String token = (String) request.getSession().getAttribute("AccessToken");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/PDF", HttpMethod.POST, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
        else
            return null;
    }

    @RequestMapping("/sessions-tab")
    public String sessionsTab() {
        return "classTabs/sessions";
    }

    @RequestMapping("/alarms-tab")
    public String alarmsTab() {
        return "classTabs/alarms";
    }

    @RequestMapping("/licenses-tab")
    public String licensesTab() {
        return "classTabs/licenses";
    }

    @RequestMapping("/attendance-tab")
    public String attendanceTab() {
        return "classTabs/attendance";
    }

    @RequestMapping("/exam-tab")
    public String examTab() {
        return "classTabs/exam";
    }

    @RequestMapping("/teachers-tab")
    public String teachersTab() {
        return "classTabs/teachers";
    }

    @RequestMapping("/assessment-tab")
    public String assessmentTab() {
        return "classTabs/assessment";
    }

    @RequestMapping("/checkList-tab")
    public String checkListTab() {
        return "classTabs/checkList";
    }

    @RequestMapping("/attachments-tab")
    public String attachmentsTab() {
        return "base/attachments";
    }

    @RequestMapping("/student")
    public String showStudentsForm() {
        return "classTabs/student";
    }

    @RequestMapping("/scores-tab")
    public String scoresTab() {
        return "classTabs/scores";
    }

    @RequestMapping("/cost-class-tab")
    public String costclasstabTab() {
        return "classTabs/costClass";
    }

    @RequestMapping("/classDocuments-tab")
    public String classDocumentsTab() {
        return "classTabs/classDocuments";
    }

    @RequestMapping("/pre-course-test-questions-tab")
    public String preCourseQuestionsTab() {
        return "classTabs/preCourseTestQuestions";
    }

    @RequestMapping("/teacher-information-tab")
    public String techerInformationTab() {
        return "classTabs/teacherInformation";
    }

    @RequestMapping("/evaluation-info-tab")
    public String evaluationInfoTab() {
        return "classTabs/classEvaluationInfo";
    }

    @RequestMapping("/class-costs-tab")
    public String classCostsTab() {
        return "classTabs/classCosts";
    }
    @RequestMapping("/class-finish-tab")
    public String classFinishTab() {
        return "classTabs/lockClass";
    }

    @PostMapping("/reportPrint/{type}")
    public ResponseEntity<?> reportPrint(final HttpServletRequest request, @PathVariable String type) {
        String token = request.getParameter("token");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        JSONObject dataParams = new JSONObject(request.getParameter("data"));

        MultiValueMap<String, String> params = new LinkedMultiValueMap();
        params.add("courseInfo",dataParams.get("courseInfo").toString());
        params.add("classTimeInfo",dataParams.get("classTimeInfo").toString());
        params.add("executionInfo",dataParams.get("executionInfo").toString());;
        params.add("evaluationInfo",dataParams.get("evaluationInfo").toString());
        params.add("CriteriaStr", request.getParameter("CriteriaStr").toString());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        switch (type) {
            case "pdf":
                return restTemplate.exchange(restApiUrl + "/api/tclass/reportPrint/PDF", HttpMethod.POST, entity, byte[].class);
            case "excel":
                return restTemplate.exchange(restApiUrl + "/api/tclass/reportPrint/EXCEL", HttpMethod.POST, entity, byte[].class);
            case "html":
                return restTemplate.exchange(restApiUrl + "/api/tclass/reportPrint/HTML", HttpMethod.POST, entity, byte[].class);
            default:
                return null;
        }
    }

    @PostMapping(value = {"/chartPrint/{type}"})
    public void chartPrint(HttpServletResponse response, @PathVariable String type, @RequestParam(value = "list") String list) throws SQLException, IOException, JRException {

        Gson gson = new Gson();
        Type resultType = new TypeToken<List<TclassDTO.TeachingHistory>>() {
        }.getType();
        List<TclassDTO.TeachingHistory> allData = gson.fromJson(list, resultType);

        List<Coordinate> xyData = new ArrayList<>();
        final Integer[] count = {1};
        String seriesName=PersianCharachtersUnicode.bidiReorder(" نمودار رضایت فراگیر از استاد");
        allData.forEach(item -> {
            xyData.add(new Coordinate(count[0], item.getEvaluationGrade(), seriesName));
            ++count[0];
        });
//        double[] d = {1, 2, 3, 4, 5, 6, 7, 8, 9};
//        List<Coordinate> xyData = new ArrayList<>();
//        int year = 2000;
//        for (int j = 0; j < d.length; j++) {
//            xyData.add(new Coordinate(year, d[j], "xy chart"));
//            year++;
//        }
//        InputStream inputStream = getClass().getResourceAsStream("/reports/satisfactionChart.jasper");

//        JasperReport jasperReport = (JasperReport) JRLoader.loadObject(inputStream);
        Map<String, Object> parameters = new HashMap<>();
      parameters.put("CHART_DATA",xyData);

       xyData.stream().forEach(xy->{
           parameters.put("horizontal",xy.getHorizontal());
           parameters.put("vertical",xy.getVertical());
           parameters.put("seriesName",xy.getSeriesName());


       });
//        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, new JREmptyDataSource());
//        File output = new File("main/src/main/resources/reports/demo_report.pdf");
//        output.createNewFile();
//        OutputStream outputStream = new FileOutputStream(output,false);
//        JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream);
//        outputStream.close();
//        String type = "pdf";
        parameters.put(ConstantVARs.REPORT_TYPE, type);
//        objectMapper.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
//
        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(xyData) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/satisfactionChart.jasper", parameters,jsonDataSource, response);
    }
}
