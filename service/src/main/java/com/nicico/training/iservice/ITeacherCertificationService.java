package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ElsTeacherCertification;
import com.nicico.training.dto.TeacherCertificationBaseResponse;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.model.TeacherCertification;

import javax.servlet.http.HttpServletResponse;
import java.util.List;


public interface ITeacherCertificationService {

    TeacherCertificationDTO.Info get(Long id);

    TeacherCertification getTeacherCertification(Long id);

    ElsTeacherCertification saveCertification(TeacherCertification teacherCertification,ElsTeacherCertification elsTeacherCertification);

    TeacherCertificationDTO.Info update(Long id, TeacherCertificationDTO.Update request,HttpServletResponse response);

    SearchDTO.SearchRs<TeacherCertificationDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    void addTeacherCertification(TeacherCertificationDTO.Create request, Long teacherId, HttpServletResponse response);

    void deleteTeacherCertification(Long teacherId, Long teacherCertificationId);

    TeacherCertificationBaseResponse editTeacherCertification(ElsTeacherCertification elsTeacherCertification);
    List<TeacherCertification> findAllTeacherCertifications(Long teacherId);
}
