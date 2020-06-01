package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
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
import lombok.RequiredArgsConstructor;
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
    public void exportExcelFromServer(final HttpServletRequest req, final HttpServletResponse response, @RequestParam(value = "fields") String fields,
                                      @RequestParam(value = "titr") String titr,
                                      @RequestParam(value = "pageName") String pageName,
                                      @RequestParam(value = "fileName") String fileName,/*,
                                   @RequestParam(value = "_endRow", defaultValue = "200") Integer endRow,
                                   @RequestParam(value = "_constructor", required = false) String constructor,
                                   @RequestParam(value = "operator", required = false) String operator,*/
                                      @RequestParam(value = "criteriaStr") String criteria
            /*@RequestParam(value = "_sortBy", required = false) String sortBy*/) throws Exception {

        //String criteria = req.getParameter("CriteriaStr");
        criteria = criteria == null ? "{}" : criteria;
        String sortBy = req.getParameter("_sortBy");
        Integer len = Integer.parseInt(req.getParameter("_len"));


        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>() {
        }.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);

        //Start Of Query
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq = null;
        if (!criteria.equalsIgnoreCase("{}")) {
            /*criteriaRq = objectMapper.readValue(criteria, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);*/

            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf("and"))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));

            request.setCriteria(criteriaRq);

        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        request.setStartIndex(0)
                .setCount(len);

        net.minidev.json.parser.JSONParser parser = new JSONParser(DEFAULT_PERMISSIVE_MODE);
        String jsonString = null;
        int count = 0;

        switch (fileName) {
            case "tclass-personnel-training":

                List<TclassDTO.PersonnelClassInfo> list = tClassService.findAllPersonnelClass(criteriaRq.getCriteria().get(0).getValue().get(0).toString());

                if (list == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list);
                    count = list.size();
                }
                break;
            case "trainingFile":

                List<StudentDTO.Info> list2 = studentService.search(request).getList();

                if (list2 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list2);
                    count = list2.size();
                }
                break;

            case "studentClassReport":


                List<StudentClassReportViewDTO.InfoTuple> list3= SearchUtil.search(studentClassReportViewDAO, request, student -> modelMapper.map(student, StudentClassReportViewDTO.InfoTuple.class)).getList();
                if (list3 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list3);
                    count = list3.size();
                }
                break;

            case "personnelInformationReport":


                List<PersonnelDTO.Info> list4= SearchUtil.search(personnelDAO, request, personnel -> modelMapper.map(personnel, PersonnelDTO.Info.class)).getList();
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
}
