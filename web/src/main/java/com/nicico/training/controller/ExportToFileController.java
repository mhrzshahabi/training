package com.nicico.training.controller;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IPersonnelCourseNotPassedReportViewService;
import com.nicico.training.iservice.IStudentService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.ViewTeacherReport;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.PersonnelRegisteredDAO;
import com.nicico.training.repository.StudentClassReportViewDAO;
import com.nicico.training.service.*;
import lombok.*;
import lombok.experimental.Accessors;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static net.minidev.json.parser.JSONParser.DEFAULT_PERMISSIVE_MODE;

@RequiredArgsConstructor
@Controller
@RequestMapping("/export-to-file")
public class ExportToFileController {

    private final ClassStudentService classStudentService;
    private final TeacherService teacherService;
    private final ITclassService tclassService;
    private final IPersonnelCourseNotPassedReportViewService personnelCourseNotPassedReportViewService;
    private final ClassSessionService classSessionService;
    private final EvaluationAnalysistLearningService evaluationAnalysistLearningService;
    private final UnfinishedClassesReportService unfinishedClassesReportService;
    private final TrainingOverTimeService trainingOverTimeService;
    private final AttendanceReportService attendanceReportService;
    private final ViewEvaluationStaticalReportService viewEvaluationStaticalReportService;
    private final ViewTeacherReportService viewTeacherReportService;

    private final StudentClassReportViewDAO studentClassReportViewDAO;
    private final PersonnelDAO personnelDAO;
    private final CourseDAO courseDAO;
    private final PersonnelRegisteredDAO personnelRegisteredDAO;

    private final ExportToFileService exportToFileService;



    private final ModelMapper modelMapper;
    private final MessageSource messageSource;
    private final ObjectMapper objectMapper;
    @Autowired
    protected EntityManager entityManager;


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
                                      @RequestParam(value = "fileName") String fileName,
                                      @RequestParam(value = "criteriaStr") String criteriaStr) throws Exception {


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

                SearchDTO.SearchRs<ClassStudentDTO.CoursesOfStudent> list2 = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.CoursesOfStudent.class));//SearchUtil.search(classStudentDAO, searchRq, c -> modelMapper.map(c, ClassStudentDTO.CoursesOfStudent.class)).getList();

                if (list2.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list2.getList());
                    count = list2.getList().size();
                }
                break;
            case "studentClassReport":

                List<StudentClassReportViewDTO.Info> list3 = SearchUtil.search(studentClassReportViewDAO, searchRq, student -> modelMapper.map(student, StudentClassReportViewDTO.Info.class)).getList();
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
            case "registeredPersonnelInformationReport":


                List<PersonnelRegisteredDTO.Info> list11 = SearchUtil.search(personnelRegisteredDAO, searchRq, personnelRegistered -> modelMapper.map(personnelRegistered, PersonnelRegisteredDTO.Info.class)).getList();
                if (list11 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list11);
                    count = list11.size();
                }
                break;
            case "personnelCourseNotPassed":


                SearchDTO.SearchRs<PersonnelCourseNotPassedReportViewDTO.Info> list5 = personnelCourseNotPassedReportViewService.search(searchRq, p -> modelMapper.map(p, PersonnelCourseNotPassedReportViewDTO.Info.class));
                List<PersonnelCourseNotPassedReportViewDTO.Info> list51 = list5.getList();

                if (list51 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list51);
                    count = list51.size();
                }
                break;

            case "classOutsideCurrentTerm":

                String str = DateUtil.convertKhToMi1(((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim()).replaceAll("[\\s\\-]", "");
                searchRq.getCriteria().getCriteria().remove(0);

                SearchDTO.SearchRs<TclassDTO.Info> list6 = tclassService.search(searchRq);
                List<TclassDTO.Info> list61 = list6.getList();

                List<Long> longList = list61.stream().filter(x -> Long.valueOf(String.valueOf(x.getCreatedDate()).substring(0, 10).replaceAll("[\\s\\-]", "")) > Long.valueOf(str))
                        .map(x -> x.getId()).collect(Collectors.toList());


                List<TclassDTO.Info> infoList = list61.stream().filter(x -> !longList.contains(x.getId())).collect(Collectors.toList());
                list6.getList().removeAll(infoList);


                if (list61 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list61);
                    count = list61.size();
                }
                break;
            case "weeklyTrainingSchedule":

                String userNationalCode = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);

                SearchDTO.SearchRs<ClassSessionDTO.WeeklySchedule> list7 = classSessionService.searchWeeklyTrainingSchedule(searchRq, userNationalCode);
                List<ClassSessionDTO.WeeklySchedule> list71 = list7.getList();


                if (list71 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list71);
                    count = list71.size();
                }
                break;
            case "trainingClassReport":

                searchRq.setStartIndex(0)
                        .setCount(100000);

                SearchDTO.CriteriaRq criteriaRq = null;
                SearchDTO.SearchRq request = null;
                if (criteriaStr.equalsIgnoreCase("{}")) {
                    request = new SearchDTO.SearchRq();
                } else {
                    criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
                    request = new SearchDTO.SearchRq().setCriteria(criteriaRq).setSortBy("-tclassStartDate");
                }
                if(request.getCriteria() != null && request.getCriteria().getCriteria() != null){
                    for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                        if(criterion.getValue().get(0).equals("true"))
                            criterion.setValue(true);
                        if(criterion.getValue().get(0).equals("false"))
                            criterion.setValue(false);
                    }
                }
                SearchDTO.SearchRs<ViewEvaluationStaticalReportDTO.Info> list8 = viewEvaluationStaticalReportService.search(request);

                if (list8.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list8.getList());
                    count = list8.getList().size();
                }
                break;
            case "unfinishedClassesReport":

                List<UnfinishedClassesReportDTO> list9 = unfinishedClassesReportService.UnfinishedClassesList();


                if (list9 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list9);
                    count = list9.size();
                }
                break;
            case "trainingOverTime":

                String startDate = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);
                String endDate = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);

                List<TrainingOverTimeDTO.Info> list10 = trainingOverTimeService.getTrainingOverTimeReportList(startDate, endDate);


                if (list10 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list10);
                    count = list10.size();
                }
                break;

            case "attendanceReport":

                String startDate2 = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);
                String endDate2 = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);
                int absentType = Integer.parseInt(searchRq.getCriteria().getCriteria().get(0).getValue().get(0)+"");
                searchRq.getCriteria().getCriteria().remove(0);

                List<AttendanceReportDTO.Info> list12 = attendanceReportService.getAbsentList(startDate2, endDate2,absentType+"");

                list12.forEach(x->
                        {
                            if (x.getAttendanceStatus().equals("3"))
                                x.setAttendanceStatus("غیر موجه");
                            if (x.getAttendanceStatus().equals("4"))
                                x.setAttendanceStatus("موجه");
                        }
                );

                if (list12 == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list12);
                    count = list12.size();
                }
                break;
            case "teacherReport":
                if(searchRq.getCriteria() != null && searchRq.getCriteria().getCriteria() != null){
                    for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                        if(criterion.getValue().get(0).equals("true"))
                            criterion.setValue(true);
                        if(criterion.getValue().get(0).equals("false"))
                            criterion.setValue(false);
                    }
                }
                SearchDTO.SearchRs<ViewTeacherReportDTO.Info> list13 = viewTeacherReportService.search(searchRq);

                if (list13.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list13.getList());
                    count = list13.getList().size();
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
                String[] list = fields1.get(j).get("name").split("\\.");

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
            if (row.get(array.get(index)) == null) {
                return "";
            }
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

        ObjectMapper objectMapper = new ObjectMapper();

        String sortBy = rq.getParameter("_sortBy");


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

            if (sortBy.indexOf('[') > -1) {
                searchRq.setSortBy(objectMapper.readValue(sortBy, Collection.class));
            } else {
                searchRq.setSortBy(sortBy);
            }

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
