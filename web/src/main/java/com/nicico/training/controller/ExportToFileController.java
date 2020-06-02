package com.nicico.training.controller;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.StudentClassReportViewDTO;
import com.nicico.training.dto.StudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.IStudentService;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.StudentClassReportViewDAO;
import com.nicico.training.service.ExportToFileService;
import com.nicico.training.service.NeedsAssessmentService;
import com.nicico.training.service.StudentClassReportViewService;
import com.nicico.training.service.TclassService;
import lombok.*;
import lombok.experimental.Accessors;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.*;

import static net.minidev.json.parser.JSONParser.DEFAULT_PERMISSIVE_MODE;

@RequiredArgsConstructor
@Controller
@RequestMapping("/export-to-file")
public class ExportToFileController {
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;
    private final NeedsAssessmentService needsAssessmentService;
    private final StudentClassReportViewService studentClassReportViewService;
    private final StudentClassReportViewDAO studentClassReportViewDAO;
    private final PersonnelDAO personnelDAO;

    private final TclassService tClassService;
    private final IStudentService studentService;
    private final ModelMapper modelMapper;
    private final ExportToFileService exportToFileService;
    private final MessageSource messageSource;

    @PostMapping(value = {"/exportExcelFromClient"})
    public void exportExcelFromClient(final HttpServletResponse response, @RequestParam(value = "fields") String fields,
                                      @RequestParam(value = "data") String data,
                                      @RequestParam(value = "titr") String titr,
                                      @RequestParam(value = "pageName") String pageName) throws IOException {

        try {
            exportToFileService.exportToExcel(response, fields, data, titr, pageName);
        } catch (Exception ex) {

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("error", null, locale));
        }
    }

    @PostMapping(value = {"/exportExcelFromServer"})
    public void exportExcelFromServer(final HttpServletRequest req,
                                      final HttpServletResponse response,
                                      @RequestParam(value = "fields") String fields,
                                      @RequestParam(value = "titr") String titr,
                                      @RequestParam(value = "pageName") String pageName,
                                      @RequestParam(value = "fileName") String fileName) throws Exception {


        SearchDTO.SearchRq searchRq = convertToSearchRq(req);

        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>() {
        }.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);

        //Start Of Query
        net.minidev.json.parser.JSONParser parser = new JSONParser(DEFAULT_PERMISSIVE_MODE);
        String jsonString = null;
        int count = 0;

        switch (fileName) {
            /*case "tclass-personnel-training":

                List<TclassDTO.PersonnelClassInfo> list = tClassService.findAllPersonnelClass(searchRq.getCriteria().getCriteria().get(0).getValue().get(0).toString());

                if (list == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list);
                    count = list.size();
                }
                break;*/
            case "trainingFile":

                List<StudentDTO.Info> list2 = studentService.search(searchRq).getList();

                if (list2 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list2);
                    count = list2.size();
                }
                break;

            case "studentClassReport":

                List<StudentClassReportViewDTO.InfoTuple> list3 = SearchUtil.search(studentClassReportViewDAO, searchRq, student -> modelMapper.map(student, StudentClassReportViewDTO.InfoTuple.class)).getList();
                if (list3 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list3);
                    count = list3.size();
                }
                break;

            case "personnelInformationReport":


                List<PersonnelDTO.Info> list4 = SearchUtil.search(personnelDAO, searchRq, personnel -> modelMapper.map(personnel, PersonnelDTO.Info.class)).getList();
                if (list4 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list4);
                    count = list4.size();
                }
                break;
        }

        //End Of Query
        //Start Parse
        net.minidev.json.JSONArray jsonArray = (JSONArray) parser.parse(jsonString);
        net.minidev.json.JSONObject jsonObject = null;
        int sizeOfFields = fields1.size();
        String tmpName = "";
        List<HashMap<String, String>> allData = new ArrayList<HashMap<String, String>>();

        for (int i = 0; i < count; i++) {
            jsonObject = (JSONObject) jsonArray.get(i);

            HashMap<String, String> tmpData = new HashMap<String, String>();

            for (int j = 0; j < sizeOfFields; j++) {
                String[] list = fields1.get(j).get("name").split(".");

                List<String> aList = null;

                if (list.length == 0) {
                    aList = new ArrayList<String>();
                    aList.add(fields1.get(j).get("name"));
                } else {
                    aList = Arrays.asList(list);
                }

                tmpName = getData(jsonObject, aList, 0);

                tmpData.put(fields1.get(j).get("name"), tmpName);
            }
            tmpData.put("rowNum", Integer.toString(i + 1));

            allData.add(tmpData);
        }

        //EndParse


        try {
            ObjectMapper mapper = new ObjectMapper();
            String data = mapper.writeValueAsString(allData);

            exportToFileService.exportToExcel(response, fields, data, titr, pageName);
        } catch (Exception ex) {

            Locale locale = LocaleContextHolder.getLocale();
            response.sendError(500, messageSource.getMessage("error", null, locale));
        }
    }


    private String getData(JSONObject row, List<String> array, int index) {
        if (array.size() - 1 > index) {
            return getData((JSONObject) row.get(array.get(index)), array, ++index);
        } else if (array.size() - 1 == index) {
            return row.getAsString(array.get(index));
        } else {
            return "";
        }
    }

    public static SearchDTO.SearchRq convertToSearchRq(HttpServletRequest rq) throws IOException {

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        String lenStr = rq.getParameter("_len");
        String criteriaStr = rq.getParameter("criteriaStr");
        String sortBy = rq.getParameter("_sortBy");
        ObjectMapper objectMapper = new ObjectMapper();

        JsonNode jsonNode = objectMapper.readTree(criteriaStr);
        String operator = "";

        String constructor = "";

        List<String> criteriaList = new ArrayList<>();

        if (criteriaStr.compareTo("{}") != 0 && criteriaStr.compareTo("") != 0 && criteriaStr != null) {
            operator = jsonNode.get("operator").asText();
            constructor = jsonNode.get("_constructor").asText();

            JsonNode arrNode = new ObjectMapper().readTree(criteriaStr).get("criteria");
            if (arrNode.isArray()) {
                for (final JsonNode objNode : arrNode) {
                    criteriaList.add(objNode.toString());
                }
            }
        }

        searchRq.setStartIndex(0);
        searchRq.setCount(Integer.parseInt(lenStr));

        if (StringUtils.isNotEmpty(sortBy)) {
            searchRq.setSortBy(sortBy);
        }

        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            StringBuilder criteria = new StringBuilder("[" + criteriaList.get(0));
            for (int i = 1; i < criteriaList.size(); i++) {
                criteria.append(",").append(criteriaList.get(i));
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

}
