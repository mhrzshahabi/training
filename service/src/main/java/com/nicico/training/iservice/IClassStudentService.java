package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.enums.ExamsType;
import com.nicico.training.model.ClassStudent;
import org.springframework.data.domain.Page;
import org.springframework.transaction.annotation.Transactional;
import request.exam.ElsExamScore;
import response.BaseResponse;
import response.tclass.dto.ElsClassListDto;

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

    Map<String, Integer> getStatusSendMessageStudents(Long classId);

    List<ClassStudent> getClassStudents(long classId);


    @Transactional(readOnly = true)
    SearchDTO.SearchRs<ClassStudentDTO.evaluationAnalysistLearning> searchEvaluationAnalysistLearning(SearchDTO.SearchRq request, Long classId);


    BaseResponse updateScore(ElsExamScore elsExamScore);

    ElsClassListDto getTeacherClasses(String nationalCode, Integer page, Integer size);
}
