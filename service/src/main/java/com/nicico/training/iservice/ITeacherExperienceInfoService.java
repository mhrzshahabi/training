package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.model.TeacherExperienceInfo;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface ITeacherExperienceInfoService {

    SearchDTO.SearchRs<TeacherExperienceInfoDTO.ExcelInfo> search(SearchDTO.SearchRq request, Long teacherId);

    void addTeacherExperienceInfo(TeacherExperienceInfoDTO teacherExperienceInfoDTO, HttpServletResponse response);

    List<TeacherExperienceInfoDTO.Create> addTeacherFurtherInfoList(List<TeacherExperienceInfoDTO.Create> createList);

    TeacherExperienceInfo getTeacherExperienceInfo(Long id);

    TeacherExperienceInfoDTO update(Long id, TeacherExperienceInfoDTO update, HttpServletResponse response);

    TeacherExperienceInfoDTO get(Long id);

    void deleteTeacherExperienceInfo(Long teacherId, Long id);

    TeacherExperienceInfo getLastTeacherExperienceInfoByTeacherId(Long teacherId);
}
