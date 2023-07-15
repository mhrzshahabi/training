package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.dto.enums.ClassStatusDTO;
import com.nicico.training.dto.enums.ClassTypeDTO;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.model.TClassAudit;
import com.nicico.training.model.Tclass;
import dto.QRCodeDataDto;
import dto.ScoringClassDto;
import net.sf.jasperreports.engine.JRException;
import org.springframework.transaction.annotation.Transactional;
import request.evaluation.StudentEvaluationAnswerDto;
import request.evaluation.TeacherEvaluationAnswerDto;
import response.BaseResponse;
import response.evaluation.dto.EvalAverageResult;
import response.evaluation.dto.EvaluationAnswerObject;
import response.tclass.ElsClassDetailResponse;
import response.tclass.ElsSessionResponse;
import response.tclass.dto.ElsSessionDetailsResponse;
import response.tclass.dto.TclassDto;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface ITclassService {

    List<Tclass> getTeacherClasses(Long teacherId);

    TclassDTO.Info get(Long id);

    Tclass getTClass(Long id);

    List<String> getPreCourseTestQuestions(Long tclassId);

    void updatePreCourseTestQuestions(Long classId, List<String> preCourseTestQuestions);

    @Transactional(readOnly = true)
    Tclass getEntity(Long id);

    List<TclassDTO.Info> list();

    TclassDTO.Info create(TclassDTO.Create request);

//    TclassDTO.Info update(Long id, TclassDTO.Update request);

//    void delete(Long id);

    @Transactional(readOnly = true)
    List<ClassStudentDTO.AttendanceInfo> getStudents(Long classID);

//    void delete(TclassDTO.Delete request);

    SearchDTO.SearchRs<TclassDTO.Info> search(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException;

    @Transactional(readOnly = true)
    <T> SearchDTO.SearchRs<T> search1(SearchDTO.SearchRq request, Class<T> infoType);

    SearchDTO.SearchRs<TclassDTO.EvaluatedInfoGrid> evaluatedSearch(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<TclassDTO.Info> searchById(SearchDTO.SearchRq request, Long classId);

//    List<StudentDTO.Info> getStudents(Long classID);
//
//    List<StudentDTO.Info> getOtherStudents(Long classID);

//    void addStudents(StudentDTO.Delete request, Long classId);

    @Transactional(readOnly = true)
    Long sessionsHourSum(Long classId);

    @Transactional
    Long getEndGroup(Long courseId, Long termId);

    @Transactional(readOnly = true)
    int updateClassState(Long classId, String workflowEndingStatus, Integer workflowEndingStatusCode);

    Integer getWorkflowEndingStatusCode(Long classId);

    public TclassDTO.ReactionEvaluationResult getReactionEvaluationResult(Long classId);

    @Transactional
    Double getJustFERGrade(Long classId);

    @Transactional
    public Map<String, Object> getFERAndFETGradeResult(Long classId);

    public List<TclassDTO.PersonnelClassInfo> findAllPersonnelClass(String national_code, String personnel_no);

    public List<TclassDTO.PersonnelClassInfo> findPersonnelClassByCourseId(String national_code, String personnel_no, Long courseId);

    @Transactional(readOnly = true)
    SearchDTO.SearchRs<TclassDTO.TeachingHistory> searchByTeachingHistory(SearchDTO.SearchRq request, Long teacherId);
    @Transactional(readOnly = true)
    SearchDTO.SearchRs<TclassDTO.Info> searchByEducationalCalenderId(SearchDTO.SearchRq request,Long educationalCalenderId);

    @Transactional(readOnly = true)
    SearchDTO.SearchRs<TclassDTO.TeachingHistory> searchByTeacherId(SearchDTO.SearchRq request, Long tId);

    @Transactional(readOnly = true)
    Double getClassReactionEvaluationGrade(Long classId, Long tId);

    Map<String, Double> getClassReactionEvaluationFormula(Long classId);

    @Transactional(readOnly = true)
    List<TclassDTO.Info> PersonnelClass(Long id);


    @Transactional(readOnly = true)
    SearchDTO.SearchRs<TclassDTO.TClassReport> reportSearch(SearchDTO.SearchRq request);

    @Transactional(readOnly = true)
    SearchDTO.SearchRs<TclassDTO.InfoTuple> searchInfoTuple(SearchDTO.SearchRq request);

    @Transactional
    void updateCostInfo(Long id, TclassDTO.Update request);

    @Transactional
    Map<String, Object> calculateEffectivenessEvaluation(String reactionGrade_s, String learningGrade_s, String behavioralGrade_s, String classEvaluation);

    @Transactional
    Map<Long, Integer> checkClassesForSendMessage(List<Long> classIds);

    @Transactional
    void changeOnlineEvalTeacherStatus(Long classId, boolean state);

    @Transactional
    void changeOnlineEvalStudentStatus(Long classId, boolean state);

    @Transactional
    void changeOnlineExecutionEvalStudentStatus(Long classId, boolean state);

    @Transactional
    BaseResponse changeClassStatus(Long classId, String statem, String reason);


    EvaluationAnswerObject classTeacherEvaluations(TeacherEvaluationAnswerDto dto);

    EvaluationAnswerObject classStudentEvaluations(StudentEvaluationAnswerDto dto);

    Boolean hasAccessToChangeClassStatus(String groupIds);

    Map<String, Boolean> hasAccessToGroups(String groupIds);

    String getClassDefaultYear();

    Long getClassDefaultTerm(String year);

    List<String> getClassDefaultTermScope();

    boolean isValidForExam(long id);

    BaseResponse changeClassStatusToInProcess(Long classId);

    void changeClassToOnlineStatus(Long classId, boolean state);

    Tclass getClassByCode(String classCode);

    String getCourseCodeByClassByCode(String classCode);

    ElsSessionResponse getClassSessionsByCode(String classCode);

    List<TClassAudit> getAuditData(long classId);

    TclassDTO.TClassScoreEval getTClassDataForScoresInEval(String classCode);

    EvalAverageResult getEvaluationAverageResultToTeacher(Long classId);

    Map<String, Object> getScoreDependency();

    List<TclassDTO.TClassCurrentTerm> getAllTeacherByCurrentTerm(Long termId) throws NoSuchFieldException, IllegalAccessException;

    List<Tclass> getClassesViaTypeAndStatus(ClassStatusDTO status, ClassTypeDTO type);

    ClassBaseResponse getClassViaTypeAndStatusAndTermInfo(ClassStatusDTO status, ClassTypeDTO type, String year, String term, int page, int size);

    ElsClassDetailResponse getClassDetail(String classCode);

    boolean getTeacherForceToHasPhone();

    boolean getStudentForceToHasPhone();

    ParameterValue getTargetSocietyTypeById(Long id);

    List<TargetSocietyDTO.Info> getTargetSocietiesListById(Long id);

    TclassDto safeCreate(TclassDTO.Create request, HttpServletResponse response);

    TclassDto update(Long id, TclassDTO.Update request, List<Long> cancelClassesIds);

    BaseResponse delete(Long id) throws IOException;

    List<StudentDTO.ReactionNotFilled> checkEvaluationsNotFilledForEndingClass(Long classId);

    BaseResponse changeNotFilledStudentsStatus(Long classId, List<Long> studentIds);

    Boolean checkEvaluationsEndDateForEndingClass(Long classId);

    boolean compareTodayDate(Long classId);

    Boolean hasSessions(Long classId);

    void delete(TclassDTO.Delete request, HttpServletResponse resp) throws IOException;

    void updateTrainingReactionStatus(Integer trainingReactionStatus, Long classId);

    Integer getTeacherReactionStatus(Long classId);

    Integer getTrainingReactionStatus(Long classId);

    void updateReleaseDate(List<Long> classIds, String date);

    Map<String, Object> getEvaluationStatisticalReport(Long classId);

    TclassDTO.TClassForAgreement getTClassDataForAgreement(Long classId);

    void addEducationalCalender(Long eCalenderId, List<Long> classIds);

    void removeEducationalCalender(Long classId);

    void updateClassStatus ();

    void updateAllSetToNullByEducationalCalenderId(Long id);

    ElsSessionDetailsResponse getClassUsersDetail(String classCode);

    TclassDTO.ExecutionEvaluationResult getExecutionEvaluationResult(Long classId);

    String getClassTeachingMethod(Long classId);

    String getClassTargetPopulation(Long classId);

    boolean checkClassScoring(ScoringClassDto scoringClassDto);

    ElsPassedCourses getPassedClassesByNationalCode(String nationalCode, int page, int size, SearchDtoRequest search);

    ElsPassedCourses getPassedClassesByNationalCode(String nationalCode);

    void getCertification(String nationalCode, Long classId, HttpServletResponse response) throws IOException, JRException, SQLException, ParseException;
    byte[] getCertificationFile(String nationalCode, Long classId, HttpServletResponse response) throws IOException, JRException, SQLException, ParseException;

    void getCertificationByQRCode(String nationalCode, Long classId, HttpServletResponse response) throws IOException, JRException, SQLException, ParseException;

    ActiveCoursesDto getActiveCourses(int page, int size, SearchDtoRequest search);

    ActiveClassesDto getActiveClasses(long courseId, int page, int size, SearchDtoRequest search);

    ActiveClassesDto getMyActiveClasses(String nationalCode, int page, int size, SearchDtoRequest search);

    byte[] getCertificationByQRCodeFile(String nationalCode, Long classId, HttpServletResponse response) throws IOException, JRException, ParseException;

    QRCodeDataDto getCertificationDataByQRCodeFile(String nationalCode, Long classId);

    List<ElsTeacherClass> teacherClassesFileByNationalCode(String nationalCode);
}

