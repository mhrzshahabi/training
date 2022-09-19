package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Personnel;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.AttendanceDAO;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.PersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import request.exam.ElsExamScore;
import request.exam.ElsStudentScore;
import request.exam.ExamResult;
import response.BaseResponse;
import response.PaginationDto;
import response.evaluation.dto.EvalAverageResult;
import response.tclass.dto.ElsClassDto;
import response.tclass.dto.ElsClassListDto;
import response.tclass.dto.ElsClassListV2Dto;
import response.tclass.dto.ElsClassV2Dto;

import java.util.*;
import java.util.function.Function;

import static com.nicico.training.utility.persianDate.MyUtils.*;
import static com.nicico.training.utility.persianDate.PersianDate.getEpochDate;

@Service
@RequiredArgsConstructor
public class ClassStudentService implements IClassStudentService {

    private final ClassStudentDAO classStudentDAO;
    private final AttendanceDAO attendanceDAO;
    private final ClassStudentHistoryService classStudentHistoryService;
    private final ITclassService tclassService;
    private final StudentService studentService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final ModelMapper mapper;
    private final IEvaluationAnalysisService evaluationAnalysisService;
    private final PersonnelService personnelService;
    private final ITeacherService iTeacherService;
    private final ITestQuestionService testQuestionService;
    private final ParameterValueService parameterValueService;
    private final PersonnelDAO personnelDAO;

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

                if (examResult1.getClassScore()!=null && !Objects.equals(examResult1.getClassScore(), "-"))
                classStudent.setClassScore(Double.parseDouble(examResult1.getClassScore()));
                else
                    classStudent.setClassScore(null);

                if (examResult1.getPracticalScore()!=null && !Objects.equals(examResult1.getPracticalScore(), "-"))
                    classStudent.setPracticalScore(Double.parseDouble(examResult1.getPracticalScore()));
                else
                    classStudent.setPracticalScore(null);

                classStudent.setScoresStateId(parameterValueService.getEntityId(getStateByScore(classStudent.getTclass().getAcceptancelimit(), Float.valueOf(examResult1.getFinalResult()))).getId());

                saveOrUpdate(classStudent);
            }
        }
        response.setStatus(200);
        return response;    }


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
            EvalAverageResult evaluationAverageResultToInstructor = tclassService.getEvaluationAverageResultToTeacher(classId);
            elsClassDto.setEvaluationRate(evaluationAverageResultToInstructor.getTotalAverage());

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

    public List<Long> findEvaluationStudentInClass(Long studentId, Long classId) {
        return classStudentDAO.findEvaluationStudentInClass(studentId, classId);
    }

    @Override
    public Optional<ClassStudent> findById(Long classStudentId) {
        return classStudentDAO.findById(classStudentId);
    }

    @Override
    public List<String> getStudentBetWeenRangeTime(String startDate, String endDate,String personnelNos) {
        List<String>nationalCodes=new ArrayList<>();
        String[] pesonnels = personnelNos.split(",");
        for (String personnelCod:pesonnels){

            Optional<Personnel> personnelOptional =   personnelDAO.findFirstByPersonnelNo(personnelCod.trim());
            personnelOptional.ifPresent(personnel -> nationalCodes.add(personnel.getNationalCode()));
        }
        return classStudentDAO.getStudentBetWeenRangeTime(startDate,endDate,nationalCodes);
    }

    @Override
    public Boolean getSessionConflictViaClassStudent(String nationalCode, List<ClassSessionDTO.ClassStudentSession> classStudentSessions) {
        final boolean[] flag = {false};
        if(classStudentSessions!=null && classStudentSessions.size()>0){
            for (int i = 0; i < classStudentSessions.size() && !flag[0]; i++) {

                List<Long> conflicts = classStudentDAO.getSessionsInterferencePerStudent(classStudentSessions.get(i).getSessionDate(), classStudentSessions.get(i).getStartHour(), classStudentSessions.get(i).getEndHour(),nationalCode);
                if (conflicts.size() > 0) {
                    flag[0] = true;

                }
            }

        }
        return flag[0];
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
        List<Object> list=new ArrayList<>();
        long count=0;
        if(search==null || search.equals("")) {
            list = classStudentDAO.findAllClassByTeacher(nationalCode, page + 1, size);
            count = classStudentDAO.findAllCountClassByTeacher(nationalCode).size();
        }else{
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
    public ElsClassListV2Dto getStudentClassesV2WithFilter(String nationalCode,String search, Integer page, Integer size) {
        ElsClassListV2Dto dto = new ElsClassListV2Dto();
        List<Object> list=new ArrayList<>();
        long count=0;
        if(search==null || search==""){
             list = classStudentDAO.findAllClassByStudent(nationalCode, page + 1, size);
             count = classStudentDAO.findAllCountClassByStudent(nationalCode).size();
        }else {
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
}
