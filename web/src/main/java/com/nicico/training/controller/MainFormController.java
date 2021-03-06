package com.nicico.training.controller;

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

    @RequestMapping("/organizationalChart")
    public String showOrganizationalChartForm() {
        return "basic/organizationalChart";
    }

    @RequestMapping("/departmentChart")
    public String showDepartmentChartForm() {
        return "basic/departmentChart";
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
    public String courseWithOutTeacherReaport() {
        return "report/courseWithOutTeacherReaport";
    }

    @RequestMapping("/annualStatisticalReportBySections")
    public String annualStatisticalReport() {
        return "report/annualStatisticalReportBySections";
    }

    @RequestMapping("/personnelCourseNotPassed")
    public String showPersonalCoursesNotPassedForm() {
        return "report/personnelCourseNotPassed";
    }

    @RequestMapping("/trainingOverTime")
    public String showTrainingOverTime() {
        return "report/trainingOverTime";
    }

    @RequestMapping("/attendanceReport")
    public String showAttendanceReport() {
        return "report/attendanceReport";
    }

    @RequestMapping("/controlReport")
    public String showControlReport() {
        return "report/controlReport";
    }

    @RequestMapping("/needsAssessment-reports")
    public String showNeedsAssessmentReportsForm() {
        return "report/needsAssessmentReports";
    }

    @RequestMapping("/needsAssessment-reports-pi")
    public String showNeedsAssessmentReportsPIForm() {
        return "report/needsAssessmentReportsPI";
    }

    @RequestMapping("/need.assessment-group-job-promotion-report")
    public String showNeedAssessmentGroupJobPromotionReportForm() {
        return "report/needAssessmentGroupJobPromotionReport";
    }

    @RequestMapping("/calenderCurrentTerm")
    public String showCalenderCurrentTerm() {
        return "report/calenderCurrentTerm";
    }

    @RequestMapping("/classOutsideCurrentTerm")
    public String showclassOutsideCurrentTerm() {
        return "report/classOutsideCurrentTerm";
    }

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

    @RequestMapping("/training-post")
    public String showTrainingPostForm() {
        return "base/training-post";
    }

    @RequestMapping("/certification")
    public String showCertificationForm() {
        return "base/certification";
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
    @RequestMapping("/v2/config")
    public String showNewConfigForm() {
        return "security/newConfig";
    }

    @RequestMapping("/usersLoginReport")
    public String showUsersLoginReportForm() {
        return "security/usersLoginReport";
    }

    @RequestMapping("/operationalRole")
    public String showOperationalRoleForm() {
        return "security/operationalRole";
    }

    @RequestMapping("/config-questionnaire")
    public String showConfigQuestionnaireForm() {
        return "base/configQuestionnaire";
    }

    @RequestMapping("/monthlyStatisticalReport")
    public String showMonthlyStatisticalReportForm() {
        return "report/monthlyStatisticalReport";
    }

    @RequestMapping("/evaluationStaticalReport")
    public String showEvaluationStaticalReportForm() {
        return "report/evaluationStaticalReport";
    }

    @RequestMapping("/evaluationDoneOnlineReport")
    public String showEvaluationDoneOnlineReportForm() {
        return "report/evaluationDoneOnlineReport";
    }

    @RequestMapping("/doneOnlineExamReport")
    public String showDoneOnlineExamReportForm() {
        return "report/doneOnlineExamReport";
    }

    @RequestMapping("/categoriesPerformanceReport")
    public String showCategoriesPerformanceReportForm() {
        return "report/categoriesPerformanceReport";
    }

    @RequestMapping("/continuousStatusReport")
    public String showcontinuousStatusReportForm() {
        return "report/continuousStatusReport";
    }

    @RequestMapping("/personnelTrainingStatusReport")
    public String showPersonnemTrainingStatusReportForm() {
        return "report/personnel-training-status-report";
    }

    @RequestMapping("/coursesPassedPersonnelReport")
    public String showCoursesPassedPersonnelReportForm() {
        return "report/coursesPassedPersonnelReport";
    }

    @RequestMapping("/presenceReport")
    public String showPresenceReport() {
        return "report/presenceReport";
    }

    @RequestMapping("/statisticsUnitReport")
    public String showStatisticsUnitReport() {
        return "report/statisticsUnitReport";
    }
    @RequestMapping("/manHourStatisticsByClassFeaturesReport")
    public String showManHourStatisticsByClassFeaturesReport() {
        return "report/manHourStatisticsByClassFeaturesReport";
    }
    @RequestMapping("/manHourStatisticsPerDepartmentReport")
    public String showManHourStatisticsPerDepartmentReport() {
        return "report/manHourStatisticsPerDepartmentReport";
    }

    @RequestMapping("/manHourStatisticsByClassCategoryReport")
    public String showManHourStatisticsByClassCategoryReport() {
        return "report/manHourStatisticsByClassCategoryReport";
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

    @GetMapping("/edit-needs-assessment")
    public String showEditNeedsAssessmentForm() {
        return "needsAssessment/edit-needs-assessment";
    }

    @GetMapping("/diff-needs-assessment")
    public String showDiffNeedsAssessmentForm() {
        return "needsAssessment/diff-needs-assessment";
    }

    @GetMapping("/tree-needs-assessment")
    public String showTreeNeedsAssessmentForm() {
        return "needsAssessment/tree-needs-assessment";
    }

    @RequestMapping("/work-group")
    public String showWorkGroupForm() {
        return "security/workGroup";
    }

    @RequestMapping("/course-needs-assessment-reports")
    public String showCourseNAReportsForm() {
        return "planning/courseNAReports";
    }

    @RequestMapping("/personnel-portal")
    public String showStudentPortalForm() {
        return "portal/personnelPortal";
    }

    @RequestMapping("/teacher-portal")
    public String showTeacherPortalForm() {
        return "portal/teacherPortal";
    }

    @RequestMapping("/personnel-course-NA-report")
    public String showPersonnelCourseNAReportForm() {
        return "report/personnelCourseNAReportV2";
    }

    @RequestMapping("/training-file-na-report")
    public String showTrainingFileNAReport() {
        return "report/trainingFileNAReport";
    }

    @RequestMapping("/training-course-need-assessment")
    public String showTrainingCourseNeedAssessment() {
        return "report/trainingCourseNeedAssessment";
    }

    @RequestMapping("/training-area-need-assessment")
    public String showTrainingAreaNeedAssessment() {
        return "report/trainingAreaNeedAssessment";
    }
    @RequestMapping("/needsAssessmentsPerformed")
    public String showReportsOfNeedsAssessmentsPerformed() {
        return "report/needsAssessmentsPerformed";
    }
    @RequestMapping("/unAssigneeNeedsAssessments")
    public String showReportsOfUnAssigneNeedsAssessments() {
        return "report/unAssigneeNeedsAssessments";
    }
    @RequestMapping("/assigneeNeedsAssessmentsReport")
    public String showReportsOfAssigneeNeedsAssessments() {
        return "report/assigneeNeedsAssessmentsReport";
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
    public ResponseEntity<?> calenderCurrentTermReport(final HttpServletRequest request, @RequestParam Long objectId, @RequestParam String objectType, @RequestParam(required = false) String personnelNo, @RequestParam String nationalCode, @RequestParam String firstName, @RequestParam String lastName, @RequestParam String companyName, @RequestParam String personnelNo2, @RequestParam String postTitle, @RequestParam String postCode) {
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
        map.add("objectId", String.valueOf(objectId));
        map.add("objectType", objectType);
        map.add("personnelNo", personnelNo);
        map.add("nationalCode", nationalCode);
        map.add("firstName", firstName);
        map.add("lastName", lastName);
        map.add("companyName", companyName);
        map.add("personnelNo2", personnelNo2);
        map.add("postTitle", postTitle);
        map.add("postCode", postCode);
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);
        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        return restTemplate.exchange(restApiUrl + "/api/calenderCurrentTerm/print", HttpMethod.POST, entity, byte[].class);

    }

    @GetMapping("/personnel-information-details")
    public String showPersonnelInformationDetailsForm() {
        return "basic/personnelInformationDetails";
    }

    @RequestMapping("/reactionEvaluationReport")
    public String reactionEvaluationReport() {
        return "report/reactionEvaluationReport";
    }

    @RequestMapping("/reactionEvaluationFormulaReport")
    public String reactionEvaluationFormulaReport() {
        return "report/reactionEvaluationFormulaReport";
    }

    @RequestMapping("/reactionEvaluationCommentsReport")
    public String reactionEvaluationCommentsReport() {
        return "report/reactionEvaluationCommentsReport";
    }

    @RequestMapping("/coursesEvaluationReport")
    public String coursesEvaluationReport() {
        return "report/coursesEvaluationReport";
    }

    @RequestMapping("/classHistoryReport")
    public String classHistoryReport() {
        return "report/classHistoryReport";
    }

    @RequestMapping("/request")
    public String showRequestsForm() {
        return "evaluation/requests";
    }

}
