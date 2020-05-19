package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.model.TeacherCertification;

import javax.servlet.http.HttpServletResponse;


public interface ITeacherCertificationService {

    TeacherCertificationDTO.Info get(Long id);

    TeacherCertification getTeacherCertification(Long id);

    TeacherCertificationDTO.Info update(Long id, TeacherCertificationDTO.Update request,HttpServletResponse response);

    SearchDTO.SearchRs<TeacherCertificationDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    void addTeacherCertification(TeacherCertificationDTO.Create request, Long teacherId, HttpServletResponse response);

    void deleteTeacherCertification(Long teacherId, Long teacherCertificationId);
}
