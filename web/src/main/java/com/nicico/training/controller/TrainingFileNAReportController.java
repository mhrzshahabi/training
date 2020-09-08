/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/09/08
 */

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
import com.nicico.training.utility.CriteriaConverter;
import lombok.RequiredArgsConstructor;
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
@RequestMapping("/training-file-na-report")
public class TrainingFileNAReportController {

    private final ExportToFileService exportToFileService;

    private final ModelMapper modelMapper;
    private final MessageSource messageSource;
    private final ObjectMapper objectMapper;
    @Autowired
    protected EntityManager entityManager;


    @PostMapping(value = {"/export-report"})
    public void exportReport(final HttpServletRequest req,
                                      final HttpServletResponse response,
                                      @RequestParam(value = "fields") String fields,
                                      @RequestParam(value = "titr") String titr,
                                      @RequestParam(value = "pageName") String pageName,
                                      @RequestParam(value = "fileName") String fileName,
                                      @RequestParam(value = "criteriaStr") String criteriaStr,
                                      @RequestParam(value = "valueMaps") String valueMaps) throws Exception {


        /*SearchDTO.SearchRq searchRq = convertToSearchRq(req);

        Gson gson = new Gson();
        Type resultType = new TypeToken<List<HashMap<String, String>>>() {
        }.getType();
        List<HashMap<String, String>> fields1 = gson.fromJson(fields, resultType);

        //Start Of Query
        JSONParser parser = new JSONParser(DEFAULT_PERMISSIVE_MODE);

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
                Map<String,Object[]> classoutsideParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), classoutsideParams);
                String str = DateUtil.convertKhToMi1((classoutsideParams.get("costumeStartDate")[0].toString().replaceAll("[\\s\\-]", "")));
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"costumeStartDate");
                SearchDTO.SearchRs<TclassDTO.Info> classInfoSearchRs = tclassService.search(searchRq);
                List<TclassDTO.Info> classInfoSearchRsList = classInfoSearchRs.getList();
                List<Long> longList = classInfoSearchRsList.stream().filter(x -> Long.valueOf(String.valueOf(x.getCreatedDate()).substring(0, 10).replaceAll("[\\s\\-]", "")) > Long.valueOf(str.replaceAll("-",""))).map(x -> x.getId()).collect(Collectors.toList());
                List<TclassDTO.Info> infoList = classInfoSearchRsList.stream().filter(x -> !longList.contains(x.getId())).collect(Collectors.toList());
                classInfoSearchRs.getList().removeAll(infoList);
                generalList = (List<Object>) ((Object) classInfoSearchRsList);
                break;

            case "weeklyTrainingSchedule":
                Map<String,Object[]> weeklyTrainingParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), weeklyTrainingParams);
                String userNationalCode = (String)weeklyTrainingParams.get("nationalCode")[0];
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"nationalCode");
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
                Map<String,Object[]> attendanceParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), attendanceParams);
                String startDate2 = (String) attendanceParams.get("startDate")[0];
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"startDate");
                String endDate2 = (String) attendanceParams.get("endDate")[0];
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"endDate");
                Integer absentType = Integer.parseInt(attendanceParams.get("absentType")[0].toString());
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"absentType");

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
                Map<String,Object[]> SkillPostParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), SkillPostParams);
                Long skillId = ((Integer)SkillPostParams.get("skillId")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"skillId");
                generalList = (List<Object>) ((Object) needsAssessmentReportsService.getSkillNAPostList(searchRq, skillId).getList());
                break;

            case "View_Job":
                generalList = (List<Object>) ((Object) viewJobService.search(searchRq).getList());
                break;

            case "jobPersonnel":
                Map<String,Object[]> jobPersonnelParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), jobPersonnelParams);
                Long jobId = ((Integer) jobPersonnelParams.get("jobId")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"jobId");
                List<PostDTO.Info> jobPostList = jobService.getPostsWithTrainingPost(jobId);
                if (jobPostList.isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }
                SearchDTO.SearchRq coustomSearchRq5 = ISC.convertToSearchRq(req, jobPostList.stream().map(PostDTO.Info::getId).collect(Collectors.toList()), "postId", EOperator.inSet);
                coustomSearchRq5.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
                coustomSearchRq5.setDistinct(true);
                coustomSearchRq5.getCriteria().getCriteria().addAll(searchRq.getCriteria().getCriteria());
                generalList = (List<Object>) ((Object) personnelService.search(coustomSearchRq5).getList());
                break;

            case "postGradePersonnel":
                Map<String,Object[]> postGradePersonnelParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), postGradePersonnelParams);
                Long postGradeId = ((Integer) postGradePersonnelParams.get("postGradeId")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"postGradeId");
                List<PostDTO.TupleInfo> postList = postGradeService.getPosts(postGradeId);
                if (postList.isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }
                SearchDTO.SearchRq coustomSearchRq4 = ISC.convertToSearchRq(req, postList.stream().filter(post -> post.getDeleted() == null).map(PostDTO.TupleInfo::getId).collect(Collectors.toList()), "postId", EOperator.inSet);
                coustomSearchRq4.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
                coustomSearchRq4.getCriteria().getCriteria().addAll(searchRq.getCriteria().getCriteria());
                generalList = (List<Object>) ((Object) personnelService.search(coustomSearchRq4).getList());
                break;

            case "trainingPostPersonnel":
                Map<String,Object[]> trainingPostPersonnelParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), trainingPostPersonnelParams);
                Long trainingPostId = ((Integer) trainingPostPersonnelParams.get("trainingPostId")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"trainingPostId");
                List<PostDTO.Info> trainingPostList = trainingPostService.getPosts(trainingPostId);
                if (trainingPostList.isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }
                SearchDTO.SearchRq coustomSearchRq6 = ISC.convertToSearchRq(req, trainingPostList.stream().map(PostDTO.Info::getId).collect(Collectors.toList()), "postId", EOperator.inSet);
                coustomSearchRq6.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
                coustomSearchRq6.getCriteria().getCriteria().addAll(searchRq.getCriteria().getCriteria());
                generalList = (List<Object>) ((Object) personnelService.search(coustomSearchRq6).getList());
                break;

            case "NeedsAssessmentReport":
                Map<String,Object[]> NeedsAssessmentParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), NeedsAssessmentParams);
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"objectId");
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"objectType");
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"personnelId");
                Long objectId = ((Integer)NeedsAssessmentParams.get("objectId")[0]).longValue();
                String objectType = (String) NeedsAssessmentParams.get("objectType")[0];
                Long personnelId = NeedsAssessmentParams.get("personnelId") == null ? null : ((Integer)NeedsAssessmentParams.get("personnelId")[0]).longValue();
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
                BaseService.setCriteriaToNotSearchDeleted(searchRq);
                generalList = (List<Object>) ((Object) postGradeService.searchWithoutPermission(searchRq).getList());
                break;

            case "View_Job_Group":
                generalList = (List<Object>) ((Object) viewJobGroupService.search(searchRq).getList());
                break;

            case "Job_Group_Personnel":
                Map<String,Object[]> JobGroupPersonnelParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), JobGroupPersonnelParams);
                Long jobGroup = ((Integer) JobGroupPersonnelParams.get("jobGroupId")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"jobGroupId");
                List<JobDTO.Info> jobs = jobGroupService.getJobs(jobGroup);
                if (jobs.isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }
                SearchDTO.CriteriaRq criteria=new SearchDTO.CriteriaRq();
                criteria.setOperator(EOperator.and);
                criteria.setCriteria(new ArrayList<>());

                SearchDTO.SearchRq jobGroupSearchRq = new SearchDTO.SearchRq().setCriteria(criteria);
                jobGroupSearchRq.getCriteria().getCriteria().add(makeNewCriteria("trainingPostSet.job", jobs.stream().filter(job -> job.getDeleted() == null).map(JobDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
                jobGroupSearchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
                jobGroupSearchRq.getCriteria().getCriteria().add(makeNewCriteria("trainingPostSet.deleted", null, EOperator.isNull, null));
                SearchDTO.SearchRs<PostDTO.TupleInfo> jobGrouptList = postService.searchWithoutPermission(jobGroupSearchRq, p -> modelMapper.map(p, PostDTO.TupleInfo.class));
                if (jobGrouptList.getList() == null || jobGrouptList.getList().isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }
                jobGroupSearchRq = ISC.convertToSearchRq(req, jobGrouptList.getList().stream().map(PostDTO.TupleInfo::getId).collect(Collectors.toList()), "postId", EOperator.inSet);
                jobGroupSearchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
                jobGroupSearchRq.getCriteria().getCriteria().addAll(searchRq.getCriteria().getCriteria());
                generalList = (List<Object>) ((Object) personnelService.search(jobGroupSearchRq).getList());
                break;

            case "Job_Group_Post":
                Map<String,Object[]> JobGroupPostParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), JobGroupPostParams);
                Long jobGroupPost = ((Integer) JobGroupPostParams.get("jobGroup")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"jobGroup");
                List<JobDTO.Info> jobsPosts = jobGroupService.getJobs(jobGroupPost);
                if (jobsPosts.isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }
                SearchDTO.SearchRq postSearchRq = ISC.convertToSearchRq(req, jobsPosts.stream().filter(job -> job.getDeleted() == null).map(JobDTO.Info::getId).collect(Collectors.toList()), "job", EOperator.inSet);
                BaseService.setCriteriaToNotSearchDeleted(postSearchRq);
                postSearchRq.getCriteria().getCriteria().addAll(searchRq.getCriteria().getCriteria());
                generalList = (List<Object>) postService.searchWithoutPermission(postSearchRq, p -> modelMapper.map(p, PostDTO.Info.class)).getList();
                break;

            case "View_Post_Grade_Group":
                generalList = (List<Object>) ((Object) viewPostGradeGroupService.search(searchRq).getList());
                break;

            case "Post_Grade_Group_Personnel":
                Map<String,Object[]> postGradeGroupPersonnelParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), postGradeGroupPersonnelParams);
                Long PostGradeGroup = ((Integer) postGradeGroupPersonnelParams.get("PostGradeGroupId")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(),"PostGradeGroupId");
                List<PostGradeDTO.Info> postGrades = postGradeGroupService.getPostGrades(PostGradeGroup);
                if (postGrades == null || postGrades.isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }
                SearchDTO.CriteriaRq criteriaRq=new SearchDTO.CriteriaRq();
                criteriaRq.setCriteria(new ArrayList<>());
                criteriaRq.setOperator(EOperator.and);

                SearchDTO.SearchRq coustomSearchRq2 = new SearchDTO.SearchRq().setCriteria(criteriaRq);
                coustomSearchRq2.getCriteria().getCriteria().add(makeNewCriteria("trainingPostSet.postGrade", postGrades.stream().filter(pg -> pg.getDeleted() == null).map(PostGradeDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null)) ;
                coustomSearchRq2.getCriteria().getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
                coustomSearchRq2.getCriteria().getCriteria().add(makeNewCriteria("trainingPostSet.deleted",null, EOperator.isNull, null));
                SearchDTO.SearchRs<PostDTO.TupleInfo> postGradeGroupPersonnelPostList = postService.searchWithoutPermission(coustomSearchRq2, p -> modelMapper.map(p, PostDTO.TupleInfo.class));
                if (postGradeGroupPersonnelPostList.getList() == null || postGradeGroupPersonnelPostList.getList().isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }
                coustomSearchRq2 = ISC.convertToSearchRq(req, postGradeGroupPersonnelPostList.getList().stream().map(PostDTO.TupleInfo::getId).collect(Collectors.toList()), "postId", EOperator.inSet);
                coustomSearchRq2.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));
                coustomSearchRq2.getCriteria().getCriteria().addAll(searchRq.getCriteria().getCriteria());
                generalList = (List<Object>) ((Object) personnelService.search(coustomSearchRq2).getList());
                break;

            case "Post_Grade_Group_Post":
                Map<String,Object[]> postGradeGroupPostParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), postGradeGroupPostParams);
                Long PostGradeGroup2 = ((Integer) postGradeGroupPostParams.get("PostGradeGroup")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(), "PostGradeGroup");
                List<PostGradeDTO.Info> postGradePosts = postGradeGroupService.getPostGrades(PostGradeGroup2);
                if (postGradePosts.isEmpty()) {
                    generalList = new ArrayList<>(0);
                    break;
                }

                searchRq.getCriteria().getCriteria().add(makeNewCriteria("postGrade",postGradePosts.stream().filter(pg -> pg.getDeleted() == null).map(PostGradeDTO.Info::getId).collect(Collectors.toList()),EOperator.inSet,null));
                BaseService.setCriteriaToNotSearchDeleted(searchRq);
                generalList = (List<Object>) postService.searchWithoutPermission(searchRq, p -> modelMapper.map(p, PostDTO.Info.class)).getList();
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
                Map<String,Object[]> postGroupParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), postGroupParams);
                Long group =((Integer) postGroupParams.get("postGroup")[0]).longValue();

                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(), "postGroup");

                generalList = (List<Object>) ((Object) postGroupService.getPosts(group));
                break;

            case "trainingPost":
                BaseService.setCriteriaToNotSearchDeleted(searchRq);
                generalList = (List<Object>) ((Object) viewTrainingPostService.search(searchRq).getList());
                break;

            case "trainingPost_Post":
                BaseService.setCriteriaToNotSearchDeleted(searchRq);
                generalList = (List<Object>) postService.searchWithoutPermission(searchRq, p -> modelMapper.map(p, PostDTO.Info.class)).getList();
                break;

            case "Training_Post_Group_Post":
                generalList = (List<Object>) ((Object) trainingPostService.search(searchRq).getList());
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
                Map<String,Object[]> postGroupPersonnelParams = new HashMap<>();
                CriteriaConverter.criteria2ParamsMap(searchRq.getCriteria(), postGroupPersonnelParams);
                Long postGroupId = ((Integer) postGroupPersonnelParams.get("postGroupId")[0]).longValue();
                CriteriaConverter.removeCriteriaByfieldName(searchRq.getCriteria(), "postGroupId");

                List<ViewAllPostDTO.Info> PersonnelPostGroupPostList = viewAllPostService.getAllPosts(postGroupId);
                if (PersonnelPostGroupPostList == null || PersonnelPostGroupPostList.isEmpty()) {
                    return ;
                }

                searchRq.getCriteria().getCriteria().add(makeNewCriteria("postId",PersonnelPostGroupPostList.stream().map(ViewAllPostDTO.Info::getPostId).collect(Collectors.toList()),EOperator.inSet,null));
                searchRq.getCriteria().getCriteria().add(makeNewCriteria("deleted", 0, EOperator.equals, null));

                generalList = (List<Object>)((Object) personnelService.search(searchRq).getList());
                break;

            case "teacherTrainingClasses":
                Long teacherId = null;
                SearchDTO.CriteriaRq removeCriterion = null;
                for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                    if(criterion.getFieldName() != null && criterion.getFieldName().equalsIgnoreCase("teacherId")){
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
        JSONArray jsonArray = (JSONArray) parser.parse(jsonString[0]);
        JSONObject jsonObject = null;
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
        }*/
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

    private static SearchDTO.SearchRq convertToSearchRq(HttpServletRequest rq) throws IOException {

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
