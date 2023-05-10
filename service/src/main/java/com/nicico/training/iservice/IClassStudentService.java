package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.TypeOfEnterToClassReport;
import org.springframework.transaction.annotation.Transactional;
import request.exam.ElsExamScore;
import request.exam.ExamResult;
import response.BaseResponse;
import response.tclass.dto.ElsClassListDto;
import response.tclass.dto.ElsClassListV2Dto;
import response.tclass.dto.SessionConflictDto;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

public interface IClassStudentService {

    ClassStudent getClassStudent(Long id);

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

    Map<String, String> registerStudents(List<ClassStudentDTO.Create> request, Long classId);

    void saveOrUpdate(ClassStudent classStudent);

    String delete(Long id);

    void delete(ClassStudentDTO.Delete request);

    int setStudentFormIssuance(Map<String, String> formIssuance);

    void setTotalStudentWithOutScore(Long classId);

    List<Long> getScoreState(Long classId);

    Map<String, Integer> getStatusSendMessageStudents(Long classId);

    List<ClassStudent> getClassStudents(long classId);


    @Transactional(readOnly = true)
    SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> searchEvaluationAnalysistLearning(SearchDTO.SearchRq request, Long classId);


    BaseResponse updateScore(ElsExamScore elsExamScore);

    ElsClassListDto getTeacherClasses(String nationalCode, Integer page, Integer size);
    ElsClassListV2Dto getTeacherClassesV2(String nationalCode, Integer page, Integer size);
    ElsClassListV2Dto getTeacherClassesV2WithFilter(String nationalCode,String search, Integer page, Integer size);
    ElsClassListV2Dto getTeacherClassesV3WithFilter(String examType,String nationalCode,String search, Integer page, Integer size);

    ElsClassListDto getStudentClasses(String nationalCode, Integer page, Integer size);
    ElsClassListV2Dto getStudentClassesV2(String nationalCode, Integer page, Integer size);
    ElsClassListV2Dto getStudentClassesV2WithFilter(String nationalCode,String search, Integer page, Integer size);
    void testAddStudent(String classCode);

    BaseResponse updatePreTestScore(long id, List<ExamResult> examResult);

    BaseResponse updateTestScore(long id, List<ExamResult> examResult);

    @Transactional
    void setPeresenceTypeId(Long presenceTypeId, Long id);

    List<Long> findEvaluationStudentInClass(Long studentId, Long classId);

    Optional<ClassStudent> findById(Long classStudentId);

    List<String> getStudentBetWeenRangeTime(String startDate, String endDate,String personnelNos);


    List<SessionConflictDto> getSessionConflictViaClassStudent(String nationalCode, List<ClassSessionDTO.ClassStudentSession> classStudentSessions);

    ClassStudent save(ClassStudent classStudent);

    BaseResponse syncPersonnelData(Long id);

    boolean IsStudentAttendanceAllowable(Long classStudentId);

    String isScoreEditable(Long classStudentId);

    Boolean isAcceptByCertification(Long classStudentId);

    Boolean checkStudentIsInCourse(String requesterNationalCode, String objectCode);

    Boolean checkStudentIsInClass(String requesterNationalCode, String objectCode);

    BaseResponse sendEvaluationForPresentStudent(Long classId);

    Boolean checkClassForFinalTest(Long classId);

    List<TypeOfEnterToClassReport> getTypeOfEnterToClassReport(String fromDate, String toDate, List<Object> complex, int complexNull, List<Object> assistant, int assistantNull, List<Object> affairs, int affairsNull);
}
