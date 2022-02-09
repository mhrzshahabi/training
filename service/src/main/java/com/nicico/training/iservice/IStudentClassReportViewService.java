package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.StudentClassReportViewDTO;
import com.nicico.training.model.ClassStudent;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.function.Function;

public interface IStudentClassReportViewService {


    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

    SearchDTO.SearchRs<StudentClassReportViewDTO.FieldValue> findAllValuesOfOneFieldFromPersonnel(String fieldName);

    List<StudentClassReportViewDTO.CourseInfoSCRV> findCourses();

    @Transactional
    List<StudentClassReportViewDTO.Info> findAllStatisticalReportFilter(String reportType);

    SearchDTO.SearchRs<StudentClassReportViewDTO.Info> search(SearchDTO.SearchRq request);
}
