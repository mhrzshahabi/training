package com.nicico.training.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.oauth.common.domain.CustomUserDetails;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IPersonnelCourseNotPassedReportViewService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.PersonnelRegisteredDAO;
import com.nicico.training.repository.StudentClassReportViewDAO;
import com.nicico.training.service.*;
import lombok.*;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
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
    private final ViewTrainingOverTimeReportService viewTrainingOverTimeReportService;
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
    private final ViewTeacherReportService viewTeacherReportService;
    private final ViewPostGradeService viewPostGradeService;
    private final PostGradeService postGradeService;
    private final PostService postService;
    private final ViewJobGroupService viewJobGroupService;
    private final JobGroupService jobGroupService;
    private final ViewPostGradeGroupService viewPostGradeGroupService;
    private final PostGradeGroupService postGradeGroupService;
    private final ViewPostGroupService viewPostGroupService;
    private final PostGroupService postGroupService;
    private final PersonnelCoursePassedNAReportViewService personnelCoursePassedNAReportViewService;
    private final WorkGroupService workGroupService;
    private final CourseService courseService;
    private final QuestionBankService questionBankService;
    private final ViewPersonnelTrainingStatusReportService viewPersonnelTrainingStatusReportService;

    private final StudentClassReportViewDAO studentClassReportViewDAO;
    private final PersonnelDAO personnelDAO;
    private final PersonnelRegisteredDAO personnelRegisteredDAO;
    private final ViewAllPostService viewAllPostService;

    private final ExportToFileService exportToFileService;

    private final ViewStatisticsUnitReportService viewStatisticsUnitReportService;
    private final ViewCoursesPassedPersonnelReportService viewCoursesPassedPersonnelReportService;
    private final ContinuousStatusReportViewService continuousStatusReportViewService;

    private final ViewUnfinishedClassesReportService viewUnfinishedClassesReportService;
    private final ViewUnjustifiedAbsenceReportService viewUnjustifiedAbsenceReportService;

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
                                      @RequestParam(value = "criteriaStr") String criteriaStr,
                                      @RequestParam(value = "valueMaps") String valueMaps) throws Exception {


        SearchDTO.SearchRq searchRq = convertToSearchRq(req);

        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>() {
        }.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);

        //Start Of Query
        net.minidev.json.parser.JSONParser parser = new JSONParser(DEFAULT_PERMISSIVE_MODE);

        Map<String, Map<String, String>> parameters = creatValueMap((List<Map<String, String>>) parser.parse(valueMaps));

        String[] jsonString = {null};
        int count[] = {0};
        List<Object> generalList = null;

        switch (fileName) {
            case "questionBank":
                generalList = (List<Object>) ((Object) questionBankService.search(searchRq).getList());
                break;
            case "class":
                searchRq.setCriteria(workGroupService.addPermissionToCriteria("course.categoryId", searchRq.getCriteria()));
                generalList = (List<Object>) ((Object) tclassService.search(searchRq).getList());
                break;

            case "course":
                searchRq.setCriteria(workGroupService.addPermissionToCriteria("categoryId", searchRq.getCriteria()));
                generalList = (List<Object>) ((Object) courseService.search(searchRq, c -> modelMapper.map(c, CourseDTO.Info.class)).getList());
                break;

            case "trainingFile":
                generalList = (List<Object>) ((Object) classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.CoursesOfStudent.class)).getList());
                break;

            case "studentClassReport":
                generalList = (List<Object>) ((Object) SearchUtil.search(studentClassReportViewDAO, searchRq, student -> modelMapper.map(student, StudentClassReportViewDTO.Info.class)).getList());
                break;

            case "personnelInformationReport":
                generalList = (List<Object>) ((Object) SearchUtil.search(personnelDAO, searchRq, personnel -> modelMapper.map(personnel, PersonnelDTO.Info.class)).getList());
                break;
            case "registeredPersonnelInformationReport":
                generalList = (List<Object>) ((Object) SearchUtil.search(personnelRegisteredDAO, searchRq, personnelRegistered -> modelMapper.map(personnelRegistered, PersonnelRegisteredDTO.Info.class)).getList());
                break;

            case "personnelCourseNotPassed":
                generalList = (List<Object>) ((Object) personnelCourseNotPassedReportViewService.search(searchRq, p -> modelMapper.map(p, PersonnelCourseNotPassedReportViewDTO.Info.class)).getList());
                break;

            case "classOutsideCurrentTerm":
                String str = DateUtil.convertKhToMi1(((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim()).replaceAll("[\\s\\-]", "");
                searchRq.getCriteria().getCriteria().remove(0);
                SearchDTO.SearchRs<TclassDTO.Info> classInfoSearchRs = tclassService.search(searchRq);
                List<TclassDTO.Info> classInfoSearchRsList = classInfoSearchRs.getList();
                List<Long> longList = classInfoSearchRsList.stream().filter(x -> Long.valueOf(String.valueOf(x.getCreatedDate()).substring(0, 10).replaceAll("[\\s\\-]", "")) > Long.valueOf(str))
                        .map(x -> x.getId()).collect(Collectors.toList());
                List<TclassDTO.Info> infoList = classInfoSearchRsList.stream().filter(x -> !longList.contains(x.getId())).collect(Collectors.toList());
                classInfoSearchRs.getList().removeAll(infoList);
                generalList = (List<Object>) ((Object) classInfoSearchRsList);
                break;

            case "weeklyTrainingSchedule":
                String userNationalCode = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);
                generalList = (List<Object>) ((Object) classSessionService.searchWeeklyTrainingSchedule(searchRq, userNationalCode).getList());
                break;
            case "trainingClassReport":
                generalList = (List<Object>) ((Object) viewEvaluationStaticalReportService.search(searchRq).getList());
                break;

            case "unfinishedClassesReport":
                SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
                criteriaRq1.setOperator(EOperator.equals);
                criteriaRq1.setFieldName("nationalCode");
                criteriaRq1.setValue(modelMapper.map(SecurityContextHolder.getContext().getAuthentication().getPrincipal(), CustomUserDetails.class).getNationalCode());

                searchRq.setCriteria(criteriaRq1);

                generalList = (List<Object>)((Object) viewUnfinishedClassesReportService.search(searchRq).getList());
                break;
            case "trainingOverTime":
                String startDate3 = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);
                String endDate3 = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);

                SearchDTO.SearchRq request3 = new SearchDTO.SearchRq();
                request3.setStartIndex(null);

                if(req.getParameter("_sortBy")==null){
                    request3.setSortBy("personalNum");
                }else{
                    request3.setSortBy(req.getParameter("_sortBy"));
                }

                List<SearchDTO.CriteriaRq> listOfCriteria3 = new ArrayList<>();

                SearchDTO.CriteriaRq criteriaRq3 = null;

                criteriaRq3 = new SearchDTO.CriteriaRq();
                criteriaRq3.setOperator(EOperator.greaterOrEqual);
                criteriaRq3.setFieldName("date");
                criteriaRq3.setValue(startDate3);

                listOfCriteria3.add(criteriaRq3);

                criteriaRq3 = new SearchDTO.CriteriaRq();
                criteriaRq3.setOperator(EOperator.lessOrEqual);
                criteriaRq3.setFieldName("date");
                criteriaRq3.setValue(endDate3);

                listOfCriteria3.add(criteriaRq3);

                criteriaRq3 = new SearchDTO.CriteriaRq();
                criteriaRq3.setCriteria(listOfCriteria3);
                criteriaRq3.setOperator(EOperator.and);

                request3.setCriteria(criteriaRq3);

                generalList = (List<Object>)((Object) viewTrainingOverTimeReportService.search(request3,o -> modelMapper.map(o, ViewTrainingOverTimeReportDTO.Info.class)).getList());
                break;

            case "attendanceReport": {
                String startDate2 = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);
                String endDate2 = ((String) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).trim();
                searchRq.getCriteria().getCriteria().remove(0);
                int absentType = Integer.parseInt(searchRq.getCriteria().getCriteria().get(0).getValue().get(0) + "");
                searchRq.getCriteria().getCriteria().remove(0);

                SearchDTO.SearchRq request = new SearchDTO.SearchRq();
                request.setStartIndex(null);

                if(req.getParameter("_sortBy")==null){
                    request.setSortBy("personalNum");
                }else{
                    request.setSortBy(req.getParameter("_sortBy"));
                }


                List<SearchDTO.CriteriaRq> listOfCriteria = new ArrayList<>();

                SearchDTO.CriteriaRq criteriaRq = null;

                criteriaRq = new SearchDTO.CriteriaRq();
                criteriaRq.setOperator(EOperator.greaterOrEqual);
                criteriaRq.setFieldName("date");
                criteriaRq.setValue(startDate2);

                listOfCriteria.add(criteriaRq);

                criteriaRq = new SearchDTO.CriteriaRq();
                criteriaRq.setOperator(EOperator.lessOrEqual);
                criteriaRq.setFieldName("date");
                criteriaRq.setValue(endDate2);

                listOfCriteria.add(criteriaRq);

                switch (absentType + "") {
                    case "3": {
                        SearchDTO.CriteriaRq criteriaRq2 = new SearchDTO.CriteriaRq();
                        criteriaRq2.setOperator(EOperator.or);
                        criteriaRq2.setCriteria(new ArrayList<>());

                        criteriaRq = new SearchDTO.CriteriaRq();
                        criteriaRq.setOperator(EOperator.equals);
                        criteriaRq.setFieldName("attendanceStatus");
                        criteriaRq.setValue(3);

                        criteriaRq2.getCriteria().add(criteriaRq);

                        listOfCriteria.add(criteriaRq2);
                        break;
                    }
                    case "4": {
                        SearchDTO.CriteriaRq criteriaRq2 = new SearchDTO.CriteriaRq();
                        criteriaRq2.setOperator(EOperator.or);
                        criteriaRq2.setCriteria(new ArrayList<>());

                        criteriaRq = new SearchDTO.CriteriaRq();
                        criteriaRq.setOperator(EOperator.equals);
                        criteriaRq.setFieldName("attendanceStatus");
                        criteriaRq.setValue(4);

                        criteriaRq2.getCriteria().add(criteriaRq);

                        listOfCriteria.add(criteriaRq2);
                        break;
                    }
                    default: {
                        SearchDTO.CriteriaRq criteriaRq2 = new SearchDTO.CriteriaRq();
                        criteriaRq2.setOperator(EOperator.or);
                        criteriaRq2.setCriteria(new ArrayList<>());

                        criteriaRq = new SearchDTO.CriteriaRq();
                        criteriaRq.setOperator(EOperator.equals);
                        criteriaRq.setFieldName("attendanceStatus");
                        criteriaRq.setValue(4);
                        criteriaRq2.getCriteria().add(criteriaRq);


                        criteriaRq = new SearchDTO.CriteriaRq();
                        criteriaRq.setOperator(EOperator.equals);
                        criteriaRq.setFieldName("attendanceStatus");
                        criteriaRq.setValue(3);
                        criteriaRq2.getCriteria().add(criteriaRq);

                        listOfCriteria.add(criteriaRq2);
                        break;
                    }
                }

                criteriaRq = new SearchDTO.CriteriaRq();
                criteriaRq.setCriteria(listOfCriteria);
                criteriaRq.setOperator(EOperator.and);

                request.setCriteria(criteriaRq);

                SearchDTO.SearchRs result = attendanceReportService.search(request, o -> modelMapper.map(o, ViewAttendanceReportDTO.Info.class));

                List<ViewAttendanceReportDTO.Info> attendanceReportServiceAbsentList = result.getList();
                attendanceReportServiceAbsentList.forEach(x ->
                        {
                            if (x.getAttendanceStatus().equals("3"))
                                x.setAttendanceStatus("غیر موجه");
                            if (x.getAttendanceStatus().equals("4"))
                                x.setAttendanceStatus("موجه");
                        }
                );
                generalList = (List<Object>) ((Object) attendanceReportServiceAbsentList);
                break;
            }
            case "Category":
                generalList = (List<Object>) ((Object) categoryService.search(searchRq).getList());
                break;

            case "SubCategory":
                generalList = (List<Object>) ((Object) subcategoryService.search(searchRq).getList());
                break;

            case "EducationOrientation":
                generalList = (List<Object>) ((Object) educationOrientationService.search(searchRq).getList());
                break;

            case "EducationMajor":
                generalList = (List<Object>) ((Object) educationMajorService.search(searchRq).getClass());
                break;

            case "EducationLevel":
                generalList = (List<Object>) ((Object) educationLevelService.search(searchRq).getList());
                break;

            case "Equipment":
                generalList = (List<Object>) ((Object) equipmentService.search(searchRq).getList());
                break;

            case "teacherReport":
                generalList = (List<Object>) ((Object) viewTeacherReportService.search(searchRq).getList());
                break;

            case "Competence":
                generalList = (List<Object>) ((Object) competenceService.search(searchRq).getList());
                break;

            case "Skill":
                searchRq.setCriteria(workGroupService.addPermissionToCriteria("categoryId", searchRq.getCriteria()));
                generalList = (List<Object>) ((Object) skillService.searchGeneric(searchRq, SkillDTO.Info.class).getList());
                break;

            case "Skill_Post":
                Long skillId = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                searchRq.getCriteria().getCriteria().remove(0);
                generalList = (List<Object>) ((Object) needsAssessmentReportsService.getSkillNAPostList(searchRq, skillId).getList());
                break;

            case "View_Job":
                generalList = (List<Object>) ((Object) viewJobService.search(searchRq).getList());
                break;

            case "Personnel":
                generalList = (List<Object>) ((Object) personnelService.search(searchRq).getList());
                break;

            case "NeedsAssessmentReport":
                Long objectId = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                String objectType = searchRq.getCriteria().getCriteria().get(1).getValue().get(0).toString();
                Long personnelId = searchRq.getCriteria().getCriteria().get(2).getValue().get(0) == null ? null : (Long)searchRq.getCriteria().getCriteria().get(2).getValue().get(0);
                searchRq.getCriteria().getCriteria().remove(0);
                searchRq.getCriteria().getCriteria().remove(0);
                searchRq.getCriteria().getCriteria().remove(0);
                generalList = (List<Object>) ((Object) needsAssessmentReportsService.search(searchRq, objectId, objectType, personnelId).getList());
                break;

            case "View_Post":
                generalList = (List<Object>) ((Object) viewPostService.search(searchRq).getList());
                break;

            case "Post":
                generalList = (List<Object>) ((Object) postService.searchWithoutPermission(searchRq, p -> modelMapper.map(p, PostDTO.Info.class)).getList());
                break;

            case "View_Post_Grade":
                generalList = (List<Object>) ((Object) viewPostGradeService.search(searchRq).getList());
                break;

            case "Post_Grade_Without_Permission":
                generalList = (List<Object>) ((Object) postGradeService.searchWithoutPermission(searchRq).getList());
                break;

            case "View_Job_Group":
                generalList = (List<Object>) ((Object) viewJobGroupService.search(searchRq).getList());
                break;

            case "Job_Group_Personnel":
                Long jobGroup = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                searchRq.getCriteria().getCriteria().remove(0);
                List<JobDTO.Info> jobs = jobGroupService.getJobs(jobGroup);
                if (!jobs.isEmpty()) {
                    SearchDTO.SearchRq coustomSearchRq = ISC.convertToSearchRq(req, jobs.stream().map(JobDTO.Info::getCode).collect(Collectors.toList()), "jobNo", EOperator.inSet);
                    coustomSearchRq.getCriteria().getCriteria().add(makeNewCriteria("active", 1, EOperator.equals, null));
                    coustomSearchRq.getCriteria().getCriteria().add(makeNewCriteria("employmentStatusId", 5, EOperator.equals, null));
                    coustomSearchRq.setCount(searchRq.getCount());
                    generalList = (List<Object>) ((Object) personnelService.search(coustomSearchRq).getList());
                } else
                    generalList = new ArrayList<>(0);
                break;

            case "Job_Group_Post":
                Long jobGroup1 = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                searchRq.getCriteria().getCriteria().remove(0);
                List<JobDTO.Info> jobs1 = jobGroupService.getJobs(jobGroup1);
                if (!jobs1.isEmpty()) {
                    SearchDTO.SearchRq coustomSearchRq1 = ISC.convertToSearchRq(req, jobs1.stream().map(JobDTO.Info::getId).collect(Collectors.toList()), "job", EOperator.inSet);
                    coustomSearchRq1.setCount(searchRq.getCount());
                    generalList = (List<Object>) ((Object) postService.searchWithoutPermission(coustomSearchRq1, p -> modelMapper.map(p, PostDTO.Info.class)).getList());
                } else
                    generalList = new ArrayList<>(0);
                break;

            case "View_Post_Grade_Group":
                generalList = (List<Object>) ((Object) viewPostGradeGroupService.search(searchRq).getList());
                break;

            case "Post_Grade_Group_Personnel":
                Long PostGradeGroup = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                searchRq.getCriteria().getCriteria().remove(0);
                List<PostGradeDTO.Info> postGrades = postGradeGroupService.getPostGrades(PostGradeGroup);
                SearchDTO.SearchRq coustomSearchRq2 = ISC.convertToSearchRq(req, postGrades.stream().map(PostGradeDTO.Info::getCode).collect(Collectors.toList()), "postGradeCode", EOperator.inSet);
                coustomSearchRq2.getCriteria().getCriteria().add(makeNewCriteria("active", 1, EOperator.equals, null));
                coustomSearchRq2.getCriteria().getCriteria().add(makeNewCriteria("employmentStatusId", 5, EOperator.equals, null));
                generalList = (List<Object>) ((Object) personnelService.search(coustomSearchRq2).getList());

                break;

            case "Post_Grade_Group_Post":
                Long PostGradeGroup2 = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                searchRq.getCriteria().getCriteria().remove(0);
                List<PostGradeDTO.Info> postGrades1 = postGradeGroupService.getPostGrades(PostGradeGroup2);
                SearchDTO.SearchRq coustomSearchRq3 = ISC.convertToSearchRq(req, postGrades1.stream().map(PostGradeDTO.Info::getId).collect(Collectors.toList()), "postGrade", EOperator.inSet);
                generalList = (List<Object>) ((Object) postService.searchWithoutPermission(coustomSearchRq3, p -> modelMapper.map(p, PostDTO.Info.class)).getList());
                break;

            case "View_Post_Group":
                generalList = (List<Object>) ((Object) viewPostGroupService.search(searchRq).getList());
                break;

            case "Post_Group":
                generalList = (List<Object>) ((Object) postGroupService.search(searchRq).getList());
                break;

            case "personnelCourseNAR":
                generalList = (List<Object>) ((Object) personnelCoursePassedNAReportViewService.search(searchRq, r -> modelMapper.map(r, PersonnelCoursePassedNAReportViewDTO.MinInfo.class)).getList());
                break;

            case "Post_Group_Post":
                Long postGroup = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                searchRq.getCriteria().getCriteria().remove(0);
                generalList = (List<Object>) ((Object) postGroupService.getPosts(postGroup));
                break;

            case "viewPersonnelTrainingStatusReport":
                generalList = (List<Object>) ((Object) viewPersonnelTrainingStatusReportService.search(searchRq).getList());
                break;

            case "statisticsUnitReport":
                searchRq.setSortBy("id");
                generalList = (List<Object>)((Object) viewStatisticsUnitReportService.search(searchRq,o -> modelMapper.map(o, ViewStatisticsUnitReportDTO.Grid.class)).getList());
                break;

            case "coursesPassedPersonnel":
                searchRq.setSortBy("id");
                generalList = (List<Object>)((Object) viewCoursesPassedPersonnelReportService.search(searchRq).getList());
                break;

            case "continuousPersonnel":
                searchRq.setSortBy("empNo");
                generalList = (List<Object>)((Object) continuousStatusReportViewService.search(searchRq).getList());
                break;

            case "unjustifiedAbsence":
                searchRq.setSortBy("studentId");
                generalList = (List<Object>)((Object) viewUnjustifiedAbsenceReportService.search(searchRq,o -> modelMapper.map(o, ViewUnjustifiedAbsenceReportDTO.Info.class)).getList());
                break;

            case "PersonnelPostGroup":

                Long postGroupId = ((Integer) searchRq.getCriteria().getCriteria().get(0).getValue().get(0)).longValue();
                searchRq.getCriteria().getCriteria().remove(0);

                List<ViewAllPostDTO.Info> postList = viewAllPostService.getAllPosts(postGroupId);
                if (postList == null || postList.isEmpty()) {
                    return ;
                }

                searchRq.getCriteria().getCriteria().add(makeNewCriteria("postId",postList.stream().map(ViewAllPostDTO.Info::getPostId).collect(Collectors.toList()),EOperator.inSet,null));
                searchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));

                generalList = (List<Object>)((Object) personnelService.search(searchRq).getList());
                break;

            case "teacherTrainingClasses":
                Long teacherId = null;
                SearchDTO.CriteriaRq removeCriterion = null;
                for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                    if(criterion.getFieldName().equalsIgnoreCase("teacherId")){
                        teacherId = ((Integer) criterion.getValue().get(0)).longValue();
                        removeCriterion = criterion;
                    }
                }
                searchRq.getCriteria().getCriteria().remove(removeCriterion);
                generalList = (List<Object>) ((Object) tclassService.searchByTeachingHistory(searchRq, teacherId).getList());
                break;
        }

        //End Of Query
        //Start Parse
        setExcelValues(jsonString, count, generalList);
        net.minidev.json.JSONArray jsonArray = (JSONArray) parser.parse(jsonString[0]);
        net.minidev.json.JSONObject jsonObject = null;
        int sizeOfFields = fields1.size();
        String tmpName = "";
        List<HashMap<String, String>> allData = new ArrayList<HashMap<String, String>>();

        for (int i = 0; i < count[0]; i++) {
            jsonObject = (JSONObject) jsonArray.get(i);

            HashMap<String, String> tmpData = new HashMap<String, String>();

            for (int j = 0; j < sizeOfFields; j++) {
                String fieldName = fields1.get(j).get("name");
                String[] list = fieldName.split("\\.");

                List<String> aList = null;

                if (list.length == 0) {
                    aList = new ArrayList<String>();
                    aList.add(fields1.get(j).get("name"));
                } else {
                    aList = Arrays.asList(list);
                }

                tmpName = getData(jsonObject, aList, 0);

                if (parameters.containsKey(fieldName)) {
                    tmpName = parameters.get(fieldName).get(tmpName);
                }

                tmpData.put(fields1.get(j).get("name"), tmpName);
            }
            tmpData.put("rowNum", Integer.toString(i + 1));

            allData.add(tmpData);
        }

        //EndParse


        try {
            String data = objectMapper.writeValueAsString(allData);

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
        String startRowStr = rq.getParameter("_startRow");
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

        searchRq.setStartIndex(Integer.parseInt(startRowStr));
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

    private Map<String, Map<String, String>> creatValueMap(List<Map<String, String>> parameters) {
        Map<String, Map<String, String>> map = new HashMap<>();
        for (Map<String, String> value : parameters) {
            map.put(value.get("value"), (Map<String, String>) (Object) value.get("map"));
        }
        return map;
    }

    private <T> void setExcelValues(String jsonStringRef[], int countRef[], List<T> list) throws JsonProcessingException {
        if (list == null) {
            countRef[0] = 0;
        } else {
            jsonStringRef[0] = objectMapper.writeValueAsString(list);
            countRef[0] = list.size();
        }
    }

}
