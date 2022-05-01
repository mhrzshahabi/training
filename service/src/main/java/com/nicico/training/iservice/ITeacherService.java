package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.*;
import org.springframework.data.domain.Page;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;
import response.teacher.dto.TeacherInCourseDto;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ITeacherService {

    TeacherDTO.Info get(Long id);

    Teacher getTeacher(Long id);

    List<TeacherDTO.Info> list();

    TeacherDTO.Info create(TeacherDTO.Create request);

    TeacherDTO.Info update(Long id, TeacherDTO.Update request);

    void delete(Long id);

    void delete(TeacherDTO.Delete request);

    SearchDTO.SearchRs<TeacherDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearch(SearchDTO.SearchRq request);

    @Transactional(readOnly = true)
    SearchDTO.SearchRs<TeacherDTO.TeacherInfoTuple> infoTupleSearch(SearchDTO.SearchRq request);

    @Transactional(readOnly = true)
    SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearchFilter(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<TeacherDTO.Info> deepSearch(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException;

    SearchDTO.SearchRs<TeacherDTO.Grid> deepSearchGrid(SearchDTO.SearchRq request) throws NoSuchFieldException, IllegalAccessException;

    SearchDTO.SearchRs<TeacherDTO.Report> deepSearchReport(SearchDTO.SearchRq request);

    public SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList);

    void changeBlackListStatus(String reason, Boolean inBlackList, Long id);

    @Transactional(readOnly = true)
    Map<String, Object> evaluateTeacher(Long id, String catId, String subCatId);

    @Transactional(readOnly = true)
    Map<String, Object> evaluateTeacher(Teacher teacher, Category category, Subcategory subcategory, List<ParameterValueDTO.Info> parameterValues);

    List<Map<String,Object>> findAllByNationalCodeAndMobileNumber(String nationalCode,String mobileNumber);

    Long getTeacherIdByNationalCode(String nationalCode);

    Page<Teacher> getActiveTeachers(int page, int size);

    List<TeacherInCourseDto> getTeachersInCourse(Long courseId);

    String getTeacherNationalCodeById(Long teacherId);

    List<TclassDTO.AllStudentsGradeToTeacher> getAllStudentsGradeToTeacher(Long courseId, Long teacherId);

    Optional<Teacher> findByTeacherCode(String teacherCode);


    String getTeacherFullName(Long teacherId);

    BaseResponse saveElsTeacherGeneralInfo(Teacher teacher, TeacherGeneralInfoDTO teacherGeneralInfoDTO);

    ElsTeacherInfoDto.Resume getTeacherResumeByNationalCode(String nationalCode);

    SearchDTO.SearchRs<TeacherDTO.ForAgreementInfo> forAgreementInfoSearch(SearchDTO.SearchRq request);
}
