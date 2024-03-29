package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.student.StudentMapper;
import com.nicico.training.model.*;
import com.nicico.training.repository.AttendanceDAO;
import com.nicico.training.repository.ClassSessionDAO;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.PersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import request.exam.ElsExamScore;
import request.exam.ElsStudentScore;
import request.exam.ExamResult;
import response.BaseResponse;
import response.PaginationDto;
import response.tclass.dto.*;

import java.util.*;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.nicico.training.utility.persianDate.MyUtils.*;
import static com.nicico.training.utility.persianDate.PersianDate.getEpochDate;

@Service
@RequiredArgsConstructor
public class ClassStudentService implements IClassStudentService {

    private final ClassStudentDAO classStudentDAO;
    private final AttendanceDAO attendanceDAO;
    private final ClassStudentHistoryService classStudentHistoryService;
    private final ITclassService tclassService;
    private final IStudentService studentService;
    private final IFamilyPersonnelService familyPersonnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final ModelMapper mapper;
    private final StudentMapper studentMapper;
    private final IEvaluationAnalysisService evaluationAnalysisService;
    private final PersonnelService personnelService;
    private final ITeacherService iTeacherService;
    private final ITestQuestionService testQuestionService;
    private final ParameterValueService parameterValueService;
    private final PersonnelDAO personnelDAO;
    private final ISynonymPersonnelService synonymPersonnelService;
    private final IParameterService parameterService;
    private final ClassSessionDAO classSessionDAO;
    private final IParameterValueService iParameterValueService;
    private final IRequestItemCoursesDetailService coursesDetailService;

    @Lazy
    @Autowired
    private SendMessageService sendMessageService;

    @Value("${nicico.elsSmsUrl}")
    private String elsSmsUrl;

    @Transactional(readOnly = true)
    @Override
    public ClassStudent getClassStudent(Long id) {
        Optional<ClassStudent> optionalStudent = classStudentDAO.findById(id);
        return optionalStudent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(classStudentDAO, request, converter);
    }

    @Transactional
    @Override
    public Map<String, String> registerStudents(List<ClassStudentDTO.Create> request, Long classId) {
        List<String> invalStudents = new ArrayList<>();
        Tclass tclass = tclassService.getTClass(classId);
        TeacherDTO.Info teacher = iTeacherService.get(tclass.getTeacherId());
        if (teacher.getTeacherCode() != null) {
            //check for know students and teacher is equal or not
            ClassStudentDTO.Create checkTeacher = request.stream()
                    .filter(q -> teacher.getTeacherCode().equals(q.getNationalCode()))
                    .findFirst()
                    .orElse(null);
            if (checkTeacher != null)
                throw new TrainingException(TrainingException.ErrorType.registerNotAccepted);
        }

        List<String> classStudentsNationalCode = getClassStudentsNationalCode(classId);
        request.removeIf(create -> classStudentsNationalCode.contains(create.getNationalCode()));

        for (ClassStudentDTO.Create c : request) {
            List<Student> list = studentService.getStudentByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(c.getPostId(), c.getPersonnelNo(), c.getDepartmentId(), c.getFirstName(), c.getLastName());
            Student student = null;
            int size = list.size();
            for (int i = 0; i < size; i++) {
                if (Objects.equals(1, list.get(i).getActive())) {
                    student = list.get(i);
                    break;
                }
                if (i == size - 1) {
                    student = list.get(i);
                }
            }
            if (student == null) {
                student = new Student();
                if (c.getRegisterTypeId() == 1) {
                    mapper.map(personnelService.getByPersonnelCodeAndNationalCode(c.getNationalCode(), c.getPersonnelNo()), student);
                    student.setDeleted(null);
                } else if (c.getRegisterTypeId() == 2) {
                    mapper.map(personnelRegisteredService.getByPersonnelCodeAndNationalCode(c.getNationalCode(), c.getPersonnelNo()), student);
                } else if (c.getRegisterTypeId() == 3) {
                    student = studentMapper.toStudent(familyPersonnelService.getById(c.getId()));
                    student.setFamily(true);
                }

                /*SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
//                SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
                SearchDTO.CriteriaRq rq = makeNewCriteria("nationalCode", student.getNationalCode(), EOperator.equals, null);
                SearchDTO.SearchRs<StudentDTO.Info> search = studentService.search(searchRq.setCriteria(rq));
                List<StudentDTO.Info> studentsByNationalCode = search.getList();*/
                List<Student> studentByNationalCode = studentService.getStudentByNationalCode(student.getNationalCode());

                for (Student student1 : studentByNationalCode) {
                    student1.setActive(0);
                }

            }
            ClassStudent classStudent = new ClassStudent();
            if (c.getApplicantCompanyName() != null)
                classStudent.setApplicantCompanyName(c.getApplicantCompanyName());
            else {
                invalStudents.add(student.getFirstName() + " " + student.getLastName());
                continue;
            }
            if (c.getTypeOfEnterToClass() != null)
                classStudent.setTypeOfEnterToClassId(c.getTypeOfEnterToClass());
            if (c.getPresenceTypeId() != null)
                classStudent.setPresenceTypeId(c.getPresenceTypeId());
            classStudent.setTclass(tclass);
            classStudent.setStudent(student);
            classStudentDAO.saveAndFlush(classStudent);
        }
        String nameList = "";
        if (invalStudents.size() > 0) {
            for (String name : invalStudents) {
                nameList += name + " , ";
            }
        } else
            nameList = null;
        Map<String, String> map = new HashMap();
        map.put("names", nameList);
        map.put("accepted", Integer.toString(request.size() - invalStudents.size()));
        return map;
    }

    @Transactional
    @Override
    public void saveOrUpdate(ClassStudent classStudent) {
        ClassStudent tclass = classStudentDAO.save(classStudent);
        evaluationAnalysisService.updateLearningEvaluation(tclass.getTclassId(), tclass.getTclass().getScoringMethod());
    }

    @Override
    public ClassStudent save(ClassStudent classStudent) {
        return classStudentDAO.save(classStudent);
    }

    @Override
    public BaseResponse syncPersonnelData(Long id) {
        BaseResponse response = new BaseResponse();

        ClassStudent classStudent = getClassStudent(id);
        String nationalCode = classStudent.getStudent().getNationalCode();
        SynonymPersonnel synonymPersonnel = synonymPersonnelService.getByNationalCode(nationalCode);
        if (synonymPersonnel != null) {
            Student student = classStudent.getStudent();
            StudentDTO.UpdateForSyncData updateStudent = new StudentDTO.UpdateForSyncData();
            updateStudent.setPostCode(synonymPersonnel.getPostCode());
            updateStudent.setFirstName(synonymPersonnel.getFirstName());
            updateStudent.setLastName(synonymPersonnel.getLastName());
            updateStudent.setNationalCode(synonymPersonnel.getNationalCode());
            updateStudent.setBirthCertificateNo(synonymPersonnel.getBirthCertificateNo());
            updateStudent.setPersonnelNo(synonymPersonnel.getPersonnelNo());
            updateStudent.setPersonnelNo2(synonymPersonnel.getPersonnelNo2());
            updateStudent.setCompanyName(synonymPersonnel.getCompanyName());
            updateStudent.setPostTitle(synonymPersonnel.getPostTitle());
            updateStudent.setPostGradeCode(synonymPersonnel.getPostGradeCode());
            updateStudent.setPostGradeTitle(synonymPersonnel.getPostGradeTitle());
            updateStudent.setCcpAffairs(synonymPersonnel.getCcpAffairs());
            updateStudent.setCcpArea(synonymPersonnel.getCcpArea());
            updateStudent.setCcpAssistant(synonymPersonnel.getCcpAssistant());
            updateStudent.setCcpTitle(synonymPersonnel.getCcpTitle());
            updateStudent.setCcpCode(synonymPersonnel.getCcpCode());
            updateStudent.setCcpUnit(synonymPersonnel.getCcpUnit());
            updateStudent.setCcpSection(synonymPersonnel.getCcpSection());
            updateStudent.setDepartmentCode(synonymPersonnel.getDepartmentCode());
            updateStudent.setDepartmentTitle(synonymPersonnel.getDepartmentTitle());
            updateStudent.setJobTitle(synonymPersonnel.getJobTitle());
            updateStudent.setComplexTitle(synonymPersonnel.getComplexTitle());
            updateStudent.setPostId(synonymPersonnel.getPostId());
            updateStudent.setDepartmentId(synonymPersonnel.getDepartmentId());
            updateStudent.setHasPreparationTest(student.isHasPreparationTest());
            updateStudent.setContactInfoId(student.getContactInfoId());
            updateStudent.setUserName(student.getUserName());
            updateStudent.setGeoWorkId(student.getGeoWorkId());
            updateStudent.setPeopleType(student.getPeopleType());
            updateStudent.setGender(student.getGender());
            updateStudent.setCompanyName(student.getCompanyName());
            studentService.update(student.getId(), updateStudent);
            response.setStatus(200);
        } else {
            response.setStatus(406);
            response.setMessage("کاربر با این کد ملی در سیستم منابع انسانی یافت نشد");
        }
        return response;

    }

    @Transactional
    @Override
    public String delete(Long id) {

        ClassStudent classSession = classStudentDAO.getClassStudentById(id);
        if (!classSession.getScoresStateId().equals(410L)) {
            return "فراگير «<b>" + classSession.getStudent().getFirstName() + " " + classSession.getStudent().getLastName() + "</b>» بدلیل ثبت نمره قابل حذف نیست.";
        } else if (attendanceDAO.checkAttendanceByStudentIdAndClassId(classSession.getStudentId(), classSession.getTclassId()) > 0) {
            return "فراگير «<b>" + classSession.getStudent().getFirstName() + " " + classSession.getStudent().getLastName() + "</b>» بدلیل داشتن حضور و غیاب قابل حذف نیست.";
        } else {
            classStudentDAO.deleteById(id);
            attendanceDAO.deleteAllByClassIdAndStudentId(classSession.getTclassId(), classSession.getStudentId());
            classStudentHistoryService.save(classSession);
            return "";
        }

    }

    @Transactional
    @Override
    public void delete(ClassStudentDTO.Delete request) {
        final List<ClassStudent> studentList = classStudentDAO.findAllById(request.getIds());
        for (ClassStudent classStudent : studentList) {
            delete(classStudent.getId());
        }
//        classStudentDAO.deleteAll(studentList);
//        classStudentHistoryService.saveList(studentList);
    }

    @Transactional
    @Override
    public int setStudentFormIssuance(Map<String, String> formIssuance) {
        Long classId = Long.parseLong(formIssuance.get("idClassStudent"));
        if (formIssuance.get("evaluationAudienceType") != null)
            classStudentDAO.setStudentFormIssuanceAudienceType(classId, Long.parseLong(formIssuance.get("evaluationAudienceType")));
        if (formIssuance.get("evaluationAudienceId") != null)
            classStudentDAO.setStudentFormIssuanceAudienceId(classId, Long.parseLong(formIssuance.get("evaluationAudienceId")));
        return classStudentDAO.setStudentFormIssuance(classId, Integer.parseInt(formIssuance.get("reaction")), Integer.parseInt(formIssuance.get("learning")), Integer.parseInt(formIssuance.get("behavior")), Integer.parseInt(formIssuance.get("results")));
    }

    @Transactional
    @Override
    public void setTotalStudentWithOutScore(Long classId) {
        classStudentDAO.setTotalStudentWithOutScore(classId);
    }

    @Transactional
    @Override
    public List<Long> getScoreState(Long classId) {
        return classStudentDAO.getScoreState(classId);
    }

    @Override
    public Map<String, Integer> getStatusSendMessageStudents(Long classId) {
        List<Object> list = classStudentDAO.getStatusSendMessageStudents(classId);

        Map<String, Integer> result = new HashMap<>();
        for (int i = 0; i < list.size(); i++) {
            Object[] arr = (Object[]) list.get(i);
            result.put(arr[0] == null ? null : arr[0].toString(), Integer.parseInt(arr[1].toString()));
        }

        return result;
    }

    @Override
    public List<ClassStudent> getClassStudents(long classId) {
        return classStudentDAO.findAllByTclassId(classId);
    }

    @Override
    public List<ClassStudent> getUnSendEvaluationClassStudents(long classId) {
        return classStudentDAO.getUnSendEvaluationClassStudents(classId);
    }

    public List<String> getClassStudentsNationalCode(long classId) {
        return classStudentDAO.findClassStudentsNationalCodeByTclassId(classId);
    }

    @Transactional
    public ClassStudent findByClassIdAndStudentId(Long classId, Long studentId) {
        return classStudentDAO.findByTclassIdAndStudentId(classId, studentId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

    }

    @Transactional
    public Long getClassIdByClassStudentId(Long classStudentId) {
        ClassStudent classSession = classStudentDAO.getClassStudentById(classStudentId);
        return classSession.getTclassId();
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> searchEvaluationAnalysistLearning(SearchDTO.SearchRq request, Long classId) {
        Tclass tClass = tclassService.getTClass(classId);
        SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> result = SearchUtil.search(classStudentDAO, request, classStudent -> mapper.map(classStudent,
                ClassStudentDTO.evaluationAnalysistLearning.class));
        for (ClassStudentDTO.evaluationAnalysistLearning t : result.getList()) {
            if (tClass.getScoringMethod() != null && tClass.getScoringMethod().equalsIgnoreCase("2")) {
                if (t.getScore() != null)
                    t.setScore(t.getScore() * 5);
            }
        }
        return result;
    }

    @Override
    @Transactional
    public BaseResponse updateScore(ElsExamScore elsExamScore) {
        BaseResponse response = new BaseResponse();
        setScoreLoop:
        for (ElsStudentScore examScore : elsExamScore.getStudentScores()) {
            TestQuestionDTO.fullInfo testQuestionDTO = testQuestionService.get(elsExamScore.getExamId());
            Long classStudentId = getStudentId(testQuestionDTO.getTclass().getId(), examScore.getNationalCode());
            ClassStudent classStudent = getClassStudent(classStudentId);
            if (checkScoreInRange(testQuestionDTO.getTclass().getScoringMethod(), examScore.getScore())) {
                switch (elsExamScore.getType()) {
                    case "test": {
                        if (classStudent.getTestScore() != null) {
                            response.setStatus(406);
                            response.setMessage("نمره ی تستی کاربر با کد ملی : " + examScore.getNationalCode() + "  یک بار برای این دانشجو ذخیره شده است");
                            break setScoreLoop;
                        } else {
                            classStudent.setTestScore(examScore.getScore());
                            saveOrUpdate(classStudent);
                            response.setStatus(200);
                        }
                        break;
                    }
                    case "descriptive": {
                        classStudent.setDescriptiveScore(examScore.getScore());
                        saveOrUpdate(classStudent);
                        response.setStatus(200);
                        break;
                    }
                    case "final": {
                        if (classStudent.getScore() != null) {
                            response.setStatus(406);
                            response.setMessage("نمره ی نهایی کاربر با کد ملی : " + examScore.getNationalCode() + "  یک بار برای این دانشجو ذخیره شده است");
                            break setScoreLoop;
                        } else {
                            classStudent.setScore(examScore.getScore());
                            classStudent.setScoresStateId(parameterValueService.getEntityId(getStateByScore(testQuestionDTO.getTclass().getAcceptancelimit(), examScore.getScore())).getId());
                            saveOrUpdate(classStudent);
                            response.setStatus(200);
                        }
                        break;
                    }
                    default:
                        response.setMessage("نوع نمره اشتباه فرستاده شده است");
                        response.setStatus(406);
                        break setScoreLoop;

                }
            } else {
                response.setStatus(406);
                response.setMessage("نمره ی وارد شده کاربر با کد ملی : " + examScore.getNationalCode() + "  با روش نمره دهی این آزمون مطابقت ندارد");
                break;
            }
        }
        if (response.getStatus() == 200)
            return response;
        else
            throw new TrainingException(TrainingException.ErrorType.registerNotAccepted, null, response.getMessage());


    }


    @Override
    @Transactional
    public BaseResponse updatePreTestScore(long id, @RequestBody List<ExamResult> examResult) {
        BaseResponse response = new BaseResponse();

        for (ExamResult examResult1 : examResult) {
            Long classStudentId = getStudentId(id, examResult1.getNationalCode());
            ClassStudent classStudent = getClassStudent(classStudentId);
            if (examResult1.getFinalResult() != null && !Objects.equals(examResult1.getFinalResult(), "-")) {
                classStudent.setPreTestScore(Float.valueOf(examResult1.getFinalResult()));
                saveOrUpdate(classStudent);
            }
        }
        response.setStatus(200);
        return response;
    }

    @Override
    @Transactional
    public BaseResponse updateTestScore(long id, List<ExamResult> examResult) {
        BaseResponse response = new BaseResponse();

        for (ExamResult examResult1 : examResult) {
            Long classStudentId = getStudentId(id, examResult1.getNationalCode());
            ClassStudent classStudent = getClassStudent(classStudentId);
            if (examResult1.getFinalResult() != null && !Objects.equals(examResult1.getFinalResult(), "-")) {
                classStudent.setScore(Float.valueOf(examResult1.getFinalResult()));

                if (examResult1.getClassScore() != null && !Objects.equals(examResult1.getClassScore(), "-"))
                    classStudent.setClassScore(Double.parseDouble(examResult1.getClassScore()));
                else
                    classStudent.setClassScore(null);

                if (examResult1.getPracticalScore() != null && !Objects.equals(examResult1.getPracticalScore(), "-"))
                    classStudent.setPracticalScore(Double.parseDouble(examResult1.getPracticalScore()));
                else
                    classStudent.setPracticalScore(null);

                classStudent.setScoresStateId(parameterValueService.getEntityId(getStateByScore(classStudent.getTclass().getAcceptancelimit(), Float.valueOf(examResult1.getFinalResult()))).getId());

                saveOrUpdate(classStudent);
            }
        }
        response.setStatus(200);
        return response;
    }


    @Override
    public ElsClassListDto getTeacherClasses(String nationalCode, Integer page, Integer size) {
        ElsClassListDto dto = new ElsClassListDto();
        List<Object> list = classStudentDAO.findAllClassByTeacher(nationalCode, page + 1, size);
        long count = classStudentDAO.findAllCountClassByTeacher(nationalCode).size();
        long totalPage = 0;
        if (count != 0 && size != 0) {
            totalPage = count / size;
        }

        List<ElsClassDto> result = new ArrayList<>();
        for (Object o : list) {

            ElsClassDto elsClassDto = new ElsClassDto();
            Object[] arr = (Object[]) o;
            Long classId = Long.parseLong(arr[1].toString());
            Tclass tclass = tclassService.getTClass(classId);
//
            elsClassDto.setClassId(classId);
            elsClassDto.setCode(arr[3] == null ? null : arr[3].toString());
            elsClassDto.setName(arr[5] == null ? null : arr[5].toString());
            elsClassDto.setDuration(arr[7] == null ? null : Integer.valueOf(arr[7].toString()));
            elsClassDto.setLocation(arr[8] == null ? null : arr[8].toString());
            elsClassDto.setCourseStatus(arr[9] == null ? null : getCourseStatus(Integer.parseInt(arr[9].toString())));
            elsClassDto.setClassType(arr[10] == null ? null : getClassType(Integer.parseInt(arr[10].toString())));
            //todo this property must be remove in els
            elsClassDto.setCourseType(null);
            elsClassDto.setCoursePrograms(getPrograms2(tclass));

            Date startDate = getEpochDate(arr[11].toString(), "08:00");
            Date endDate = getEpochDate(arr[12].toString(), "23:59");
            elsClassDto.setStartDate(startDate.getTime());
            elsClassDto.setFinishDate(endDate.getTime());
            elsClassDto.setInstructor(arr[13] == null ? null : arr[13].toString());
            elsClassDto.setEvaluationRate(evaluationAnalysisService.findTeacherGradeByClass(classId));
            result.add(elsClassDto);
        }


        PaginationDto paginationDto = new PaginationDto();
        paginationDto.setCurrent(page);
        paginationDto.setSize(size);
        if (totalPage != 0) {
            paginationDto.setTotal(totalPage + 1);
            paginationDto.setLast((int) (totalPage));
        } else {
            paginationDto.setTotal(0);
            paginationDto.setLast(0);
        }
        paginationDto.setTotalItems(count);
        dto.setPaginationDto(paginationDto);
        dto.setList(result);

        return dto;
    }

    @Override
    public ElsClassListDto getStudentClasses(String nationalCode, Integer page, Integer size) {
        ElsClassListDto dto = new ElsClassListDto();
        List<Object> list = classStudentDAO.findAllClassByStudent(nationalCode, page + 1, size);
        long count = classStudentDAO.findAllCountClassByStudent(nationalCode).size();
        long totalPage = 0;
        if (count != 0 && size != 0) {
            totalPage = count / size;
        }

        List<ElsClassDto> result = new ArrayList<>();
        for (Object o : list) {

            ElsClassDto elsClassDto = new ElsClassDto();
            Object[] arr = (Object[]) o;
            Long classId = Long.parseLong(arr[1].toString());
            Tclass tclass = tclassService.getTClass(classId);
//            elsClassDto.setCategoryId(tclass.getCourse().getCategoryId());
//            elsClassDto.setSubCategoryId(tclass.getCourse().getSubCategoryId());
//            elsClassDto.setCategoryName(tclass.getCourse().getCategory().getTitleFa());
//            elsClassDto.setSubCategoryName(tclass.getCourse().getSubCategory().getTitleFa());
            elsClassDto.setClassId(classId);
            elsClassDto.setCode(arr[3] == null ? null : arr[3].toString());
//            elsClassDto.setTitle(arr[4] == null ? null : arr[4].toString());
            elsClassDto.setName(arr[5] == null ? null : arr[5].toString());
//            elsClassDto.setCapacity(arr[6] == null ? null : Integer.valueOf(arr[6].toString()));
            elsClassDto.setDuration(arr[7] == null ? null : Integer.valueOf(arr[7].toString()));
            elsClassDto.setLocation(arr[8] == null ? null : arr[8].toString());
            elsClassDto.setCourseStatus(arr[9] == null ? null : getCourseStatus(Integer.parseInt(arr[9].toString())));
            elsClassDto.setClassType(arr[10] == null ? null : getClassType(Integer.parseInt(arr[10].toString())));
            //todo this property must be remove in els
            elsClassDto.setCourseType(null);
            elsClassDto.setCoursePrograms(getPrograms2(tclass));

            Date startDate = getEpochDate(arr[11].toString(), "08:00");
            Date endDate = getEpochDate(arr[12].toString(), "23:59");
            elsClassDto.setStartDate(startDate.getTime());
            elsClassDto.setFinishDate(endDate.getTime());
            elsClassDto.setInstructor(arr[13] == null ? null : arr[13].toString());
//            elsClassDto.setEvaluationId(arr[14] == null ? null : Long.valueOf(arr[14].toString()));
//            elsClassDto.setSupervisorName(arr[17] == null ? null : arr[17].toString());
//            elsClassDto.setPlannerName(arr[18] == null ? null : arr[18].toString());
//            EvalAverageResult evaluationAverageResultToInstructor = tclassService.getEvaluationAverageResultToTeacher(classId);
//            elsClassDto.setEvaluationRate(evaluationAverageResultToInstructor.getTotalAverage());
            //todo this method must be changed
            elsClassDto.setEvaluationRate(0.0);

            result.add(elsClassDto);
        }


        PaginationDto paginationDto = new PaginationDto();
        paginationDto.setCurrent(page);
        paginationDto.setSize(size);
        if (totalPage != 0) {
            paginationDto.setTotal(totalPage + 1);
            paginationDto.setLast((int) (totalPage));
        } else {
            paginationDto.setTotal(0);
            paginationDto.setLast(0);
        }
        paginationDto.setTotalItems(count);
        dto.setPaginationDto(paginationDto);
        dto.setList(result);

        return dto;
    }

    @Override
    @Transactional
    public void testAddStudent(String classCode) {
        Tclass clsss = tclassService.getClassByCode(classCode);

        List<ClassStudent> classStudentList = getClassStudents(clsss.getId());
        List<Student> studentList = studentService.getTestStudentList();
        for (Student student : studentList) {
            ClassStudent classStudent = new ClassStudent();
            classStudent.setTclass(clsss);
            classStudent.setTclassId(clsss.getId());
            classStudent.setStudent(student);
            classStudent.setStudentId(student.getId());
            classStudent.setApplicantCompanyName(student.getCompanyName());
            if (classStudentList.stream().noneMatch(q -> q.getStudentId().equals(student.getId())) && validateMelliCode(student.getNationalCode())) {
                classStudentDAO.save(classStudent);
            } else {
                System.out.println(student.getNationalCode() + "/unSave");
            }

        }

    }


    @Transactional
    public void setPeresenceTypeId(Long peresenceTypeId, Long id) {
        classStudentDAO.setPeresenceTypeId(peresenceTypeId, id);
    }

    @Transactional
    public void setTypeOfEnterToClassId(Long typeOfEnterToClassId, Long id) {
        classStudentDAO.setTypeOfEnterToClassId(typeOfEnterToClassId, id);
    }

    public List<Long> findEvaluationStudentInClass(Long studentId, Long classId) {
        return classStudentDAO.findEvaluationStudentInClass(studentId, classId);
    }

    @Override
    public Optional<ClassStudent> findById(Long classStudentId) {
        return classStudentDAO.findById(classStudentId);
    }

    @Override
    public List<String> getStudentBetWeenRangeTime(String startDate, String endDate, String personnelNos) {
        List<String> nationalCodes = new ArrayList<>();
        String[] pesonnels = personnelNos.split(",");
        for (String personnelCod : pesonnels) {

            Optional<Personnel> personnelOptional = personnelDAO.findFirstByPersonnelNo(personnelCod.trim());
            personnelOptional.ifPresent(personnel -> nationalCodes.add(personnel.getNationalCode()));
        }
        return classStudentDAO.getStudentBetWeenRangeTime(startDate, endDate, nationalCodes);
    }

    @Override
    public List<SessionConflictDto> getSessionConflictViaClassStudent(String nationalCode, List<ClassSessionDTO.ClassStudentSession> classStudentSessions) {
        List<SessionConflictDto> sessionConflict = new ArrayList<>();
        if (classStudentSessions != null && classStudentSessions.size() > 0) {
            for (int i = 0; i < classStudentSessions.size(); i++) {
                List<?> conflicts = classStudentDAO.getSessionsInterferencePerStudent(classStudentSessions.get(i).getSessionDate(), classStudentSessions.get(i).getStartHour(), classStudentSessions.get(i).getEndHour(), nationalCode);
                if (conflicts != null) {
                    for (int z = 0; z < conflicts.size(); z++) {
                        Object[] conflict = (Object[]) conflicts.get(z);
                        sessionConflict.add(new SessionConflictDto((conflict[0] != null ? Long.parseLong(conflict[0].toString()) : 0),
                                (conflict[1] != null ? (conflict[1].toString()) : ""),
                                (conflict[2] != null ? (conflict[2].toString()) : ""),
                                (conflict[3] != null ? (conflict[3].toString()) : ""),
                                (conflict[4] != null ? (conflict[4].toString()) : ""),
                                (conflict[5] != null ? (conflict[5].toString()) : ""),
                                (conflict[6] != null ? (conflict[6].toString()) : "")
                        ));
                    }
                }
            }

        }
        return sessionConflict;
    }


    public Long getStudentId(Long classId, String nationalCode) {
        List<Long> studentIds = classStudentDAO.getClassStudentIdByClassCodeAndNationalCode(classId, nationalCode);
        if (!studentIds.isEmpty())
            return studentIds.get(0);
        else return null;
    }

    public boolean checkScoreInRange(String scoringMethod, Float score) {
        if (scoringMethod.equals("3") || scoringMethod.equals("2")) {

            if (scoringMethod.equals("3")) {
                if (score != null) {
                    return (score <= 20F && score >= 0);
                }
            } else {
                if (score != null) {
                    return (score <= 100F && score >= 0);
                }
            }
            return true;
        } else
            return false;
    }

    private String getStateByScore(String acceptancelimit, Float score) {
        if (score >= Double.parseDouble(acceptancelimit)) {
            return "PassdByGrade";
        } else {
            return "TotalFailed";
        }

    }

    public boolean validateMelliCode(String melliCode) {

        String[] identicalDigits = {"0000000000", "1111111111", "2222222222", "3333333333", "4444444444", "5555555555", "6666666666", "7777777777", "8888888888", "9999999999"};

        if (melliCode.trim().isEmpty()) {
            return false; // National Code is empty
        } else if (melliCode.length() != 10) {
            return false; // National Code is less or more than 10 digits
        } else if (Arrays.asList(identicalDigits).contains(melliCode)) {
            return false; // Fake National Code
        } else {
            int sum = 0;

            for (int i = 0; i < 9; i++) {
                sum += Character.getNumericValue(melliCode.charAt(i)) * (10 - i);
            }

            int lastDigit;
            int divideRemaining = sum % 11;

            if (divideRemaining < 2) {
                lastDigit = divideRemaining;
            } else {
                lastDigit = 11 - (divideRemaining);
            }

            // Invalid MelliCode
            return Character.getNumericValue(melliCode.charAt(9)) == lastDigit;
        }
    }

    @Override
    public ElsClassListV2Dto getTeacherClassesV2(String nationalCode, Integer page, Integer size) {
        ElsClassListV2Dto dto = new ElsClassListV2Dto();
        List<Object> list = classStudentDAO.findAllClassByTeacher(nationalCode, page + 1, size);
        long count = classStudentDAO.findAllCountClassByTeacher(nationalCode).size();
        long totalPage = 0;
        if (count != 0 && size != 0) {
            totalPage = count / size;
        }

        List<ElsClassV2Dto> result = new ArrayList<>();
        for (Object o : list) {
            ElsClassV2Dto elsClassDto = new ElsClassV2Dto();
            Object[] arr = (Object[]) o;
            Long classId = Long.parseLong(arr[1].toString());
            Tclass tclass = tclassService.getTClass(classId);
            elsClassDto.setCategoryId(tclass.getCourse().getCategoryId());
            elsClassDto.setSubCategoryId(tclass.getCourse().getSubCategoryId());
            elsClassDto.setCategoryName(tclass.getCourse().getCategory().getTitleFa());
            elsClassDto.setSubCategoryName(tclass.getCourse().getSubCategory().getTitleFa());
            elsClassDto.setCode(arr[3] == null ? null : arr[3].toString());
            elsClassDto.setTitle(arr[4] == null ? null : arr[4].toString());
            result.add(elsClassDto);
        }


        PaginationDto paginationDto = new PaginationDto();
        paginationDto.setCurrent(page);
        paginationDto.setSize(size);
        if (totalPage != 0) {
            paginationDto.setTotal(totalPage + 1);
            paginationDto.setLast((int) (totalPage));
        } else {
            paginationDto.setTotal(0);
            paginationDto.setLast(0);
        }
        paginationDto.setTotalItems(count);
        dto.setPagination(paginationDto);
        dto.setData(result);

        return dto;
    }

    @Override
    public ElsClassListV2Dto getTeacherClassesV2WithFilter(String nationalCode, String search, Integer page, Integer size) {
        ElsClassListV2Dto dto = new ElsClassListV2Dto();
        List<Object> list = new ArrayList<>();
        long count = 0;
        if (search == null || search.equals("")) {
            list = classStudentDAO.findAllClassByTeacher(nationalCode, page + 1, size);
            count = classStudentDAO.findAllCountClassByTeacher(nationalCode).size();
        } else {
            list = classStudentDAO.findAllClassByTeacherFilter(nationalCode, search, page + 1, size);
            count = classStudentDAO.findAllCountClassByTeacherFilter(nationalCode, search).size();

        }
        long totalPage = 0;
        if (count != 0 && size != 0) {
            totalPage = count / size;
        }

        List<ElsClassV2Dto> result = new ArrayList<>();
        for (Object o : list) {
            ElsClassV2Dto elsClassDto = new ElsClassV2Dto();
            Object[] arr = (Object[]) o;
            Long classId = Long.parseLong(arr[1].toString());
            Tclass tclass = tclassService.getTClass(classId);
            elsClassDto.setCategoryId(tclass.getCourse().getCategoryId());
            elsClassDto.setSubCategoryId(tclass.getCourse().getSubCategoryId());
            elsClassDto.setCategoryName(tclass.getCourse().getCategory().getTitleFa());
            elsClassDto.setSubCategoryName(tclass.getCourse().getSubCategory().getTitleFa());
            elsClassDto.setNeedToClassification(tclass.getCourse().getSubCategory().getNeedToClassification());
            elsClassDto.setCode(arr[3] == null ? null : arr[3].toString());
            elsClassDto.setTitle(arr[4] == null ? null : arr[4].toString());
            result.add(elsClassDto);
        }


        PaginationDto paginationDto = new PaginationDto();
        paginationDto.setCurrent(page);
        paginationDto.setSize(size);
        if (totalPage != 0) {
            paginationDto.setTotal(totalPage + 1);
            paginationDto.setLast((int) (totalPage));
        } else {
            paginationDto.setTotal(0);
            paginationDto.setLast(0);
        }
        paginationDto.setTotalItems(count);
        dto.setPagination(paginationDto);
        dto.setData(result);

        return dto;
    }


    @Override
    public ElsClassListV2Dto getTeacherClassesV3WithFilter(String examType, String nationalCode, String search, Integer page, Integer size) {
        ElsClassListV2Dto dto = new ElsClassListV2Dto();
        List<Object> list = new ArrayList<>();
        long count = 0;
        if (search == null || search.equals("")) {
            if (examType.equals("preTest")) {
                list = classStudentDAO.findAllClassByTeacherForPre(nationalCode, page + 1, size);
                count = classStudentDAO.findAllCountClassByTeacherForPre(nationalCode).size();
            } else {
                list = classStudentDAO.findAllClassByTeacherForExam(nationalCode, page + 1, size);
                count = classStudentDAO.findAllCountClassByTeacherForExam(nationalCode).size();
            }

        } else {
            if (examType.equals("preTest")) {
                list = classStudentDAO.findAllClassByTeacherFilterForPre(nationalCode, search, page + 1, size);
                count = classStudentDAO.findAllCountClassByTeacherFilterForPre(nationalCode, search).size();
            } else {
                list = classStudentDAO.findAllClassByTeacherFilterForExam(nationalCode, search, page + 1, size);
                count = classStudentDAO.findAllCountClassByTeacherFilterForExam(nationalCode, search).size();
            }

        }
        long totalPage = 0;
        if (count != 0 && size != 0) {
            totalPage = count / size;
        }

        List<ElsClassV2Dto> result = new ArrayList<>();
        for (Object o : list) {
            ElsClassV2Dto elsClassDto = new ElsClassV2Dto();
            Object[] arr = (Object[]) o;
            Long classId = Long.parseLong(arr[1].toString());
            Tclass tclass = tclassService.getTClass(classId);
            elsClassDto.setClassId(classId);
            elsClassDto.setCategoryId(tclass.getCourse().getCategoryId());
            elsClassDto.setSubCategoryId(tclass.getCourse().getSubCategoryId());
            elsClassDto.setCategoryName(tclass.getCourse().getCategory().getTitleFa());
            elsClassDto.setSubCategoryName(tclass.getCourse().getSubCategory().getTitleFa());
            elsClassDto.setCode(arr[3] == null ? null : arr[3].toString());
            elsClassDto.setTitle(arr[4] == null ? null : arr[4].toString());
            elsClassDto.setCanEnterPractical(arr[19] == null ? null : getValueForEnterPractical(arr[19].toString()));
            result.add(elsClassDto);
        }


        PaginationDto paginationDto = new PaginationDto();
        paginationDto.setCurrent(page);
        paginationDto.setSize(size);
        if (totalPage != 0) {
            paginationDto.setTotal(totalPage + 1);
            paginationDto.setLast((int) (totalPage));
        } else {
            paginationDto.setTotal(0);
            paginationDto.setLast(0);
        }
        paginationDto.setTotalItems(count);
        dto.setPagination(paginationDto);
        dto.setData(result);

        return dto;
    }

    private Boolean getValueForEnterPractical(String theoType) {
        if (theoType == null)
            return true;
        else {
            return !theoType.equals("1");
        }

    }

    @Override
    public ElsClassListV2Dto getStudentClassesV2(String nationalCode, Integer page, Integer size) {
        ElsClassListV2Dto dto = new ElsClassListV2Dto();
        List<Object> list = classStudentDAO.findAllClassByStudent(nationalCode, page + 1, size);
        long count = classStudentDAO.findAllCountClassByStudent(nationalCode).size();
        long totalPage = 0;
        if (count != 0 && size != 0) {
            totalPage = count / size;
        }
        List<ElsClassV2Dto> result = new ArrayList<>();
        for (Object o : list) {
            ElsClassV2Dto elsClassDto = new ElsClassV2Dto();
            Object[] arr = (Object[]) o;
            Long classId = Long.parseLong(arr[1].toString());
            Tclass tclass = tclassService.getTClass(classId);
            elsClassDto.setCategoryId(tclass.getCourse().getCategoryId());
            elsClassDto.setSubCategoryId(tclass.getCourse().getSubCategoryId());
            elsClassDto.setCategoryName(tclass.getCourse().getCategory().getTitleFa());
            elsClassDto.setSubCategoryName(tclass.getCourse().getSubCategory().getTitleFa());
            elsClassDto.setCode(arr[3] == null ? null : arr[3].toString());
            elsClassDto.setTitle(arr[4] == null ? null : arr[4].toString());
            result.add(elsClassDto);
        }
        PaginationDto paginationDto = new PaginationDto();
        paginationDto.setCurrent(page);
        paginationDto.setSize(size);
        if (totalPage != 0) {
            paginationDto.setTotal(totalPage + 1);
            paginationDto.setLast((int) (totalPage));
        } else {
            paginationDto.setTotal(0);
            paginationDto.setLast(0);
        }
        paginationDto.setTotalItems(count);
        dto.setPagination(paginationDto);
        dto.setData(result);

        return dto;
    }

    @Override
    public ElsClassListV2Dto getStudentClassesV2WithFilter(String nationalCode, String search, Integer page, Integer size) {
        ElsClassListV2Dto dto = new ElsClassListV2Dto();
        List<Object> list = new ArrayList<>();
        long count = 0;
        if (search == null || search == "") {
            list = classStudentDAO.findAllClassByStudent(nationalCode, page + 1, size);
            count = classStudentDAO.findAllCountClassByStudent(nationalCode).size();
        } else {
            list = classStudentDAO.findAllClassByStudentFilter(nationalCode, search, page + 1, size);
            count = classStudentDAO.findAllCountClassByStudentFilter(nationalCode, search).size();
        }
        long totalPage = 0;
        if (count != 0 && size != 0) {
            totalPage = count / size;
        }
        List<ElsClassV2Dto> result = new ArrayList<>();
        for (Object o : list) {
            ElsClassV2Dto elsClassDto = new ElsClassV2Dto();
            Object[] arr = (Object[]) o;
            Long classId = Long.parseLong(arr[1].toString());
            Tclass tclass = tclassService.getTClass(classId);
            elsClassDto.setCategoryId(tclass.getCourse().getCategoryId());
            elsClassDto.setSubCategoryId(tclass.getCourse().getSubCategoryId());
            elsClassDto.setCategoryName(tclass.getCourse().getCategory().getTitleFa());
            elsClassDto.setSubCategoryName(tclass.getCourse().getSubCategory().getTitleFa());
            elsClassDto.setCode(arr[3] == null ? null : arr[3].toString());
            elsClassDto.setTitle(arr[4] == null ? null : arr[4].toString());
            result.add(elsClassDto);
        }
        PaginationDto paginationDto = new PaginationDto();
        paginationDto.setCurrent(page);
        paginationDto.setSize(size);
        if (totalPage != 0) {
            paginationDto.setTotal(totalPage + 1);
            paginationDto.setLast((int) (totalPage));
        } else {
            paginationDto.setTotal(0);
            paginationDto.setLast(0);
        }
        paginationDto.setTotalItems(count);
        dto.setPagination(paginationDto);
        dto.setData(result);

        return dto;
    }

    @Transactional(readOnly = true)
    @Override
    public String isScoreEditable(Long classStudentId) {
        ClassStudent classStudent = getClassStudent(classStudentId);
        Tclass tclass = classStudent.getTclass();
        Boolean isSpecialCourse = tclass.getCourse().getIsSpecial();
        String endDate = tclass.getEndDate();
        Long classTeachingMethodId = tclass.getTeachingMethodId();
        String scoringMethod = tclass.getScoringMethod();
        Long scoresStateId = classStudent.getScoresStateId();
        Long failureReasonId = classStudent.getFailureReasonId();
        Integer evaluationStatusReaction = classStudent.getEvaluationStatusReaction();
        String teachingMethodCode = parameterValueService.get(classTeachingMethodId).getCode();
        String studentPresenceType = parameterValueService.get(classStudent.getPresenceTypeId()).getCode();

        boolean isAcceptByCertification = coursesDetailService.getByNationalCodeAndClassId(tclass.getId(), classStudent.getStudent().getNationalCode()); // آیا توسط جاب یا به صورت دستی طی فرایند تایید صلاحیت تایید شده است؟
        boolean isNonAttendanceClass = teachingMethodCode.equals("intraOrganizationalRemotelyClass"); // کلاس غیر حضوری
        boolean isSelfTaughtStudent = studentPresenceType.equals("kh"); // فراگیر خود آموخته
        boolean isScoreDependent = (boolean) tclassService.getScoreDependency().get("isScoreDependent"); // ثبت نمره وابسته به ارزیابی است؟
        boolean checkClassBasisDate = checkClassBasisDate(endDate, parameterService.getByCode("ClassConfig")); // تاریخ مبنای کلاس
        boolean isEvaluationStatusReactionNotComplete = evaluationStatusReaction == null || evaluationStatusReaction == 0 || evaluationStatusReaction == 1; // وضعیت تکمیل ارزیابی واکنشی

        List<Long> failureReasonIds = getFailureReasonIds();
        String scoreStateAndFailureReason = getScoreStateAndFailureReason(scoringMethod, scoresStateId, failureReasonId, failureReasonIds);
        if (!isAcceptByCertification) {
            if (isSpecialCourse != null && !isSpecialCourse) {
                if (!isNonAttendanceClass && !isSelfTaughtStudent) {
                    if (checkClassBasisDate && isScoreDependent && isEvaluationStatusReactionNotComplete)
                        return "ثبت نمره وابسته به ارزیابی است ولی ارزیابی تکمیل نشده است";
                }
            }
            return scoreStateAndFailureReason;
        } else
            return "نمره ی این دانشجو طی فرایند تایید صلاحیت مورد استناد قرار گرفته است و قابل تغییر نمی باشد";

    }

    @Override
    @Transactional(readOnly = true)
    public Boolean isAcceptByCertification(Long classStudentId) {
        ClassStudent classStudent = getClassStudent(classStudentId);
        Tclass tclass = classStudent.getTclass();
        return coursesDetailService.getByNationalCodeAndClassId(tclass.getId(), classStudent.getStudent().getNationalCode());
    }

    @Override
    public Boolean checkStudentIsInCourse(String requesterNationalCode, String objectCode) {
        return !classStudentDAO.checkStudentIsInCourse(requesterNationalCode, objectCode).isEmpty();
    }

    @Override
    public Boolean checkStudentIsInClass(String requesterNationalCode, String objectCode) {
        return !classStudentDAO.checkStudentIsInClass(requesterNationalCode, objectCode).isEmpty();
    }

    @Override
    public BaseResponse sendEvaluationForPresentStudent(Long classId) {
        BaseResponse response = new BaseResponse();
        try {
            List<ClassStudent> classStudentList = getClassStudents(classId);
            Tclass tclass = tclassService.getTClass(classId);
            if (!classStudentList.isEmpty()) {
                classStudentList.forEach(classStudent -> {
                    if ((Optional.ofNullable(classStudent.getEvaluationStatusReaction()).orElse(0) == 1 ) && (classStudent.getElsStatus() == null || !classStudent.getElsStatus())) {
                        classStudent.setElsStatus(true);
                        Map<String, String> paramValMap = new HashMap<>();

                        paramValMap.put("user_name", getPrefix(classStudent.getStudent().getGender()) + classStudent.getStudent().getLastName());
                        paramValMap.put("evaluation_title", tclass.getTitleClass());
                        paramValMap.put("url", elsSmsUrl);
                        sendMessageService.syncEnqueue("1ax63fg1dr", paramValMap, Collections.singletonList(getLiveCellNumber(classStudent.getStudent().getContactInfo())), null, classId, classStudent.getStudentId());
                        classStudentDAO.save(classStudent);
                    }

                });
            }
        } catch (Exception e) {
            System.out.println("els exception : " + e.getCause().toString());
        }
        response.setStatus(200);
        return response;
    }

    public static String getPrefix(String gender) {
        if (gender == null)
            return "جناب آقای/سرکار خانم ";
        else {
            switch (gender) {
                case "مرد":
                case "Male":
                case "آقا": {
                    return "جناب آقای ";

                }
                case "زن":
                case "Female":
                case "خانم": {
                    return "سرکار خانم ";
                }
                default:
                    return "جناب آقای/سرکار خانم ";
            }
        }

    }

    @Override
    public boolean IsStudentAttendanceAllowable(Long classStudentId) {
        try {
            ClassStudent classStudentById = getClassStudent(classStudentId);
            List<ClassSession> sessions = classSessionDAO.findByClassId(classStudentById.getTclassId());
            List<Attendance> attendances = attendanceDAO.findBySessionInAndStudentId(sessions, classStudentById.getStudentId());
            ParameterValueDTO.Info AllowedAbsencePercentage = iParameterValueService.getInfoByCode("evaluationAbsencePercentage");
            List<Attendance> unjustifiedAbsence = attendances.stream().filter(a -> a.getState().equals("3")).collect(Collectors.toList());

            if (!sessions.isEmpty()) {
                int AbsencesCountPercentage = (100 * unjustifiedAbsence.size()) / sessions.size();
                int allowedValue = Integer.parseInt(AllowedAbsencePercentage.getValue());

                if (AbsencesCountPercentage >= allowedValue)
                    return false;
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return true;
    }

    private String getScoreStateAndFailureReason(String scoringMethod, Long scoresStateId, Long failureReasonId, List<Long> failureReasonIds) {
        if (failureReasonId != null) {
            if (scoringMethod.equals("1") || scoringMethod.equals("4")) {
                return "روش نمره دهی بصورت (ارزشی) یا (بدون نمره) می باشد";
            }
            if (scoresStateId == 403) { // مردود
                if (failureReasonId == 407L) {
                    return "وضعیت نمره (مردود) و علت مردودی (غیبت در جلسه امتحان) می باشد";
                }
                if (failureReasonId == 453L) {
                    return "وضعیت نمره (مردود) و علت مردودی (انصراف فراگیر) می باشد";
                }
                if (failureReasonIds.contains(failureReasonId))
                    return """
                            علت مردودی فراگیر، یکی از موارد زیر است:
                            قبول بدون نمره
                            حذف کلاس
                            حذف به دلیل غیبت مجاز
                            حذف به دلیل غیبت غیرمجاز
                            حذف به دلیل درخواست امور
                            انصراف فراگیر
                            """;
            }
            return null;
        } else return null;
    }

    private List<Long> getFailureReasonIds() {
        List<Long> failureReasonIds = new ArrayList<>();

        failureReasonIds.add(401L); // قبول بدون نمره
        failureReasonIds.add(404L); // حذف کلاس
        failureReasonIds.add(405L); // حذف دانشجو از کلاس به دلیل غیبت غیرمجاز
        failureReasonIds.add(406L); // حذف دانشجو به دلیل درخواست امور
        failureReasonIds.add(448L); // انصراف فراگیر
        failureReasonIds.add(449L); // حذف دانشجو از کلاس به دلیل غیبت مجاز

        return failureReasonIds;
    }

    String getLiveCellNumber(ContactInfo contactInfo) {
        if (contactInfo == null)
            return "";
        if (contactInfo.getEMobileForSMS() == null)
            return contactInfo.getMobile();
        return switch (contactInfo.getEMobileForSMS()) {
            case hrMobile -> contactInfo.getHrMobile();
            case mdmsMobile -> contactInfo.getMdmsMobile();
            case trainingSecondMobile -> contactInfo.getMobile2();
            default -> contactInfo.getMobile();
        };

    }



    @Override
    public Boolean checkClassForFinalTest(Long classId) {
        List<ClassStudent> classStudentList= classStudentDAO.findAllByTclassId(classId);
        AtomicReference<Boolean> isFinalTestAvailable= new AtomicReference<>(true);
        if (classStudentList.isEmpty())
        return false;
        for (ClassStudent classStudent : classStudentList) {
            if ((classStudent.getEvaluationStatusReaction() == null || classStudent.getEvaluationStatusReaction() == 0) && IsStudentAttendanceAllowable(classStudent.getId())) {
                isFinalTestAvailable.set(false);
                break;
            }
        }
        return isFinalTestAvailable.get();
    }

    @Override
    public List<GenericReport> getTypeOfEnterToClassReport(String fromDate, String toDate, List<Object> complex, int complexNull, List<Object> assistant, int assistantNull, List<Object> affairs, int affairsNull) {
        List<?> result;
        result =classStudentDAO.typeOfEnterToClassReport(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);

        List<GenericReport> data = null;

        if (result != null) {
            data = new ArrayList<>(result.size());

            for (int i = 0; i < result.size(); i++) {
                Object[] report = (Object[]) result.get(i);
                data.add(new GenericReport(
                        report[0]  != null ? Long.parseLong(report[0].toString())  : null,
                        report[1]  != null ? report[1].toString()  : null,
                        report[2]  != null ? report[2].toString()  : null,
                        report[3]  != null ? report[3].toString() : null,
                        report[4]  != null ? report[4].toString()  : null,
                        report[5]  != null ? report[5].toString() : null,
                        report[6]  != null ? report[6].toString() : null,
                        report[7]  != null ? report[7].toString()  : null,
                        report[8]  != null ? report[8].toString() : null,
                        report[9]  != null ? report[9].toString() : null,
                        report[10]  != null ? report[10].toString() : null
                ));
            }
        }

        return data;
     }

    @Override
    public List<GenericReport> getFinancialExpensesOfTheOrganizationReport(String fromDate, String toDate, List<Object> complex, int complexNull, List<Object> assistant, int assistantNull, List<Object> affairs, int affairsNull) {
        List<?> result;
        result =classStudentDAO.financialExpensesOfTheOrganizationReport(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);

        List<GenericReport> data = null;

        if (result != null) {
            data = new ArrayList<>(result.size());

            for (int i = 0; i < result.size(); i++) {
                Object[] report = (Object[]) result.get(i);
                data.add(new GenericReport(
                        report[0]  != null ? Long.parseLong(report[0].toString())  : null,null,
                        report[1]  != null ? report[1].toString()  : null,
                        report[2]  != null ? report[2].toString()  : null,
                        report[3]  != null ? report[3].toString() : null,
                        report[4]  != null ? report[4].toString()  : null,
                        report[5]  != null ? report[5].toString() : null,
                        report[6]  != null ? report[6].toString() : null,
                        report[7]  != null ? report[7].toString()  : null,
                        report[8]  != null ? report[8].toString() : null,
                        report[9]  != null ? report[9].toString() : null
                ));
            }
        }

        return data;
    }
    @Override
    public List<GenericReport> getNumberOfSpecializedCoursesReport(String fromDate, String toDate, List<Object> complex, int complexNull, List<Object> assistant, int assistantNull, List<Object> affairs, int affairsNull) {
        List<?> result;
        result =classStudentDAO.numberOfSpecializedCoursesReport(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);

        List<GenericReport> data = null;

        if (result != null) {
            data = new ArrayList<>(result.size());

            for (int i = 0; i < result.size(); i++) {
                Object[] report = (Object[]) result.get(i);
                data.add(new GenericReport(
                        report[0]  != null ? Long.parseLong(report[0].toString())  : null,
                        report[1]  != null ? report[1].toString()  : null,
                        report[2]  != null ? report[2].toString()  : null,
                        report[3]  != null ? report[3].toString() : null,
                        report[4]  != null ? report[4].toString()  : null,
                        report[5]  != null ? report[5].toString() : null,
                        report[6]  != null ? report[6].toString() : null,
                        report[7]  != null ? report[7].toString()  : null,
                        report[8]  != null ? report[8].toString() : null,
                        report[9]  != null ? report[9].toString() : null,
                        report[10]  != null ? report[10].toString() : null
                ));
            }
        }

        return data;
    }

    @Override
    public List<GenericReport> getAttendancePersonReport(String fromDate, String toDate, List<Object> complex, int complexNull, List<Object> assistant, int assistantNull, List<Object> affairs, int affairsNull) {
        List<?> result;
        result =classStudentDAO.getAttendancePersonReport(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);

        List<GenericReport> data = null;

        if (result != null) {
            data = new ArrayList<>(result.size());

            for (int i = 0; i < result.size(); i++) {
                Object[] report = (Object[]) result.get(i);
                data.add(new GenericReport(
                        report[0]  != null ? Long.parseLong(report[0].toString())  : null,null,
                        report[1]  != null ? report[1].toString()  : null,
                        report[2]  != null ? report[2].toString()  : null,
                        report[3]  != null ? report[3].toString() : null,
                        report[4]  != null ? report[4].toString()  : null,
                        report[5]  != null ? report[5].toString() : null,
                        report[6]  != null ? report[6].toString() : null,
                        report[7]  != null ? report[7].toString()  : null,
                        report[8]  != null ? report[8].toString() : null,
                        report[9]  != null ? report[9].toString() : null
                ));
            }
        }

        return data;
    }

    @Scheduled(cron = "0 30 19 1/1 * ?")
    public void updateStudentData() {
        try {
            List<Long> studentListIds = classStudentDAO.UnCompleteStudentIds();
            studentListIds.forEach(id->{
                try {
                Optional<Student> optionalStudent =   studentService.getOptional(id);
                if (optionalStudent.isPresent()){
                    Student student = optionalStudent.get();
                    SynonymPersonnel synonymPersonnel= synonymPersonnelService.getByNationalCode(student.getNationalCode());
                    if (synonymPersonnel!=null && (synonymPersonnel.getDepartmentCode()!=null || synonymPersonnel.getPostCode()!=null )){
                        student.setId(student.getId());
                        student.setDepartmentCode(synonymPersonnel.getDepartmentCode());
                        student.setPostCode(synonymPersonnel.getPostCode());
                        student.setPostTitle(synonymPersonnel.getPostTitle());
                        student.setPersonnelNo(synonymPersonnel.getPersonnelNo());
                        student.setPersonnelNo2(synonymPersonnel.getPersonnelNo2());
                        student.setCompanyName(synonymPersonnel.getCompanyName());
                        student.setPostGradeCode(synonymPersonnel.getPostGradeCode());
                        student.setPostGradeTitle(synonymPersonnel.getPostGradeTitle());
                        student.setCcpAffairs(synonymPersonnel.getCcpAffairs());
                        student.setCcpArea(synonymPersonnel.getCcpArea());
                        student.setCcpAssistant(synonymPersonnel.getCcpAssistant());
                        student.setCcpTitle(synonymPersonnel.getCcpTitle());
                        student.setCcpCode(synonymPersonnel.getCcpCode());
                        student.setCcpUnit(synonymPersonnel.getCcpUnit());
                        student.setCcpSection(synonymPersonnel.getCcpSection());
                        student.setDepartmentTitle(synonymPersonnel.getDepartmentTitle());
                        student.setJobTitle(synonymPersonnel.getJobTitle());
                        student.setComplexTitle(synonymPersonnel.getComplexTitle());
                        student.setPostId(synonymPersonnel.getPostId());
                        student.setDepartmentId(synonymPersonnel.getDepartmentId());
                        try {
                            studentService.save(student);
                        }catch (Exception e){
                            System.out.println(e.toString());
                        }
                    }
                }

                } catch (Exception e){
                    System.out.println(e.toString());
                } });

        }catch (Exception e){
            System.out.println(e.toString());
        }
    }

}
