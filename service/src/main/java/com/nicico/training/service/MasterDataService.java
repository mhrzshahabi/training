/**
 * Author:    Mehran Golrokhi
 * Created:    1399.03.24
 * Description:    Use of WebService
 */

package com.nicico.training.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.CompetenceWebserviceDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.iservice.IMasterDataService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@RequiredArgsConstructor
public class MasterDataService implements IMasterDataService {

    @Value("${spring.security.oauth2.client.provider.oserver.token-uri}")
    private String authorizationUri;

    @Value("${nicico.security.sys-uri}")
    private String uri;

    @Value("${nicico.security.sys-username}")
    private String username;

    @Value("${nicico.security.sys-password}")
    private String password;

    private interface PreReqProcess {

        public String preCriteria(String criteria);

        public String preSortBy(String sortBy);

        public <T> T json2Object(JsonNode jsonNode);
    }

    private class PrePeopleProcess implements PreReqProcess {

        @Override
        public String preCriteria(String criteria) {
            return criteria.replace("id", "id")
                    .replace("firstName", "people.firstName").replace("lastName", "people.lastName").replace("nationalCode", "people.nationalCode")
                    .replace("personnelNo", "emNum10")
                    .replace("postTitle", "post.title")
                    .replace("ccpSection", "depTitle")
                    .replace("ccpUnit", "incentiveDepTitle");
        }

        @Override
        public String preSortBy(String sortBy) {
            return sortBy.replace("id", "id")
                    .replace("firstName", "people.firstName").replace("lastName", "people.lastName").replace("nationalCode", "people.nationalCode")
                    .replace("personnelNo", "emNum10")
                    .replace("postTitle", "post.title")
                    .replace("ccpSection", "depTitle")
                    .replace("ccpUnit", "incentiveDepTitle");
        }

        @Override
        public PersonnelDTO.Info json2Object(JsonNode jsonNode) {
            PersonnelDTO.Info tmp = new PersonnelDTO.Info();

            tmp.setId(jsonNode.get("id").asLong());

            if (jsonNode.get("people") != null) {
                tmp.setFirstName(jsonNode.get("people").get("firstName").asText());
                tmp.setLastName(jsonNode.get("people").get("lastName").asText());
                tmp.setNationalCode(jsonNode.get("people").get("nationalCode").asText());
            }

            tmp.setPersonnelNo(jsonNode.get("emNum10").asText());
            if (jsonNode.get("post") != null) {
                tmp.setPostTitle(jsonNode.get("post").get("title").asText());
            }
            if (jsonNode.get("depTitle") != null) {
                tmp.setCcpSection(jsonNode.get("depTitle").asText());
            }

            if (jsonNode.get("incentiveDepTitle") != null) {
                tmp.setCcpUnit(jsonNode.get("incentiveDepTitle").asText());
            }
            return tmp;
        }

    }

    private class PreCompetenciesProccess implements PreReqProcess {

        @Override
        public String preCriteria(String criteria) {
            return criteria.replace("id", "id")
                    .replace("firstName", "people.firstName").replace("lastName", "people.lastName").replace("nationalCode", "people.nationalCode")
                    .replace("personnelNo", "emNum10")
                    .replace("postTitle", "post.title")
                    .replace("ccpSection", "depTitle")
                    .replace("ccpUnit", "incentiveDepTitle");
        }

        @Override
        public String preSortBy(String sortBy) {
            return sortBy.replace("id", "id")
                    .replace("firstName", "people.firstName").replace("lastName", "people.lastName").replace("nationalCode", "people.nationalCode")
                    .replace("personnelNo", "emNum10")
                    .replace("postTitle", "post.title")
                    .replace("ccpSection", "depTitle")
                    .replace("ccpUnit", "incentiveDepTitle");
        }

        @Override
        public CompetenceDTO.Info json2Object(JsonNode jsonNode) {
            CompetenceDTO.Info tmp = new CompetenceDTO.Info();

            tmp.setId(jsonNode.get("id").asLong());

            //tmp.setCompetenceType(null);
            tmp.setId(jsonNode.get("id").asLong());
            tmp.setTitle(jsonNode.get("title").asText());
            //tmp.setCompetenceTypeId(jsonNode.get(i).get("ref").asLong())
            return tmp;
        }
    }

    private class PrePostProccess implements PreReqProcess {

        @Override
        public String preCriteria(String criteria) {
            return criteria;
        }

        @Override
        public String preSortBy(String sortBy) {
            return sortBy;
        }

        @Override
        public ViewPostDTO.Info json2Object(JsonNode jsonNode) {
            ViewPostDTO.Info tmp = new ViewPostDTO.Info();

            tmp.setId(jsonNode.get("id").asLong());
            tmp.setCode(jsonNode.get("code").asText());
            tmp.setTitleFa(jsonNode.get("title").asText());
            if (jsonNode.get("job") != null) {
                if (jsonNode.get("job").get("title") != null) {
                    tmp.setJobTitleFa(jsonNode.get("job").get("title").asText());
                }

            }
            tmp.setPostGradeTitleFa("");
            tmp.setArea("");
            tmp.setAssistance("");
            tmp.setAffairs("");
            tmp.setSection("");
            tmp.setUnit("");
            if (jsonNode.get("department") != null) {
                if (jsonNode.get("department").get("code") != null) {
                    tmp.setCostCenterCode(jsonNode.get("department").get("code").asText());
                }
                if (jsonNode.get("department").get("title") != null) {
                    tmp.setCostCenterTitleFa(jsonNode.get("department").get("title").asText());
                }
            }
            tmp.setCompetenceCount(0);
            tmp.setPersonnelCount(0);

            return tmp;
        }
    }

    private class PreDepartmentProcess implements PreReqProcess {

        @Override
        public String preCriteria(String criteria) {
            return criteria;
        }

        @Override
        public String preSortBy(String sortBy) {
            return sortBy;
        }

        @Override
        public CompetenceWebserviceDTO json2Object(JsonNode jsonNode) {
            CompetenceWebserviceDTO tmp = new CompetenceWebserviceDTO();

            tmp.setId(Long.parseLong(jsonNode.get("id").asText()));
            tmp.setCode(jsonNode.get("code").asText());
            tmp.setLatinTitle(jsonNode.get("latinTitle").asText());
            tmp.setTitle(jsonNode.get("title").asText());
            tmp.setType(jsonNode.get("type").asText());
            tmp.setNature(jsonNode.get("nature").asText());

            if (jsonNode.get("startDate").asText() == null)
                tmp.setStartDate("");
            else {
                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    tmp.setStartDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get("startDate").asLong()))));

                } catch (Exception ex) {

                }
            }

            if (jsonNode.get("endDate").asText() == null)
                tmp.setEndDate("");
            else {
                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    tmp.setEndDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get("endDate").asLong()))));

                } catch (Exception ex) {

                }
            }

            if (jsonNode.get("legacyCreateDate").asText() == null)
                tmp.setLegacyCreateDate("");
            else {
                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    tmp.setLegacyCreateDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get("legacyCreateDate").asLong()))));

                } catch (Exception ex) {

                }
            }

            if (jsonNode.get("legacyChangeDate").asText() == null)
                tmp.setLegacyChangeDate("");
            else {
                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    tmp.setLegacyChangeDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get("legacyChangeDate").asLong()))));

                } catch (Exception ex) {

                }
            }

            tmp.setActive(jsonNode.get("active").asText());
            tmp.setOldCode(jsonNode.get("oldCode").asText());
            tmp.setNewCode(jsonNode.get("newCode").asText());
            tmp.setUser(jsonNode.get("user").asText());
            tmp.setIssuable(jsonNode.get("issuable").asText());
            tmp.setComment(jsonNode.get("comment").asText());
            tmp.setCorrection(jsonNode.get("correction").asText());
            tmp.setAlignment(jsonNode.get("alignment").asText());
            tmp.setParentId(Long.parseLong(jsonNode.get("parentId").asText() == "null" ? "-1" : jsonNode.get("parentId").asText()));

            return tmp;
        }
    }

    private class PreParentEmployeeProcess implements PreReqProcess {

        @Override
        public String preCriteria(String criteria) {
            return criteria;
        }

        @Override
        public String preSortBy(String sortBy) {
            return sortBy;
        }

        @Override
        public PersonnelDTO.Info json2Object(JsonNode jsonNode) {
            PersonnelDTO.Info person = new PersonnelDTO.Info();

            if (jsonNode.get("people") != null) {
                person.setId(jsonNode.get("people").get("id").asLong());
                person.setFirstName(jsonNode.get("people").get("firstName").asText());
                person.setLastName(jsonNode.get("people").get("lastName").asText());
                person.setNationalCode(jsonNode.get("people").get("nationalCode").asText());
                person.setFatherName(jsonNode.get("people").get("fatherName").asText());
            }

            person.setPersonnelNo(jsonNode.get("emNum10").asText());
            person.setPersonnelNo2(jsonNode.get("emNum").asText());

            if (!jsonNode.get("post").asText().equals("null")) {
                person.setPostTitle(jsonNode.get("post").get("title").asText());
                person.setPostCode(jsonNode.get("post").get("code").asText());
            }

            if (!jsonNode.get("department").asText().equals("null")) {
                person.setCcpTitle(jsonNode.get("department").get("title").asText());
                person.setCcpAffairs(jsonNode.get("department").get("omorTitle").asText());
                person.setCcpSection(jsonNode.get("department").get("ghesmatTitle").asText());
                person.setCcpAssistant(jsonNode.get("department").get("moavenatTitle").asText());
                person.setCcpArea(jsonNode.get("department").get("hozeTitle").asText());
                person.setCcpUnit(jsonNode.get("department").get("vahedTitle").asText());
            }

            return person;
        }
    }

    /*private class PreChilderenEmployeeProcess implements PreReqProcess {

        @Override
        public String preCriteria(String criteria) {
            return criteria;
        }

        @Override
        public String preSortBy(String sortBy) {
            return sortBy;
        }

        @Override
        public PersonnelDTO.Info json2Object(JsonNode jsonNode) {
            PersonnelDTO.Info tmp = new PersonnelDTO.Info();

            if (jsonNode.get("people") != null) {
                tmp.setId(jsonNode.get("people").get("id").asLong());
                tmp.setFirstName(jsonNode.get("people").get("firstName").asText());
                tmp.setLastName(jsonNode.get("people").get("lastName").asText());
                tmp.setNationalCode(jsonNode.get("people").get("nationalCode").asText());
                tmp.setFatherName(jsonNode.get("people").get("fatherName").asText());
            }

            tmp.setPersonnelNo(jsonNode.get("emNum10").asText());
            tmp.setPersonnelNo2(jsonNode.get("emNum").asText());

            if (!jsonNode.get("post").asText().equals("null")) {
                tmp.setPostTitle(jsonNode.get("post").get("title").asText());
                tmp.setPostCode(jsonNode.get("post").get("code").asText());
            }

            if (!jsonNode.get("department").asText().equals("null")) {
                tmp.setCcpTitle(jsonNode.get("department").get("title").asText());
                tmp.setCcpAffairs(jsonNode.get("department").get("omorTitle").asText());
                tmp.setCcpSection(jsonNode.get("department").get("ghesmatTitle").asText());
                tmp.setCcpAssistant(jsonNode.get("department").get("moavenatTitle").asText());
                tmp.setCcpArea(jsonNode.get("department").get("hozeTitle").asText());
                tmp.setCcpUnit(jsonNode.get("department").get("vahedTitle").asText());
            }

            return tmp;
        }
    }*/

    private class PreSiblingsEmployeeProcess implements PreReqProcess {

        @Override
        public String preCriteria(String criteria) {
            return criteria;
        }

        @Override
        public String preSortBy(String sortBy) {
            return sortBy;
        }

        @Override
        public PersonnelDTO.Info json2Object(JsonNode jsonNode) {
            PersonnelDTO.Info tmp = new PersonnelDTO.Info();

            if (jsonNode.get("people") != null) {
                tmp.setId(jsonNode.get("people").get("id").asLong());
                tmp.setFirstName(jsonNode.get("people").get("firstName").asText());
                tmp.setLastName(jsonNode.get("people").get("lastName").asText());
                tmp.setNationalCode(jsonNode.get("people").get("nationalCode").asText());
                tmp.setFatherName(jsonNode.get("people").get("fatherName").asText());
            }

            tmp.setPersonnelNo(jsonNode.get("emNum10").asText());
            tmp.setPersonnelNo2(jsonNode.get("emNum").asText());

            if (!jsonNode.get("post").asText().equals("null")) {
                tmp.setPostTitle(jsonNode.get("post").get("title").asText());
                tmp.setPostCode(jsonNode.get("post").get("code").asText());
            }

            if (!jsonNode.get("department").asText().equals("null")) {
                tmp.setCcpTitle(jsonNode.get("department").get("title").asText());
                tmp.setCcpAffairs(jsonNode.get("department").get("omorTitle").asText());
                tmp.setCcpSection(jsonNode.get("department").get("ghesmatTitle").asText());
                tmp.setCcpAssistant(jsonNode.get("department").get("moavenatTitle").asText());
                tmp.setCcpArea(jsonNode.get("department").get("hozeTitle").asText());
                tmp.setCcpUnit(jsonNode.get("department").get("vahedTitle").asText());
            }

            return tmp;
        }
    }

    private class PrePersonByNationalCodeProcess implements PreReqProcess {

        @Override
        public String preCriteria(String criteria) {
            return criteria;
        }

        @Override
        public String preSortBy(String sortBy) {
            return sortBy;
        }

        @Override
        public PersonnelDTO.Info json2Object(JsonNode jsonNode) {
            PersonnelDTO.Info tmp = new PersonnelDTO.Info();

            if (jsonNode.get("people") != null) {
                tmp.setId(jsonNode.get("people").get("id").asLong());
                tmp.setFirstName(jsonNode.get("people").get("firstName").asText());
                tmp.setLastName(jsonNode.get("people").get("lastName").asText());
                tmp.setNationalCode(jsonNode.get("people").get("nationalCode").asText());
                tmp.setFatherName(jsonNode.get("people").get("fatherName").asText());
            }

            tmp.setPersonnelNo(jsonNode.get("emNum10").asText());
            tmp.setPersonnelNo2(jsonNode.get("emNum").asText());

            if (!jsonNode.get("post").asText().equals("null")) {
                tmp.setPostTitle(jsonNode.get("post").get("title").asText());
                tmp.setPostCode(jsonNode.get("post").get("code").asText());
            }

            if (!jsonNode.get("department").asText().equals("null")) {
                tmp.setCcpTitle(jsonNode.get("department").get("title").asText());
                tmp.setCcpAffairs(jsonNode.get("department").get("omorTitle").asText());
                tmp.setCcpSection(jsonNode.get("department").get("ghesmatTitle").asText());
                tmp.setCcpAssistant(jsonNode.get("department").get("moavenatTitle").asText());
                tmp.setCcpArea(jsonNode.get("department").get("hozeTitle").asText());
                tmp.setCcpUnit(jsonNode.get("department").get("vahedTitle").asText());
            }

            return tmp;
        }
    }

    private static String token = "";

    @Autowired
    private MessageSource messageSource;

    @Override
    public String authorize() throws IOException {

        URL obj = new URL(authorizationUri);
        HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
        postConnection.setDoOutput(true);
        postConnection.setDoInput(true);
        postConnection.setUseCaches(false);

        postConnection.setRequestMethod("POST");
        postConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        postConnection.setRequestProperty("charset", "utf-8");
        postConnection.setRequestProperty("authorization", "Basic TWFzdGVyRGF0YTpwYXNzd29yZA==");

        String urlParameters = "grant_type=password&username=" + username + "&password=" + password;
        byte[] postData = urlParameters.getBytes(StandardCharsets.UTF_8);
        int postDataLength = postData.length;

        postConnection.setRequestProperty("Content-Length", Integer.toString(postDataLength));

        try (DataOutputStream wr = new DataOutputStream(postConnection.getOutputStream())) {
            wr.write(postData);
        }

        int responseCode = postConnection.getResponseCode();

        if (responseCode == HttpURLConnection.HTTP_OK) { //success
            BufferedReader in = new BufferedReader(new InputStreamReader(
                    postConnection.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            ObjectMapper objectMapper = new ObjectMapper();

            JsonNode jsonNode = objectMapper.readTree(response.toString());
            token = jsonNode.get("access_token").asText();

            return token;

        } else {
            token = "";
            return token;
        }
    }

    @Override
    public TotalResponse<PersonnelDTO.Info> getPeople(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            Locale locale = LocaleContextHolder.getLocale();
            resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));
            return new TotalResponse<PersonnelDTO.Info>(new GridResponse<>());

        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                int startRow = 0;
                if (iscRq.getParameter("_startRow") != null)
                    startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
                SearchDTO.SearchRq searchRq = convertToSearchRq(iscRq);
                ObjectMapper objectMapper = new ObjectMapper();
                PrePeopleProcess prePeopleProcess = new PrePeopleProcess();
                Map<String, String> parameters = prepareParameters(iscRq, objectMapper, prePeopleProcess);
                HttpURLConnection postConnection = createConnection(uri + "people/get/all", "POST", searchRq, parameters);
                int responseCode = postConnection.getResponseCode();

                GridResponse<PersonnelDTO.Info> list = new GridResponse<PersonnelDTO.Info>(new ArrayList<PersonnelDTO.Info>());
                list.setStartRow(startRow);
                list.setEndRow(startRow + searchRq.getCount());

                TotalResponse<PersonnelDTO.Info> result = new TotalResponse<PersonnelDTO.Info>(list);


                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    list.setData(responseProcessing(postConnection, objectMapper, prePeopleProcess, list.getData()));
                    return result;

                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        Locale locale = LocaleContextHolder.getLocale();
                        resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

                        return new TotalResponse<PersonnelDTO.Info>(new GridResponse<>());
                    }
                } else {
                    Locale locale = LocaleContextHolder.getLocale();
                    resp.sendError(500, messageSource.getMessage("masterdata.error.in.webservice", null, locale));

                    return new TotalResponse<PersonnelDTO.Info>(new GridResponse<>());
                }
            }
            Locale locale = LocaleContextHolder.getLocale();
            resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

            return new TotalResponse<PersonnelDTO.Info>(new GridResponse<>());
        }
    }

    @Override
    public TotalResponse<CompetenceDTO.Info> getCompetencies(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            Locale locale = LocaleContextHolder.getLocale();
            resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

            return new TotalResponse<CompetenceDTO.Info>(new GridResponse<>());

        } else {

            int index = 0;

            while (index <= 1) {
                index++;
                int startRow = 0;
                if (iscRq.getParameter("_startRow") != null)
                    startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
                SearchDTO.SearchRq searchRq = convertToSearchRq(iscRq);
                ObjectMapper objectMapper = new ObjectMapper();
                PreCompetenciesProccess preCompetenciesProccess = new PreCompetenciesProccess();
                Map<String, String> parameters = prepareParameters(iscRq, objectMapper, preCompetenciesProccess);
                HttpURLConnection postConnection = createConnection(uri + "Competencies/getAll", "POST", searchRq, parameters);
                int responseCode = postConnection.getResponseCode();

                GridResponse<CompetenceDTO.Info> list = new GridResponse<>(new ArrayList<>());
                list.setStartRow(startRow);
                list.setEndRow(startRow + searchRq.getCount());

                TotalResponse<CompetenceDTO.Info> result = new TotalResponse<>(list);

                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    list.setData(responseProcessing(postConnection, objectMapper, preCompetenciesProccess, list.getData()));
                    return result;

                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        Locale locale = LocaleContextHolder.getLocale();
                        resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

                        return new TotalResponse<CompetenceDTO.Info>(new GridResponse<>());
                    }
                } else {
                    Locale locale = LocaleContextHolder.getLocale();
                    resp.sendError(500, messageSource.getMessage("masterdata.error.in.webservice", null, locale));

                    return new TotalResponse<CompetenceDTO.Info>(new GridResponse<>());
                }
            }

            Locale locale = LocaleContextHolder.getLocale();
            resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

            return new TotalResponse<CompetenceDTO.Info>(new GridResponse<>());
        }
    }

    @Override
    public TotalResponse<ViewPostDTO.Info> getPosts(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            Locale locale = LocaleContextHolder.getLocale();
            resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

            return new TotalResponse<ViewPostDTO.Info>(new GridResponse<>());

        } else {

            int index = 0;

            while (index <= 1) {
                index++;
                int startRow = 0;
                if (iscRq.getParameter("_startRow") != null)
                    startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
                SearchDTO.SearchRq searchRq = convertToSearchRq(iscRq);
                ObjectMapper objectMapper = new ObjectMapper();
                PrePostProccess prePostProccess = new PrePostProccess();
                String type = iscRq.getParameter("type");

                URL obj = new URL(uri + "post/get/byPeopleType?peopleType=" + type);
                HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                postConnection.setDoOutput(true);
                postConnection.setDoInput(true);

                postConnection.setRequestMethod("GET");
                postConnection.setRequestProperty("Content-Type", "application/json; charset=utf8");
                postConnection.setRequestProperty("Accept", "application/json");
                postConnection.setRequestProperty("authorization", "Bearer " + token);

                int responseCode = postConnection.getResponseCode();

                GridResponse<ViewPostDTO.Info> list = new GridResponse<>(new ArrayList<>());
                list.setStartRow(startRow);
                list.setEndRow(startRow + searchRq.getCount());

                TotalResponse<ViewPostDTO.Info> result = new TotalResponse<>(list);

                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    list.setData(responseProcessing(postConnection, objectMapper, prePostProccess, list.getData()));
                    return result;
                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        Locale locale = LocaleContextHolder.getLocale();
                        resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

                        return new TotalResponse<ViewPostDTO.Info>(new GridResponse<>());
                    }
                } else {
                    Locale locale = LocaleContextHolder.getLocale();
                    resp.sendError(500, messageSource.getMessage("masterdata.error.in.webservice", null, locale));

                    return new TotalResponse<ViewPostDTO.Info>(new GridResponse<>());
                }
            }

            Locale locale = LocaleContextHolder.getLocale();
            resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));
            return new TotalResponse<ViewPostDTO.Info>(new GridResponse<>());
        }
    }

    @Override
    public TotalResponse<CompetenceWebserviceDTO> getDepartments(HttpServletRequest iscRq, HttpServletResponse resp) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            Locale locale = LocaleContextHolder.getLocale();
            resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

            return new TotalResponse<CompetenceWebserviceDTO>(new GridResponse<>());

        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                int startRow = 0;
                if (iscRq.getParameter("_startRow") != null)
                    startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
                SearchDTO.SearchRq searchRq = convertToSearchRq(iscRq);
                ObjectMapper objectMapper = new ObjectMapper();
                PreDepartmentProcess PreDepartmentProcess = new PreDepartmentProcess();
                Map<String, String> parameters = prepareParameters(iscRq, objectMapper, null);
                HttpURLConnection postConnection = createConnection(uri + "department/get/all", "POST", searchRq, parameters);
                int responseCode = postConnection.getResponseCode();

                GridResponse<CompetenceWebserviceDTO> list = new GridResponse<>(new ArrayList<>());
                list.setStartRow(startRow);
                list.setEndRow(startRow + searchRq.getCount());

                TotalResponse<CompetenceWebserviceDTO> result = new TotalResponse<>(list);


                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    list.setData(responseProcessing(postConnection, objectMapper, PreDepartmentProcess, list.getData()));
                    return result;
                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        Locale locale = LocaleContextHolder.getLocale();
                        resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

                        return new TotalResponse<CompetenceWebserviceDTO>(new GridResponse<>());
                    }
                } else {
                    Locale locale = LocaleContextHolder.getLocale();
                    resp.sendError(500, messageSource.getMessage("masterdata.error.in.webservice", null, locale));

                    return new TotalResponse<CompetenceWebserviceDTO>(new GridResponse<>());
                }
            }
            Locale locale = LocaleContextHolder.getLocale();
            resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

            return new TotalResponse<CompetenceWebserviceDTO>(new GridResponse<>());
        }
    }

    @Override
    public List<CompetenceWebserviceDTO> getDepartmentsByParentCode(String xUrl) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            return null;
        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                ObjectMapper objectMapper = new ObjectMapper();
                PreDepartmentProcess PreDepartmentProcess = new PreDepartmentProcess();
                HttpURLConnection postConnection = createConnection(uri + "department/get/" + xUrl, "GET", null, null);
                int responseCode = postConnection.getResponseCode();
                List<CompetenceWebserviceDTO> list = new ArrayList<>();

                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    list = responseProcessing(postConnection, objectMapper, PreDepartmentProcess, list);
                    return list;
                } else {
                    return null;
                }
            }
            return null;
        }
    }

    @Override
    public List<CompetenceWebserviceDTO> getDepartmentsChilderenByParentCode(List<Long> xUrl) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            return null;
        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                ObjectMapper objectMapper = new ObjectMapper();
                PreDepartmentProcess PreDepartmentProcess = new PreDepartmentProcess();
                List<CompetenceWebserviceDTO> result = new ArrayList<>();

                for (Long id : xUrl) {
                    HttpURLConnection postConnection = createConnection(uri + "department/get/ParentId?parentId=" + id.toString(), "GET", null, null);
                    int responseCode = postConnection.getResponseCode();
                    List<CompetenceWebserviceDTO> list = new ArrayList<>();
                    if (responseCode == HttpURLConnection.HTTP_OK) { //success
                        list = responseProcessing(postConnection, objectMapper, PreDepartmentProcess, list);
                        result.addAll(list);
                    } else {
                        continue;
                    }
                }
                return result;
            }
            return null;
        }
    }

    @Override
    public List<CompetenceWebserviceDTO> getDepartmentsByParams(String convertedCriteriaStr, String count, String operator, String startIndex, String sortBy) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            return new ArrayList<CompetenceWebserviceDTO>(0);
        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                int startRow = 0;
                ObjectMapper objectMapper = new ObjectMapper();
                PreDepartmentProcess PreDepartmentProcess = new PreDepartmentProcess();
                SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
                searchRq.setCount(Integer.parseInt(count));
                searchRq.setStartIndex(Integer.parseInt(startIndex));
                Map<String, String> parameters = new HashMap<>();
                parameters.put("operator", operator);
                parameters.put("convertedCriteriaStr", convertedCriteriaStr);
                parameters.put("sortBy", sortBy);

                HttpURLConnection postConnection = createConnection(uri + "department/get/all", "POST", searchRq, parameters);
                int responseCode = postConnection.getResponseCode();
                List<CompetenceWebserviceDTO> result = new ArrayList<>();

                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    result = responseProcessing(postConnection, objectMapper, PreDepartmentProcess, result);
                    return result;

                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        return new ArrayList<CompetenceWebserviceDTO>(0);
                    }
                } else {
                    return new ArrayList<CompetenceWebserviceDTO>(0);
                }
            }
            return new ArrayList<CompetenceWebserviceDTO>(0);
        }
    }

    @Override
    public CompetenceWebserviceDTO getDepartmentsById(Long id) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {

            return null;
        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                ObjectMapper objectMapper = new ObjectMapper();
                PreDepartmentProcess PreDepartmentProcess = new PreDepartmentProcess();
                HttpURLConnection postConnection = createConnection(uri + "department/get/single?id=" + id.toString(), "GET", null, null);

                int responseCode = postConnection.getResponseCode();
                List<CompetenceWebserviceDTO> list = new ArrayList<>();
                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    responseProcessing(postConnection, objectMapper, PreDepartmentProcess, list);
                    return list.get(0);
                } else
                    return null;
            }
        }
        return null;
    }

    @Override
    public PersonnelDTO.Info getParentEmployee(Long id) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            return null;
        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                ObjectMapper objectMapper = new ObjectMapper();
                PreParentEmployeeProcess preParentEmployeeProcess = new PreParentEmployeeProcess();
                HttpURLConnection postConnection = createConnection(uri + "employees/parentEmployee/" + id, "GET", null, null);
                int responseCode = postConnection.getResponseCode();
                List<PersonnelDTO.Info> list = new ArrayList<>();

                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    responseProcessing(postConnection, objectMapper, preParentEmployeeProcess, list);
                    return list.get(0);
                }
            }
        }
        return new PersonnelDTO.Info();
    }

/*
    @Override
    public List<PersonnelDTO.Info> getChildrenEmployee(Long id) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            return null;
        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                ObjectMapper objectMapper = new ObjectMapper();
                PreChilderenEmployeeProcess preChilderenEmployeeProcess = new PreChilderenEmployeeProcess();
                HttpURLConnection postConnection = createConnection(uri + "employees/childrenEmployee/" + id, "GET", null, null);
                int responseCode = postConnection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    List<PersonnelDTO.Info> list = new ArrayList<>();
                    responseProcessing(postConnection, objectMapper, preChilderenEmployeeProcess, list);
                    return list;
                }
            }
        }
        return new ArrayList<>(0);
    }
*/

    @Override
    public List<PersonnelDTO.Info> getSiblingsEmployee(Long id) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            return null;
        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                ObjectMapper objectMapper = new ObjectMapper();
                PreSiblingsEmployeeProcess PreDepartmentProcess = new PreSiblingsEmployeeProcess();
                HttpURLConnection postConnection = createConnection(uri + "employees/siblingsEmployee/" + id.toString(), "GET", null, null);
                int responseCode = postConnection.getResponseCode();

                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    List<PersonnelDTO.Info> list = new ArrayList<>();
                    responseProcessing(postConnection, objectMapper, PreDepartmentProcess, list);
                    return list;
                }
            }
        }
        return new ArrayList<>(0);
    }

    @Override
    public List<PersonnelDTO.Info> getPersonByNationalCode(String nationalCode) throws IOException {
        if (token == "") {
            authorize();
        }
        if (token == "") {
            return null;
        } else {
            int index = 0;
            while (index <= 1) {
                index++;
                ObjectMapper objectMapper = new ObjectMapper();
                PrePersonByNationalCodeProcess prePersonByNationalCodeProcess = new PrePersonByNationalCodeProcess();
                HttpURLConnection postConnection = createConnection(uri + "employees/get/byNationalCode/" + nationalCode, "GET", null, null);
                int responseCode = postConnection.getResponseCode();

                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    List<PersonnelDTO.Info> list = new ArrayList<>();
                    responseProcessing(postConnection, objectMapper, prePersonByNationalCodeProcess, list);
                    return list;
                }
            }
        }
        return new ArrayList<>(0);
    }

    private SearchDTO.SearchRq convertToSearchRq(HttpServletRequest rq) throws IOException {
        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        String startRowStr = rq.getParameter("_startRow");
        String endRowStr = rq.getParameter("_endRow");
        //String constructor = rq.getParameter("_constructor");
        String sortBy = rq.getParameter("_sortBy");
        //String operator = rq.getParameter("operator");

        Integer startRow = (startRowStr != null) ? Integer.parseInt(startRowStr) : 0;
        Integer endRow = (endRowStr != null) ? Integer.parseInt(endRowStr) : 50;

        searchRq.setStartIndex(startRow);
        searchRq.setCount(endRow - startRow);

        if (StringUtils.isNotEmpty(sortBy)) {
            searchRq.setSortBy(sortBy);
        }
        return searchRq;
    }

    private Map<String, String> prepareParameters(HttpServletRequest iscRq, ObjectMapper objectMapper, PreReqProcess preReqProcess) throws IOException {
        Map<String, String> map = new HashMap<>();

        String operator = iscRq.getParameter("operator");
        map.put("operator", operator == null || operator.trim() == "" ? "and" : operator);

        String criteriaStr = iscRq.getParameter("criteria");

        map.put("convertedCriteriaStr", convertCriteria(criteriaStr, objectMapper, preReqProcess));

        String sortBy = iscRq.getParameter("_sortBy") == null ? "" : "  \"sortBy\": \"" + iscRq.getParameter("_sortBy") + "\",\n";
        map.put("sortBy", convertSortBy(sortBy, preReqProcess));

        return map;
    }

    private List responseProcessing(HttpURLConnection postConnection, ObjectMapper objectMapper, PreReqProcess preReqProcess, List list) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(
                postConnection.getInputStream()));
        String inputLine;
        StringBuffer response = new StringBuffer();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        JsonNode jsonNode = objectMapper.readTree(response.toString());

        Long totalCount = jsonNode.get("totalCount") != null ? jsonNode.get("totalCount").asLong() : null;

        jsonNode = jsonNode.get("list") != null ? jsonNode.get("list") : jsonNode;

        if (jsonNode.isArray()) {
            for (int i = 0; i < jsonNode.size(); i++) {
                list.add(preReqProcess.json2Object(jsonNode.get(i)));
            }
        } else
            list.add(preReqProcess.json2Object(jsonNode));

        return list;
    }

    private HttpURLConnection createConnection(String url, String type, SearchDTO.SearchRq searchRq, Map<String, String> parameters) throws IOException {
        URL obj = new URL(url);
        HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
        postConnection.setDoOutput(true);
        postConnection.setDoInput(true);

        if (type.equals("POST")) {
            final String POST_PARAMS = parameters.get("convertedCriteriaStr") != "" ? "{\n" +
                    "  \"count\": " + searchRq.getCount() + ",\n" +
                    "  \"criteria\": {\n" +
                    "    \"criteria\": [\n" +
                    parameters.get("convertedCriteriaStr") +
                    "    ],\n" +
                    "    \"operator\": \"" + parameters.get("operator") + "\"\n" +
                    "  },\n" +
                    "  \"distinct\": false,\n" +
                    parameters.get("sortBy") +
                    "  \"startIndex\": " + searchRq.getStartIndex() + "\n" +
                    "}" : "{}";

            postConnection.setRequestMethod("POST");
            postConnection.setRequestProperty("Content-Type", "application/json; charset=utf8");
            postConnection.setRequestProperty("Accept", "application/json");
            postConnection.setRequestProperty("authorization", "Bearer " + token);

            OutputStream os = postConnection.getOutputStream();
            os.write(POST_PARAMS.getBytes());
            os.flush();
            os.close();

        } else if (type.equals("GET")) {
            postConnection.setRequestMethod("GET");
            postConnection.setRequestProperty("Accept", "*/*");
            postConnection.setRequestProperty("authorization", "Bearer " + token);
        }
        return postConnection;
    }

    private String convertCriteria(String criteriaStr, ObjectMapper objectMapper, PreReqProcess preReqProcess) throws IOException {
        List<String> criteriaList = new ArrayList<>();
        String convertedCriteriaStr = "";

        if (criteriaStr != null && criteriaStr.compareTo("{}") != 0 && criteriaStr.compareTo("") != 0) {
            criteriaStr = preReqProcess != null ? preReqProcess.preCriteria(criteriaStr) : criteriaStr;
            JsonNode jsonNode = objectMapper.readTree(criteriaStr);

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    criteriaList.add(objNode.toString());
                }
            } else {
                criteriaList.add(jsonNode.toString());
            }

            convertedCriteriaStr = criteriaList.get(0);
            for (int i = 1; i < criteriaList.size(); i++) {
                convertedCriteriaStr += "," + criteriaList.get(i);
            }
        }
        return convertedCriteriaStr;
    }

    private String convertSortBy(String sortBy, PreReqProcess preReqProcess) {
        return preReqProcess != null ? preReqProcess.preSortBy(sortBy) : sortBy;
    }
}
