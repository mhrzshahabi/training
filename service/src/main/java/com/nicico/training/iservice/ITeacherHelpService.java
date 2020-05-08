package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.Teacher;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

public interface ITeacherHelpService {


    @Transactional
    List<EmploymentHistoryDTO.Info> getEmploymentHistories(Long teacherId);

    @Transactional
    List<TeachingHistoryDTO.Info> getTeachingHistories(Long teacherId);

    @Transactional
    List<TeacherCertificationDTO.Info> getTeacherCertifications(Long teacherId);

    @Transactional
    List<PublicationDTO.Info> getPublications(Long teacherId);

    @Transactional
    List<ForeignLangKnowledgeDTO.Info> getForeignLangKnowledges(Long teacherId);
}
