package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PublicationDTO;
import com.nicico.training.dto.teacherPublications.ElsPublicationDTO;
import com.nicico.training.dto.teacherPublications.TeacherPublicationResponseDTO;
import com.nicico.training.model.Publication;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;


public interface IPublicationService {

    PublicationDTO.Info get(Long id);

    Publication getPublication(Long id);

    PublicationDTO.Info update(Long id, PublicationDTO.Update request, HttpServletResponse response);

    SearchDTO.SearchRs<PublicationDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    void addPublication(PublicationDTO.Create request, Long teacherId,HttpServletResponse response);

    void deletePublication(Long teacherId, Long publicationId);

    PublicationDTO.Info save(Publication publication, HttpServletResponse response);

    TeacherPublicationResponseDTO findTeacherPublicationsByNationalCode(String nationalCode);

    ElsPublicationDTO.UpdatedInfo create(ElsPublicationDTO.Create elsPublicationDTO);

    ElsPublicationDTO.UpdatedInfo updateElsPub(ElsPublicationDTO.Update elsPublicationDTO);

    BaseResponse deleteTeacherPublication(Long id);

    ElsPublicationDTO.UpdatedInfo getOneById(Long id);
}
