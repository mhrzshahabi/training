package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.model.Teacher;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IQuestionnaireQuestionService {
    TeacherDTO.Info get(Long id);

}
