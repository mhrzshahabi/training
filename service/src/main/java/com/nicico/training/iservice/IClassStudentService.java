package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.model.ClassStudent;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Map;
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

    Map<String,Integer> getStatusSendMessageStudents(Long classId);

    List<ClassStudent> getClassStudents(long classId);


    @Transactional(readOnly = true)
   SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> searchEvaluationAnalysistLearning(SearchDTO.SearchRq request,Long classId);
}
