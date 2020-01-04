package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Controller
@RequestMapping("/teacher")
public class TeacherFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/teacher";
    }

    @RequestMapping("/attachments-tab")
    public String attachmentsTab() {
        return "base/attachments";
    }

    @RequestMapping("/employmentHistory-tab")
    public String employmentHistoryTab() {
        return "teacherTabs/employmentHistory";
    }

    @RequestMapping("/teachingHistory-tab")
    public String teachingHistoryTab() {
        return "teacherTabs/teachingHistory";
    }

    @RequestMapping("/foreignLangKnowledge-tab")
    public String foreignLangTab() { return "teacherTabs/foreignLangKnowledge"; }

    @RequestMapping("/teacherCertification-tab")
    public String teacherCertificationTab() {
        return "teacherTabs/teacherCertification";
    }

    @RequestMapping("/publication-tab")
    public String publicationTab() { return "teacherTabs/publication"; }

    @RequestMapping("/otherActivities-tab")
    public String otherActivitiesTab() { return "teacherTabs/otherActivities"; }

    @RequestMapping("/jobInfo-tab")
    public String jobInfoTab() { return "teacherTabs/jobInfo"; }

    @RequestMapping("/accountInfo-tab")
    public String accountInfoTab() { return "teacherTabs/accountInfo"; }

    @RequestMapping("/addressInfo-tab")
    public String addressInfoTab() { return "teacherTabs/addressInfo"; }

    @RequestMapping("/teacherBasicInfo-tab")
    public String teacherBasicInfoTab() { return "teacherTabs/teacherBasicInfo"; }

    @PostMapping("/printWithCriteria/{type}")
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String type) {
        String token = request.getParameter("token");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        switch (type) {
            case "pdf":
                return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/PDF", HttpMethod.POST, entity, byte[].class);
            case "excel":
                return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
            case "html":
                return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
            default:
                return null;
        }
    }

}
