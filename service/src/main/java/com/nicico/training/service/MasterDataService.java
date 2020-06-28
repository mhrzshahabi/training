/**
 * Author:    Mehran Golrokhi
 * Created:    1399.03.24
 * Description:    Use of WebService
 */

package com.nicico.training.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.ViewPostDTO;
import com.nicico.training.iservice.IMasterDataService;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class MasterDataService implements IMasterDataService {

    @Getter
    @Setter
    @Accessors(chain = true)
    public class CompetenceWebserviceDTO extends MasterDataService{

        public Long id;
        public String code;
        public String latinTitle;
        public String title;
        public String type;
        public String nature;
        public String startDate;
        public String endDate;
        public String legacyCreateDate;
        public String legacyChangeDate;
        public String active;
        public String oldCode;
        public String newCode;
        public String user;
        public String issuable;
        public String comment;
        public String correction;
        public String alignment;
        public Long parentId;
    }

    @Getter
    @Setter
    @ApiModel("CompetenceWebserviceDTOInfoTuple")
    public static class CompetenceWebserviceDTOInfoTuple extends MasterDataService{
        private Long id;
        public String title;
        public Long parentId;

        @Override
        public int hashCode() {
            return new HashCodeBuilder(17, 31).
                    append(title).
                    toHashCode();
        }

        @Override
        public boolean equals(Object obj) {
            if (!(obj instanceof MasterDataService))
                return false;
            return (this.getId().equals(((MasterDataService.CompetenceWebserviceDTOInfoTuple) obj).getId()));
        }
    }


    private static String token = "";

    @Autowired
    private MessageSource messageSource;

    @Override
    public String authorize() throws IOException {

        URL obj = new URL("http://devapp01.icico.net.ir/oauth/token");
        HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
        postConnection.setDoOutput(true);
        postConnection.setDoInput(true);
        postConnection.setUseCaches(false);

        postConnection.setRequestMethod("POST");
        postConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        postConnection.setRequestProperty("charset", "utf-8");
        postConnection.setRequestProperty("authorization", "Basic TWFzdGVyRGF0YTpwYXNzd29yZA==");

        String urlParameters = "grant_type=password&username=devadmin&password=password";
        byte[] postData = urlParameters.getBytes(StandardCharsets.UTF_8);
        int postDataLength = postData.length;

        postConnection.setRequestProperty("Content-Length", Integer.toString(postDataLength));

        try (DataOutputStream wr = new DataOutputStream(postConnection.getOutputStream())) {
            wr.write(postData);
        }

        int responseCode = postConnection.getResponseCode();

//        System.out.println("POST Response Code :  " + responseCode);
//        System.out.println("POST Response Message : " + postConnection.getResponseMessage());

        if (responseCode == HttpURLConnection.HTTP_OK) { //success
            BufferedReader in = new BufferedReader(new InputStreamReader(
                    postConnection.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // print result
//            System.out.println(response.toString());


            PersonnelDTO.Info tmp = null;

            ObjectMapper objectMapper = new ObjectMapper();

            JsonNode jsonNode = objectMapper.readTree(response.toString());
            token = jsonNode.get("access_token").asText();

            return token;

        } else {
//            System.out.println("POST NOT WORKED");

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

                String criteriaStr = iscRq.getParameter("criteria");

                List<String> criteriaList = new ArrayList<>();
                String convertedCriteriaStr = "";

                if (criteriaStr != null && criteriaStr.compareTo("{}") != 0 && criteriaStr.compareTo("") != 0) {

                    criteriaStr = criteriaStr.replace("id", "id")
                            .replace("firstName", "people.firstName").replace("lastName", "people.lastName").replace("nationalCode", "people.nationalCode")
                            .replace("personnelNo", "emNum10")
                            .replace("postTitle", "post.title")
                            .replace("ccpSection", "depTitle")
                            .replace("ccpUnit", "incentiveDepTitle");

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

                String sortBy = iscRq.getParameter("_sortBy");

                sortBy = sortBy.replace("id", "id")
                        .replace("firstName", "people.firstName").replace("lastName", "people.lastName").replace("nationalCode", "people.nationalCode")
                        .replace("personnelNo", "emNum10")
                        .replace("postTitle", "post.title")
                        .replace("ccpSection", "depTitle")
                        .replace("ccpUnit", "incentiveDepTitle");

                final String POST_PARAMS = "{\n" +
                        "  \"count\": " + searchRq.getCount() + ",\n" +
                        "  \"criteria\": {\n" +
                        "    \"criteria\": [\n" +
                        convertedCriteriaStr +
                        "    ],\n" +
                        "    \"operator\": \"and\"\n" +
                        "  },\n" +
                        "  \"distinct\": false,\n" +
                        "  \"sortBy\": \"" + sortBy + "\",\n" +
                        "  \"startIndex\": " + searchRq.getStartIndex() + "\n" +
                        "}";

//                System.out.println(POST_PARAMS);

                URL obj = new URL("http://devapp01.icico.net.ir/master-data/api/v1/people/get/all");
                HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                postConnection.setDoOutput(true);
                postConnection.setDoInput(true);

                postConnection.setRequestMethod("POST");
                postConnection.setRequestProperty("Content-Type", "application/json; charset=utf8");
                postConnection.setRequestProperty("Accept", "application/json");
                postConnection.setRequestProperty("authorization", "Bearer " + token);

                OutputStream os = postConnection.getOutputStream();
                os.write(POST_PARAMS.getBytes());
                os.flush();
                os.close();

                int responseCode = postConnection.getResponseCode();

//                System.out.println("POST Response Code :  " + responseCode);
//                System.out.println("POST Response Message : " + postConnection.getResponseMessage());

                GridResponse<PersonnelDTO.Info> list = new GridResponse<PersonnelDTO.Info>(new ArrayList<PersonnelDTO.Info>());
                list.setStartRow(startRow);
                list.setEndRow(startRow + searchRq.getCount());

                TotalResponse<PersonnelDTO.Info> result = new TotalResponse<PersonnelDTO.Info>(list);


                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    BufferedReader in = new BufferedReader(new InputStreamReader(
                            postConnection.getInputStream()));
                    String inputLine;
                    StringBuffer response = new StringBuffer();

                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    // print result
                    //System.out.println(response.toString());


                    PersonnelDTO.Info tmp = null;

                    JsonNode jsonNode = objectMapper.readTree(response.toString());
                    list.setTotalRows(jsonNode.get("totalCount").asInt());

                    jsonNode = jsonNode.get("list");


                    if (jsonNode.isArray()) {
                        for (int i = 0; i < jsonNode.size(); i++) {
                            tmp = new PersonnelDTO.Info();

                            tmp.setId(jsonNode.get(i).get("id").asLong());

                            if (jsonNode.get(i).get("people") != null) {
                                tmp.setFirstName(jsonNode.get(i).get("people").get("firstName").asText());
                                tmp.setLastName(jsonNode.get(i).get("people").get("lastName").asText());
                                tmp.setNationalCode(jsonNode.get(i).get("people").get("nationalCode").asText());
                            }

                            tmp.setPersonnelNo(jsonNode.get(i).get("emNum10").asText());
                            if (jsonNode.get(i).get("post") != null) {
                                tmp.setPostTitle(jsonNode.get(i).get("post").get("title").asText());
                            }
                            if (jsonNode.get(i).get("depTitle") != null) {
                                tmp.setCcpSection(jsonNode.get(i).get("depTitle").asText());
                            }

                            if (jsonNode.get(i).get("incentiveDepTitle") != null) {
                                tmp.setCcpUnit(jsonNode.get(i).get("incentiveDepTitle").asText());
                            }

                            list.getData().add(tmp);
                        }
                    }

                    return result;

                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        Locale locale = LocaleContextHolder.getLocale();
                        resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

                        return new TotalResponse<PersonnelDTO.Info>(new GridResponse<>());
                    }
                } else {
                    //System.out.println("POST NOT WORKED");

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

                String criteriaStr = iscRq.getParameter("criteria");

                List<String> criteriaList = new ArrayList<>();
                String convertedCriteriaStr = "";

                if (criteriaStr != null && criteriaStr.compareTo("{}") != 0 && criteriaStr.compareTo("") != 0) {

                    criteriaStr = criteriaStr.replace("id", "id")
                            .replace("firstName", "people.firstName").replace("lastName", "people.lastName").replace("nationalCode", "people.nationalCode")
                            .replace("personnelNo", "emNum10")
                            .replace("postTitle", "post.title")
                            .replace("ccpSection", "depTitle")
                            .replace("ccpUnit", "incentiveDepTitle");

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

                String sortBy = iscRq.getParameter("_sortBy");

                sortBy = sortBy.replace("id", "id")
                        .replace("firstName", "people.firstName").replace("lastName", "people.lastName").replace("nationalCode", "people.nationalCode")
                        .replace("personnelNo", "emNum10")
                        .replace("postTitle", "post.title")
                        .replace("ccpSection", "depTitle")
                        .replace("ccpUnit", "incentiveDepTitle");

                final String POST_PARAMS = "{\n" +
                        "  \"count\": " + searchRq.getCount() + ",\n" +
                        "  \"criteria\": {\n" +
                        "    \"criteria\": [\n" +
                        convertedCriteriaStr +
                        "    ],\n" +
                        "    \"operator\": \"and\"\n" +
                        "  },\n" +
                        "  \"distinct\": false,\n" +
                        "  \"sortBy\": \"" + sortBy + "\",\n" +
                        "  \"startIndex\": " + searchRq.getStartIndex() + "\n" +
                        "}";

//                System.out.println(POST_PARAMS);

                URL obj = new URL("http://devapp01.icico.net.ir/master-data/api/v1/Competencies/getAll");
                HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                postConnection.setDoOutput(true);
                postConnection.setDoInput(true);

                postConnection.setRequestMethod("POST");
                postConnection.setRequestProperty("Content-Type", "application/json; charset=utf8");
                postConnection.setRequestProperty("Accept", "application/json");
                postConnection.setRequestProperty("authorization", "Bearer " + token);

                OutputStream os = postConnection.getOutputStream();
                os.write(POST_PARAMS.getBytes());
                os.flush();
                os.close();

                int responseCode = postConnection.getResponseCode();

//                System.out.println("POST Response Code :  " + responseCode);
//                System.out.println("POST Response Message : " + postConnection.getResponseMessage());

                GridResponse<CompetenceDTO.Info> list = new GridResponse<>(new ArrayList<>());
                list.setStartRow(startRow);
                list.setEndRow(startRow + searchRq.getCount());

                TotalResponse<CompetenceDTO.Info> result = new TotalResponse<>(list);


                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    BufferedReader in = new BufferedReader(new InputStreamReader(
                            postConnection.getInputStream()));
                    String inputLine;
                    StringBuffer response = new StringBuffer();

                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    // print result
                    //System.out.println(response.toString());


                    CompetenceDTO.Info tmp = null;

                    JsonNode jsonNode = objectMapper.readTree(response.toString());
                    list.setTotalRows(jsonNode.get("totalCount").asInt());

                    jsonNode = jsonNode.get("list");


                    if (jsonNode.isArray()) {
                        for (int i = 0; i < jsonNode.size(); i++) {
                            tmp = new CompetenceDTO.Info();

                            tmp.setId(jsonNode.get(i).get("id").asLong());

                            //tmp.setCompetenceType(null);
                            tmp.setId(jsonNode.get(i).get("id").asLong());
                            tmp.setTitle(jsonNode.get(i).get("title").asText());
                            //tmp.setCompetenceTypeId(jsonNode.get(i).get("ref").asLong())

                            list.getData().add(tmp);
                        }
                    }

                    return result;

                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        Locale locale = LocaleContextHolder.getLocale();
                        resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

                        return new TotalResponse<CompetenceDTO.Info>(new GridResponse<>());
                    }
                } else {
                    //System.out.println("POST NOT WORKED");

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

                String criteriaStr = iscRq.getParameter("criteria");

                List<String> criteriaList = new ArrayList<>();
                String convertedCriteriaStr = "";

                if (criteriaStr != null && criteriaStr.compareTo("{}") != 0 && criteriaStr.compareTo("") != 0) {

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

                String sortBy = iscRq.getParameter("_sortBy") == null ? "" : "  \"sortBy\": \"" + iscRq.getParameter("_sortBy") + "\",\n";

                final String POST_PARAMS = convertedCriteriaStr != "" ? "{\n" +
                        "  \"count\": " + searchRq.getCount() + ",\n" +
                        "  \"criteria\": {\n" +
                        "    \"criteria\": [\n" +
                        convertedCriteriaStr +
                        "    ],\n" +
                        "    \"operator\": \"and\"\n" +
                        "  },\n" +
                        "  \"distinct\": false,\n" +
                        sortBy +
                        "  \"startIndex\": " + searchRq.getStartIndex() + "\n" +
                        "}" : "{}";

//                System.out.println(POST_PARAMS);

                URL obj = new URL("http://devapp01.icico.net.ir/master-data/api/v1/department/get/all");
                HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                postConnection.setDoOutput(true);
                postConnection.setDoInput(true);

                postConnection.setRequestMethod("POST");
                postConnection.setRequestProperty("Content-Type", "application/json; charset=utf8");
                postConnection.setRequestProperty("Accept", "application/json");
                postConnection.setRequestProperty("authorization", "Bearer " + token);

                OutputStream os = postConnection.getOutputStream();
                os.write(POST_PARAMS.getBytes());
                os.flush();
                os.close();

                int responseCode = postConnection.getResponseCode();

//                System.out.println("POST Response Code :  " + responseCode);
//                System.out.println("POST Response Message : " + postConnection.getResponseMessage());

                GridResponse<CompetenceWebserviceDTO> list = new GridResponse<>(new ArrayList<>());
                list.setStartRow(startRow);
                list.setEndRow(startRow + searchRq.getCount());

                TotalResponse<CompetenceWebserviceDTO> result = new TotalResponse<>(list);


                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    BufferedReader in = new BufferedReader(new InputStreamReader(
                            postConnection.getInputStream()));
                    String inputLine;
                    StringBuffer response = new StringBuffer();

                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    // print result
                    //System.out.println(response.toString());


                    CompetenceWebserviceDTO tmp = null;

                    JsonNode jsonNode = objectMapper.readTree(response.toString());
                    list.setTotalRows(jsonNode.get("totalCount").asInt());

                    jsonNode = jsonNode.get("list");


                    if (jsonNode.isArray()) {
                        for (int i = 0; i < jsonNode.size(); i++) {
                            tmp = new CompetenceWebserviceDTO();

                            tmp.setId(Long.parseLong(jsonNode.get(i).get("id").asText()));
                            tmp.setCode(jsonNode.get(i).get("code").asText());
                            tmp.setLatinTitle(jsonNode.get(i).get("latinTitle").asText());
                            tmp.setTitle(jsonNode.get(i).get("title").asText());
                            tmp.setType(jsonNode.get(i).get("type").asText());
                            tmp.setNature(jsonNode.get(i).get("nature").asText());

                            if (jsonNode.get(i).get("startDate").asText() == null)
                                tmp.setStartDate("");
                            else {
                                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                try {
                                    tmp.setStartDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("startDate").asLong()))));

                                } catch (Exception ex) {

                                }
                            }

                            if (jsonNode.get(i).get("endDate").asText() == null)
                                tmp.setEndDate("");
                            else {
                                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                try {
                                    tmp.setEndDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("endDate").asLong()))));

                                } catch (Exception ex) {

                                }
                            }

                            if (jsonNode.get(i).get("legacyCreateDate").asText() == null)
                                tmp.setLegacyCreateDate("");
                            else {
                                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                try {
                                    tmp.setLegacyCreateDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("legacyCreateDate").asLong()))));

                                } catch (Exception ex) {

                                }
                            }

                            if (jsonNode.get(i).get("legacyChangeDate").asText() == null)
                                tmp.setLegacyChangeDate("");
                            else {
                                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                try {
                                    tmp.setLegacyChangeDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("legacyChangeDate").asLong()))));

                                } catch (Exception ex) {

                                }
                            }

                            tmp.setActive(jsonNode.get(i).get("active").asText());
                            tmp.setOldCode(jsonNode.get(i).get("oldCode").asText());
                            tmp.setNewCode(jsonNode.get(i).get("newCode").asText());
                            tmp.setUser(jsonNode.get(i).get("user").asText());
                            tmp.setIssuable(jsonNode.get(i).get("issuable").asText());
                            tmp.setComment(jsonNode.get(i).get("comment").asText());
                            tmp.setCorrection(jsonNode.get(i).get("correction").asText());
                            tmp.setAlignment(jsonNode.get(i).get("alignment").asText());
                            tmp.setParentId(Long.parseLong(jsonNode.get(i).get("parentId").asText()));

                            list.getData().add(tmp);
                        }
                    }

                    return result;

                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        Locale locale = LocaleContextHolder.getLocale();
                        resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

                        return new TotalResponse<CompetenceWebserviceDTO>(new GridResponse<>());
                    }
                } else {
                    //System.out.println("POST NOT WORKED");

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

                String type = iscRq.getParameter("type");

                URL obj = new URL("http://devapp01.icico.net.ir/master-data/api/v1/post/get/byPeopleType?peopleType=" + type);
                HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                postConnection.setDoOutput(true);
                postConnection.setDoInput(true);

                postConnection.setRequestMethod("GET");
                postConnection.setRequestProperty("Content-Type", "application/json; charset=utf8");
                postConnection.setRequestProperty("Accept", "application/json");
                postConnection.setRequestProperty("authorization", "Bearer " + token);

                int responseCode = postConnection.getResponseCode();

//                System.out.println("POST Response Code :  " + responseCode);
//                System.out.println("POST Response Message : " + postConnection.getResponseMessage());

                GridResponse<ViewPostDTO.Info> list = new GridResponse<>(new ArrayList<>());
                list.setStartRow(startRow);
                list.setEndRow(startRow + searchRq.getCount());

                TotalResponse<ViewPostDTO.Info> result = new TotalResponse<>(list);


                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    BufferedReader in = new BufferedReader(new InputStreamReader(
                            postConnection.getInputStream()));
                    String inputLine;
                    StringBuffer response = new StringBuffer();

                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    // print result
                    //System.out.println(response.toString());


                    ViewPostDTO.Info tmp = null;

                    JsonNode jsonNode = objectMapper.readTree(response.toString());
                    jsonNode = jsonNode.get("response");


                    if (jsonNode.isArray()) {
                        list.setTotalRows(jsonNode.size());

                        for (int i = 0; i < jsonNode.size(); i++) {
                            tmp = new ViewPostDTO.Info();

                            tmp.setId(jsonNode.get(i).get("id").asLong());
                            tmp.setCode(jsonNode.get(i).get("code").asText());
                            tmp.setTitleFa(jsonNode.get(i).get("title").asText());
                            if (jsonNode.get(i).get("job") != null) {
                                if (jsonNode.get(i).get("job").get("title") != null) {
                                    tmp.setJobTitleFa(jsonNode.get(i).get("job").get("title").asText());
                                }

                            }
                            tmp.setPostGradeTitleFa("");
                            tmp.setArea("");
                            tmp.setAssistance("");
                            tmp.setAffairs("");
                            tmp.setSection("");
                            tmp.setUnit("");
                            if (jsonNode.get(i).get("department") != null) {
                                if (jsonNode.get(i).get("department").get("code") != null) {
                                    tmp.setCostCenterCode(jsonNode.get(i).get("department").get("code").asText());
                                }
                                if (jsonNode.get(i).get("department").get("title") != null) {
                                    tmp.setCostCenterTitleFa(jsonNode.get(i).get("department").get("title").asText());
                                }
                            }
                            tmp.setCompetenceCount(0);
                            tmp.setPersonnelCount(0);

                            list.getData().add(tmp);
                        }
                    }

                    return result;

                } else if (responseCode == HttpURLConnection.HTTP_UNAUTHORIZED) {
                    if (StringUtils.isNotEmpty(authorize())) {
                        Locale locale = LocaleContextHolder.getLocale();
                        resp.sendError(500, messageSource.getMessage("masterdata.cannot.get.token", null, locale));

                        return new TotalResponse<ViewPostDTO.Info>(new GridResponse<>());
                    }
                } else {
                    //System.out.println("POST NOT WORKED");

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

    public static SearchDTO.SearchRq convertToSearchRq(HttpServletRequest rq) throws IOException {

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        String startRowStr = rq.getParameter("_startRow");
        String endRowStr = rq.getParameter("_endRow");
        String constructor = rq.getParameter("_constructor");
        String sortBy = rq.getParameter("_sortBy");
        String[] criteriaList = rq.getParameterValues("criteria");
        String operator = rq.getParameter("operator");

        Integer startRow = (startRowStr != null) ? Integer.parseInt(startRowStr) : 0;
        Integer endRow = (endRowStr != null) ? Integer.parseInt(endRowStr) : 50;

        searchRq.setStartIndex(startRow);
        searchRq.setCount(endRow - startRow);

        if (StringUtils.isNotEmpty(sortBy)) {
            searchRq.setSortBy(sortBy);
        }

        ObjectMapper objectMapper = new ObjectMapper();

        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            StringBuilder criteria = new StringBuilder("[" + criteriaList[0]);
            for (int i = 1; i < criteriaList.length; i++) {
                criteria.append(",").append(criteriaList[i]);
            }
            criteria.append("]");
            SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria.toString(), new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            searchRq.setCriteria(criteriaRq);
        }
        return searchRq;
    }

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

                URL obj = new URL("http://devapp01.icico.net.ir/master-data/api/v1/department/get/" + xUrl);
                HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                postConnection.setDoOutput(true);
                postConnection.setDoInput(true);

                postConnection.setRequestMethod("GET");
                postConnection.setRequestProperty("Accept", "*/*");
                postConnection.setRequestProperty("authorization", "Bearer " + token);

                int responseCode = postConnection.getResponseCode();

                List<CompetenceWebserviceDTO> list = new ArrayList<>();


                if (responseCode == HttpURLConnection.HTTP_OK) { //success
                    BufferedReader in = new BufferedReader(new InputStreamReader(
                            postConnection.getInputStream()));
                    String inputLine;
                    StringBuffer response = new StringBuffer();

                    while ((inputLine = in.readLine()) != null) {
                        response.append(inputLine);
                    }
                    in.close();

                    CompetenceWebserviceDTO tmp = null;

                    JsonNode jsonNode = objectMapper.readTree(response.toString());

                    if (jsonNode.isArray()) {
                        for (int i = 0; i < jsonNode.size(); i++) {
                            tmp = new CompetenceWebserviceDTO();

                            tmp.setId(Long.parseLong(jsonNode.get(i).get("id").asText()));
                            tmp.setCode(jsonNode.get(i).get("code").asText());
                            tmp.setLatinTitle(jsonNode.get(i).get("latinTitle").asText());
                            tmp.setTitle(jsonNode.get(i).get("title").asText());
                            tmp.setType(jsonNode.get(i).get("type").asText());
                            tmp.setNature(jsonNode.get(i).get("nature").asText());

                            if (jsonNode.get(i).get("startDate").asText() == null)
                                tmp.setStartDate("");
                            else {
                                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                try {
                                    tmp.setStartDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("startDate").asLong()))));

                                } catch (Exception ex) { }
                            }

                            if (jsonNode.get(i).get("endDate").asText() == null)
                                tmp.setEndDate("");
                            else {
                                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                try {
                                    tmp.setEndDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("endDate").asLong()))));

                                } catch (Exception ex) { }
                            }

                            if (jsonNode.get(i).get("legacyCreateDate").asText() == null)
                                tmp.setLegacyCreateDate("");
                            else {
                                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                try {
                                    tmp.setLegacyCreateDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("legacyCreateDate").asLong()))));

                                } catch (Exception ex) { }
                            }

                            if (jsonNode.get(i).get("legacyChangeDate").asText() == null)
                                tmp.setLegacyChangeDate("");
                            else {
                                SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                try {
                                    tmp.setLegacyChangeDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("legacyChangeDate").asLong()))));

                                } catch (Exception ex) { }
                            }

                            tmp.setActive(jsonNode.get(i).get("active").asText());
                            tmp.setOldCode(jsonNode.get(i).get("oldCode").asText());
                            tmp.setNewCode(jsonNode.get(i).get("newCode").asText());
                            tmp.setUser(jsonNode.get(i).get("user").asText());
                            tmp.setIssuable(jsonNode.get(i).get("issuable").asText());
                            tmp.setComment(jsonNode.get(i).get("comment").asText());
                            tmp.setCorrection(jsonNode.get(i).get("correction").asText());
                            tmp.setAlignment(jsonNode.get(i).get("alignment").asText());
                            tmp.setParentId(Long.parseLong(jsonNode.get(i).get("parentId").asText()));

                            list.add(tmp);
                        }
                    }

                    return list;

                }

                else {

                    return null;
                }
            }

            return null;

        }
    }

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
                List<CompetenceWebserviceDTO> result = new ArrayList<>();

                for (Long id : xUrl){
                    URL obj = new URL("http://devapp01.icico.net.ir/master-data/api/v1/department/get/ParentId?parentId=" + id.toString());
                    HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                    postConnection.setDoOutput(true);
                    postConnection.setDoInput(true);

                    postConnection.setRequestMethod("GET");
                    postConnection.setRequestProperty("Accept", "*/*");
                    postConnection.setRequestProperty("authorization", "Bearer " + token);

                    int responseCode = postConnection.getResponseCode();

                    List<CompetenceWebserviceDTO> list = new ArrayList<>();


                    if (responseCode == HttpURLConnection.HTTP_OK) { //success
                        BufferedReader in = new BufferedReader(new InputStreamReader(
                                postConnection.getInputStream()));
                        String inputLine;
                        StringBuffer response = new StringBuffer();

                        while ((inputLine = in.readLine()) != null) {
                            response.append(inputLine);
                        }
                        in.close();

                        CompetenceWebserviceDTO tmp = null;

                        JsonNode jsonNode = objectMapper.readTree(response.toString());

                        if (jsonNode.isArray()) {
                            for (int i = 0; i < jsonNode.size(); i++) {
                                tmp = new CompetenceWebserviceDTO();

                                tmp.setId(Long.parseLong(jsonNode.get(i).get("id").asText()));
                                tmp.setCode(jsonNode.get(i).get("code").asText());
                                tmp.setLatinTitle(jsonNode.get(i).get("latinTitle").asText());
                                tmp.setTitle(jsonNode.get(i).get("title").asText());
                                tmp.setType(jsonNode.get(i).get("type").asText());
                                tmp.setNature(jsonNode.get(i).get("nature").asText());

                                if (jsonNode.get(i).get("startDate").asText() == null)
                                    tmp.setStartDate("");
                                else {
                                    SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                    try {
                                        tmp.setStartDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("startDate").asLong()))));

                                    } catch (Exception ex) { }
                                }

                                if (jsonNode.get(i).get("endDate").asText() == null)
                                    tmp.setEndDate("");
                                else {
                                    SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                    try {
                                        tmp.setEndDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("endDate").asLong()))));

                                    } catch (Exception ex) { }
                                }

                                if (jsonNode.get(i).get("legacyCreateDate").asText() == null)
                                    tmp.setLegacyCreateDate("");
                                else {
                                    SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                    try {
                                        tmp.setLegacyCreateDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("legacyCreateDate").asLong()))));

                                    } catch (Exception ex) { }
                                }

                                if (jsonNode.get(i).get("legacyChangeDate").asText() == null)
                                    tmp.setLegacyChangeDate("");
                                else {
                                    SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                                    try {
                                        tmp.setLegacyChangeDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get(i).get("legacyChangeDate").asLong()))));

                                    } catch (Exception ex) { }
                                }

                                tmp.setActive(jsonNode.get(i).get("active").asText());
                                tmp.setOldCode(jsonNode.get(i).get("oldCode").asText());
                                tmp.setNewCode(jsonNode.get(i).get("newCode").asText());
                                tmp.setUser(jsonNode.get(i).get("user").asText());
                                tmp.setIssuable(jsonNode.get(i).get("issuable").asText());
                                tmp.setComment(jsonNode.get(i).get("comment").asText());
                                tmp.setCorrection(jsonNode.get(i).get("correction").asText());
                                tmp.setAlignment(jsonNode.get(i).get("alignment").asText());
                                tmp.setParentId(Long.parseLong(jsonNode.get(i).get("parentId").asText()));

                                list.add(tmp);
                            }
                            result.addAll(list);
                        }
                    }

                    else {
                            continue;
//                        return null;
                    }
                }
                return result;
            }

            return null;

        }
    }

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

                URL obj = new URL("http://devapp01.icico.net.ir/master-data/api/v1/department/get/single?id=" + id.toString());
                HttpURLConnection postConnection = (HttpURLConnection) obj.openConnection();
                postConnection.setDoOutput(true);
                postConnection.setDoInput(true);
                postConnection.setRequestMethod("GET");
                postConnection.setRequestProperty("Accept", "*/*");
                postConnection.setRequestProperty("authorization", "Bearer " + token);
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
                    CompetenceWebserviceDTO tmp = null;
                    JsonNode jsonNode = objectMapper.readTree(response.toString());
                    tmp = new CompetenceWebserviceDTO();
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
                        } catch (Exception ex) { }
                    }
                    if (jsonNode.get("endDate").asText() == null)
                        tmp.setEndDate("");
                    else {
                        SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                        try {
                            tmp.setEndDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get("endDate").asLong()))));
                        } catch (Exception ex) { }
                    }
                    if (jsonNode.get("legacyCreateDate").asText() == null)
                        tmp.setLegacyCreateDate("");
                    else {
                        SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                        try {
                            tmp.setLegacyCreateDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get("legacyCreateDate").asLong()))));
                        } catch (Exception ex) { }
                    }
                    if (jsonNode.get("legacyChangeDate").asText() == null)
                        tmp.setLegacyChangeDate("");
                    else {
                        SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
                        try {
                            tmp.setLegacyChangeDate(DateUtil.convertMiToKh(ft.format(new Date(jsonNode.get("legacyChangeDate").asLong()))));
                        } catch (Exception ex) { }
                    }
                    tmp.setActive(jsonNode.get("active").asText());
                    tmp.setOldCode(jsonNode.get("oldCode").asText());
                    tmp.setNewCode(jsonNode.get("newCode").asText());
                    tmp.setUser(jsonNode.get("user").asText());
                    tmp.setIssuable(jsonNode.get("issuable").asText());
                    tmp.setComment(jsonNode.get("comment").asText());
                    tmp.setCorrection(jsonNode.get("correction").asText());
                    tmp.setAlignment(jsonNode.get("alignment").asText());
                    tmp.setParentId(Long.parseLong(jsonNode.get("parentId").asText()));

                    return tmp;
                }else
                    return null;
            }
        }

            return null;

    }

}
