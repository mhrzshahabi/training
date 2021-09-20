package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:roya
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Tclass;
import request.evaluation.StudentEvaluationAnswerDto;
import response.BaseResponse;
import response.evaluation.dto.EvalAverageResult;
import response.evaluation.dto.EvaluationAnswerObject;
import org.springframework.transaction.annotation.Transactional;
import request.evaluation.TeacherEvaluationAnswerDto;
import response.tclass.ElsSessionResponse;

import java.util.List;
import java.util.Map;
import java.util.Set;

public interface ITclassService {

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
    Map<String,Object> calculateEffectivenessEvaluation(String reactionGrade_s, String learningGrade_s, String behavioralGrade_s, String classEvaluation);

    @Transactional
    Map<Long,Integer> checkClassesForSendMessage(List<Long> classIds);

    @Transactional
    void changeOnlineEvalTeacherStatus(Long classId , boolean state);

    @Transactional
    void changeOnlineEvalStudentStatus(Long classId ,boolean state);

    @Transactional
    BaseResponse changeClassStatus(Long classId , String statem, String reason);


    EvaluationAnswerObject classTeacherEvaluations( TeacherEvaluationAnswerDto dto);
    EvaluationAnswerObject classStudentEvaluations(StudentEvaluationAnswerDto dto);

    Boolean hasAccessToChangeClassStatus(String groupIds);
    Map<String,Boolean> hasAccessToGroups(String groupIds);

    String getClassDefaultYear();

    Long getClassDefaultTerm(String year);

    List<String> getClassDefaultTermScope();

    boolean isValidForExam(long id);

    BaseResponse changeClassStatusToInProcess(Long classId);

    EvalAverageResult getStudentsAverageGradeToTeacher(Set<ClassStudent> classStudents);

    void changeClassToOnlineStatus(Long classId, boolean state);

    Tclass getClassByCode(String classCode);

    ElsSessionResponse getClassSessionsByCode(String classCode);

    TclassDTO.TClassScoreEval getTClassDataForScoresInEval(String classCode);

    }
    List<Tclass> getAuditData(long classId);
    EvalAverageResult getEvaluationAverageResultToTeacher(Long classId);
}
