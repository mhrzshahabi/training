package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.model.Teacher;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

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
    SearchDTO.SearchRs<TeacherDTO.TeacherFullNameTuple> fullNameSearchFilter(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<TeacherDTO.Info> deepSearch(SearchDTO.SearchRq request);

    public void changeBlackListStatus(Boolean inBlackList, Long id);

    SearchDTO.SearchRs<TeacherDTO.Grid> deepSearchGrid(SearchDTO.SearchRq request);

}
