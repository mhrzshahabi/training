package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.dto.TeachingHistoryDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ITeacherService {

    TeacherDTO.Info get(Long id);

    List<TeacherDTO.Info> list();

    TeacherDTO.Info create(TeacherDTO.Create request);

    TeacherDTO.Info update(Long id, TeacherDTO.Update request);

    void delete(Long id);

    void delete(TeacherDTO.Delete request);

    SearchDTO.SearchRs<TeacherDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearch(SearchDTO.SearchRq request);

    @Transactional(readOnly = true)
    SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearchFilter(SearchDTO.SearchRq request);

    void addCategories(CategoryDTO.Delete request, Long teacherId);

    List<Long> getCategories(Long teacherId);

    void addEmploymentHistory(EmploymentHistoryDTO.Create request, Long teacherId);

    void deleteEmploymentHistory(Long teacherId, Long employmentHistoryId);

}
