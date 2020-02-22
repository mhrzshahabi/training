package com.nicico.training.iservice;
/* com.nicico.training.iservice
@Author:roya
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.Tclass;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ITclassService {

    TclassDTO.Info get(Long id);

    Tclass getTClass(Long id);

    List<String> getPreCourseTestQuestions(Long tclassId);

    void updatePreCourseTestQuestions(Long classId, List<String> preCourseTestQuestions);

    @Transactional(readOnly = true)
    Tclass getEntity(Long id);

    List<TclassDTO.Info> list();

    TclassDTO.Info create(TclassDTO.Create request);

    TclassDTO.Info update(Long id, TclassDTO.Update request);

    void delete(Long id);

    @Transactional(readOnly = true)
    List<ClassStudentDTO.AttendanceInfo> getStudents(Long classID);

    void delete(TclassDTO.Delete request);

    SearchDTO.SearchRs<TclassDTO.Info> search(SearchDTO.SearchRq request);

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

    public TclassDTO.ReactionEvaluationResult getReactionEvaluationResult(Long classId, Long trainingId);
}
