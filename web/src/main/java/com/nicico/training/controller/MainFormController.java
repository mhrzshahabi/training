package com.nicico.training.controller;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/web")
@RequiredArgsConstructor
public class MainFormController {

    @RequestMapping("/parameter")
    public String showParameterForm() {
        return "basic/parameter";
    }

    @RequestMapping("/trainingFile")
    public String showTrainingFileForm() {
        return "report/trainingFile";
    }

    @RequestMapping("/studentClassReport")
    public String showPersonalCoursesForm() {
        return "report/studentClassReport";
    }

    @RequestMapping("/courseWithOutTeacherReaport")
    public String courseWithOutTeacherReaport(){return "report/courseWithOutTeacherReaport";}

    @RequestMapping("/personnelCourseNotPassed")
    public String showPersonalCoursesNotPassedForm() {
        return "report/personnelCourseNotPassed";
    }

    @RequestMapping("/trainingOverTime")
    public String showTrainingOverTime() {
        return "report/trainingOverTime";
    }

    @RequestMapping("/needsAssessment-reports")
    public String showNeedsAssessmentReportsForm() {
        return "report/needsAssessmentReports";
    }

    @RequestMapping("/calenderCurrentTerm")
     public String showCalenderCurrentTerm(){return "report/calenderCurrentTerm";}

     @RequestMapping("/classOutsideCurrentTerm")
     public String showclassOutsideCurrentTerm(){return "report/classOutsideCurrentTerm";}

    @RequestMapping("/oaUser")
    public String showOaUserForm() {
        return "security/user";
    }

    @RequestMapping("/oaRole")
    public String showOaRoleForm() {
        return "security/role";
    }

    @RequestMapping("/oaGroup")
    public String showOaGroupForm() {
        return "security/group";
    }

    @RequestMapping("/oaPermission")
    public String showOaPermissionForm() {
        return "security/permission";
    }

    @RequestMapping("/job")
    public String showJobForm() {
        return "base/job";
    }

    @RequestMapping("/postGrade")
    public String showPostGradeForm() {
        return "base/postGrade";
    }

    @RequestMapping("/post")
    public String showPostForm() {
        return "base/post";
    }

    @RequestMapping("/post-group")
    public String showPostGroupForm() {
        return "base/post-group";
    }

    @RequestMapping("/needAssessment")
    public String showNeedAssessmentForm() {
        return "base/needAssessmentNew1";
    }

    @RequestMapping("/postGradeGroup")
    public String showPostGradeGroupForm() {
        return "base/postGradeGroup";
    }

    @RequestMapping("/needAssessmentSkillBased")
    public String showNeedAssessmentSkillBasedForm() {
        return "base/needAssessmentSkillBased";
    }

    @RequestMapping("/config")
    public String showConfigForm() {
        return "security/config";
    }

    @RequestMapping("/config-questionnaire")
    public String showConfigQuestionnaireForm() {
        return "base/configQuestionnaire";
    }

    @RequestMapping("/monthlyStatisticalReport")
    public String showMonthlyStatisticalReportForm() {
        return "report/monthlyStatisticalReport";
    }

    @RequestMapping("/categoriesPerformanceReport")
    public String showCategoriesPerformanceReportForm() {
        return "report/categoriesPerformanceReport";
    }

    @RequestMapping("class-contract")
    public String showClassContractForm() {
        return "run/class-contract";
    }

    @PostMapping("/print/{entityUrl}/{type}")
    public ResponseEntity<?> printList(final HttpServletRequest request, @PathVariable String entityUrl, @PathVariable String type) {
        String token = request.getParameter("myToken");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));
        map.add("params", request.getParameter("params"));
        map.add("formData", request.getParameter("formData"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        switch (type) {
            case "pdf":
                return restTemplate.exchange(restApiUrl + "/api/" + entityUrl + "/print/PDF", HttpMethod.POST, entity, byte[].class);
            case "excel":
                return restTemplate.exchange(restApiUrl + "/api/" + entityUrl + "/print/EXCEL", HttpMethod.POST, entity, byte[].class);
            case "html":
                return restTemplate.exchange(restApiUrl + "/api/" + entityUrl + "/print/HTML", HttpMethod.POST, entity, byte[].class);
            default:
                return null;
        }
    }

    @RequestMapping("/questionnaire")
    public String showQuestionnaireForm() {
        return "evaluation/questionnaire";
    }

    @GetMapping("/competence")
    public String showCompetenceForm() {
        return "needsAssessment/competence";
    }

    @GetMapping("/needsAssessment")
    public String showNeedsAssessmentForm() {
        return "needsAssessment/needsAssessment";
    }

    @RequestMapping("/work-group")
    public String showWorkGroupForm() {
        return "security/workGroup";
    }

    @RequestMapping("/course-needs-assessment-reports")
    public String showCourseNAReportsForm() {
        return "planning/courseNAReports";
    }

    @RequestMapping("/student-portal")
    public String showStudentPortalForm() {
        return "portal/studentPortal";
    }

    @RequestMapping("/personnel-course-NA-report")
    public String showPersonnelCourseNAReportForm() {
        return "report/personnelCourseNAReportV2";
    }

    @PostMapping("/personnel-needs-assessment-report-print/{type}")
    public ResponseEntity<?> printPersonnelNeedsAssessmentReport(final HttpServletRequest request, @PathVariable String type) {
        String token = request.getParameter("myToken");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        map.add("essentialRecords", request.getParameter("essentialRecords"));
        map.add("improvingRecords", request.getParameter("improvingRecords"));
        map.add("developmentalRecords", request.getParameter("developmentalRecords"));
        map.add("totalEssentialHours", request.getParameter("totalEssentialHours"));
        map.add("passedEssentialHours", request.getParameter("passedEssentialHours"));
        map.add("totalImprovingHours", request.getParameter("totalImprovingHours"));
        map.add("passedImprovingHours", request.getParameter("passedImprovingHours"));
        map.add("totalDevelopmentalHours", request.getParameter("totalDevelopmentalHours"));
        map.add("passedDevelopmentalHours", request.getParameter("passedDevelopmentalHours"));
        map.add("personnel", request.getParameter("personnel"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        switch (type) {
            case "pdf":
                return restTemplate.exchange(restApiUrl + "/api/needsAssessment-reports/print-course-list-for-a-personnel/PDF", HttpMethod.POST, entity, byte[].class);
            case "excel":
                return restTemplate.exchange(restApiUrl + "/api/needsAssessment-reports/print-course-list-for-a-personnel/EXCEL", HttpMethod.POST, entity, byte[].class);
            case "html":
                return restTemplate.exchange(restApiUrl + "/api/needsAssessment-reports/print-course-list-for-a-personnel/HTML", HttpMethod.POST, entity, byte[].class);
            default:
                return null;
        }
    }

    @PostMapping("/calender_current_term")
    public ResponseEntity<?> calenderCurrentTermReport(final HttpServletRequest request, @RequestParam Long objectId,
                                                       @RequestParam String objectType,
                                                       @RequestParam(required = false) String personnelNo, @RequestParam String nationalCode, @RequestParam String firstName, @RequestParam String lastName, @RequestParam String companyName, @RequestParam String personnelNo2, @RequestParam String postTitle, @RequestParam String postCode)
    {
//       String token;
//          String header_authorization = request.getHeader("Authorization");
//          String[] splitted = header_authorization.split(" ");
//                if (!"Bearer".equals(splitted[0])) {
//                 token = splitted[0];
//                }
//                else
//        token = splitted[1];
        String token = request.getParameter("token");
        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        map.add("objectId",String.valueOf(objectId));
        map.add("objectType",objectType);
        map.add("personnelNo",personnelNo);
        map.add("nationalCode",nationalCode);
        map.add("firstName",firstName);
        map.add("lastName",lastName);
        map.add("companyName",companyName);
        map.add("personnelNo2",personnelNo2);
        map.add("postTitle",postTitle);
        map.add("postCode",postCode);
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);
        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        return restTemplate.exchange(restApiUrl + "/api/calenderCurrentTerm/print", HttpMethod.POST, entity, byte[].class);

    }

}
