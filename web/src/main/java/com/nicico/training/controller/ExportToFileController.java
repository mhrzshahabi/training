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
import com.nicico.training.model.*;
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
    private final CategoryService categoryService;
    private final SubcategoryService subcategoryService;
    private final EducationOrientationService educationOrientationService;
    private final EducationMajorService educationMajorService;
    private final EducationLevelService educationLevelService;
    private final EquipmentService equipmentService;
    private final CompetenceService competenceService;
    private final SkillService skillService;
    private final NeedsAssessmentReportsService needsAssessmentReportsService;
    private final ViewJobService viewJobService;
    private final PersonnelService personnelService;
    private final ViewPostService viewPostService;

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


            case "teacherReport":
                String id = req.getParameter("id");

                if (id != null) {

                    searchRq.setCriteria(makeNewCriteria("id", id, EOperator.equals, new ArrayList<>()));
                    searchRq.setStartIndex(0);
                    searchRq.setCount(1);
                }

                searchRq.setDistinct(true);

                List<Object> removedObjects = new ArrayList<>();
                Object evaluationCategory = null;
                Object evaluationSubCategory = null;
                Object evaluationGrade = null;
                Object teachingCategories = null;
                Object teachingSubCategories = null;
                Object term = null;
                for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                    if (criterion.getFieldName().equalsIgnoreCase("evaluationCategory")) {
                        evaluationCategory = criterion.getValue().get(0);
                        removedObjects.add(criterion);
                    }
                    if (criterion.getFieldName().equalsIgnoreCase("evaluationSubCategory")) {
                        evaluationSubCategory = criterion.getValue().get(0);
                        removedObjects.add(criterion);
                    }
                    if (criterion.getFieldName().equalsIgnoreCase("evaluationGrade")) {
                        evaluationGrade = criterion.getValue().get(0);
                        removedObjects.add(criterion);
                    }
                    if (criterion.getFieldName().equalsIgnoreCase("teachingCategories")) {
                        teachingCategories = criterion.getValue();
                        removedObjects.add(criterion);
                    }
                    if (criterion.getFieldName().equalsIgnoreCase("teachingSubCategories")) {
                        teachingSubCategories = criterion.getValue();
                        removedObjects.add(criterion);
                    }

                    if (criterion.getFieldName().equalsIgnoreCase("termId")) {
                        criterion.setFieldName("tclasse.term.id");
                        criterion.setOperator(EOperator.inSet);
                    }
                }

                for (Object removedObject : removedObjects) {
                    searchRq.getCriteria().getCriteria().remove(removedObject);
                }

                Set<TeacherDTO.Report> set = new HashSet<>();
                SearchDTO.SearchRs<TeacherDTO.Report> tmpresponse = teacherService.deepSearchReport(searchRq);


                List<TeacherDTO.Report> listRemovedObjects = new ArrayList<>();

                Float min_evalGrade = null;
                if (evaluationGrade != null)
                    min_evalGrade = Float.parseFloat(evaluationGrade.toString());

                if (evaluationGrade != null && evaluationCategory != null && evaluationSubCategory != null) {
                    for (TeacherDTO.Report datum : tmpresponse.getList()) {
                        if (evaluationGrade != null) {
                            Float teacher_evalGrade = (Float) teacherService.evaluateTeacher(datum.getId(), evaluationCategory.toString(), evaluationSubCategory.toString()).get("evaluationGrade");
                            datum.setEvaluationGrade("" + teacher_evalGrade);
                            if (teacher_evalGrade < min_evalGrade)
                                listRemovedObjects.add(datum);
                        }
                    }
                }

                for (TeacherDTO.Report listRemovedObject : listRemovedObjects)
                    tmpresponse.getList().remove(listRemovedObject);
                listRemovedObjects.clear();

                for (TeacherDTO.Report datum : tmpresponse.getList()) {
                    Long tId = datum.getId();
                    List<?> result1 = null;
                    Object[] res1 = null;
                    String courseId = null;
                    String classId = null;
                    List<?> result2 = null;
                    String courseTitle = null;
                    List<?> result3 = null;
                    String classCount = null;

                    String sql1 = "select f_course,id from tbl_class where c_start_date = (select MAX(c_start_date) from tbl_class where f_teacher =" + tId + ") AND ROWNUM = 1";
                    result1 = (List<?>) entityManager.createNativeQuery(sql1).getResultList();
                    if (result1.size() > 0) {
                        res1 = (Object[]) result1.get(0);
                        courseId = res1[0].toString();
                        classId = res1[1].toString();
                    }

                    if (courseId != null) {
                        String sql2 = "select c_title_fa from tbl_course where id =" + courseId;
                        result2 = (List<?>) entityManager.createNativeQuery(sql2).getResultList();
                        courseTitle = (String) result2.get(0);
                    }

                    String sql3 = "select count(id) from tbl_class where f_teacher =" + tId;
                    result3 = (List<?>) entityManager.createNativeQuery(sql3).getResultList();
                    classCount = ((BigDecimal) result3.get(0)).toString();

                    datum.setLastCourse(courseTitle);
                    datum.setNumberOfCourses(classCount);
                    if (datum.getLastCourse() != null)
                        datum.setLastCourseEvaluationGrade("" + tclassService.getClassReactionEvaluationGrade(Long.parseLong(classId), tId));
                }

                if (tmpresponse.getList() == null || tmpresponse.getList().size() == 0) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(tmpresponse.getList());
                    count = tmpresponse.getList().size();
                }

                break;
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

            case "Category":

                SearchDTO.SearchRs<CategoryDTO.Info> list14 = categoryService.search(searchRq);

                if (list14.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list14.getList());
                    count = list14.getList().size();
                }
                break;

            case "SubCategory":

                SearchDTO.SearchRs<SubcategoryDTO.Info> list13 = subcategoryService.search(searchRq);

                if (list13.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list13.getList());
                    count = list13.getList().size();
                }
                break;

            case "EducationOrientation":

                SearchDTO.SearchRs<EducationOrientationDTO.Info> list15 = educationOrientationService.search(searchRq);

                if (list15.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list15.getList());
                    count = list15.getList().size();
                }
                break;

            case "EducationMajor":

                SearchDTO.SearchRs<EducationMajorDTO.Info> list16 = educationMajorService.search(searchRq);

                if (list16.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list16.getList());
                    count = list16.getList().size();
                }
                break;

            case "EducationLevel":

                SearchDTO.SearchRs<EducationLevelDTO.Info> list17 = educationLevelService.search(searchRq);

                if (list17.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list17.getList());
                    count = list17.getList().size();
                }
                break;

            case "Equipment":

                SearchDTO.SearchRs<EquipmentDTO.Info> list18 = equipmentService.search(searchRq);

                if (list18.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list18.getList());
                    count = list18.getList().size();
                }
                break;

            case "Competence":

                SearchDTO.SearchRs<CompetenceDTO.Info> list19 = competenceService.search(searchRq);

                if (list19.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list19.getList());
                    count = list19.getList().size();
                }
                break;

            case "Skill":

                SearchDTO.SearchRs<SkillDTO.Info> list20 = skillService.searchGeneric(searchRq, SkillDTO.Info.class);

                if (list20.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list20.getList());
                    count = list20.getList().size();
                }
                break;

            case "Skill_Post":

                Long skillId = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                searchRq.getCriteria().getCriteria().remove(0);

                SearchDTO.SearchRs<PostDTO.Info> list21 = needsAssessmentReportsService.getSkillNAPostList(searchRq, skillId);

                if (list21.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list21.getList());
                    count = list21.getList().size();
                }
                break;

            case "Job":

                SearchDTO.SearchRs<ViewjobDTO.Info> list22 = viewJobService.search(searchRq);

                if (list22.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list22.getList());
                    count = list22.getList().size();
                }
                break;

            case "Job_Personnel":

                SearchDTO.SearchRs<PersonnelDTO.Info> list23 = personnelService.search(searchRq);

                if (list23.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list23.getList());
                    count = list23.getList().size();
                }
                break;

            case "Job_NA":

                Long objectId = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                String objectType = searchRq.getCriteria().getCriteria().get(1).getValue().get(0).toString();
                String personnelNo = searchRq.getCriteria().getCriteria().get(2).getValue().get(0) == null ? null : searchRq.getCriteria().getCriteria().get(2).getValue().get(0).toString();

                searchRq.getCriteria().getCriteria().remove(0);searchRq.getCriteria().getCriteria().remove(0);searchRq.getCriteria().getCriteria().remove(0);

                SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> list24 = needsAssessmentReportsService.search(searchRq, objectId, objectType, personnelNo);

                if (list24.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list24.getList());
                    count = list24.getList().size();
                }
                break;

            case "Job_Post":

                SearchDTO.SearchRs<ViewPostDTO.Info> list25 = viewPostService.search(searchRq);

                if (list25.getList() == null) {
                    count = 0;
                } else {
                    ObjectMapper mapper = new ObjectMapper();
                    jsonString = mapper.writeValueAsString(list25.getList());
                    count = list25.getList().size();
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
