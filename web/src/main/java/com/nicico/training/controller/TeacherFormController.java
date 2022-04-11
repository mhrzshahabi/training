package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.dto.search.SearchDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.file.Path;

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

    @RequestMapping("/internalTeachingHistory-tab")
    public String internalTeachingHistoryTab() { return "teacherTabs/internalTeachingHistory"; }

    @RequestMapping("/internalTeachingSubject-tab")
    public String internalTeachingSubjectTab() { return "teacherTabs/internalTeachingSubject"; }

    @RequestMapping("/foreignLangKnowledge-tab")
    public String foreignLangTab() {
        return "teacherTabs/foreignLangKnowledge";
    }

    @RequestMapping("/teacherCertification-tab")
    public String teacherCertificationTab() {
        return "teacherTabs/teacherCertification";
    }

    @RequestMapping("/publication-tab")
    public String publicationTab() {
        return "teacherTabs/publication";
    }

    @RequestMapping("/otherActivities-tab")
    public String otherActivitiesTab() {
        return "teacherTabs/otherActivities";
    }

    @RequestMapping("/jobInfo-tab")
    public String jobInfoTab() {
        return "teacherTabs/jobInfo";
    }

    @RequestMapping("/accountInfo-tab")
    public String accountInfoTab() {
        return "teacherTabs/accountInfo";
    }

    @RequestMapping("/addressInfo-tab")
    public String addressInfoTab() {
        return "teacherTabs/addressInfo";
    }

    @RequestMapping("/teacherBasicInfo-tab")
    public String teacherBasicInfoTab() {
        return "teacherTabs/teacherBasicInfo";
    }

    @RequestMapping("/academicBK-tab")
    public String academicBKTab() {
        return "teacherTabs/academicBK";
    }


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

    @PostMapping("/printWithDetail/{id}")
    public ResponseEntity<?> printWithDetail(final HttpServletRequest request, @PathVariable String id) {
        String token = request.getParameter("token");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        return restTemplate.exchange(restApiUrl + "/api/teacher/printWithDetail/" + id, HttpMethod.POST, entity, byte[].class);
    }

    @PostMapping("/printEvaluation/{id}/{catId}/{subCatId}")
    public ResponseEntity<?> printEvaluation(final HttpServletRequest request, @PathVariable String id, @PathVariable String catId, @PathVariable String subCatId) {
        String token = request.getParameter("token");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        return restTemplate.exchange(restApiUrl + "/api/teacher/printEvaluation/" + id + "/" + catId + "/" + subCatId, HttpMethod.POST, entity, byte[].class);
    }



}
