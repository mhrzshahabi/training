package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.StudentClassReportViewDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class StudentClassReportViewService implements IStudentClassReportViewService {

    private final StudentClassReportViewDAO studentClassReportViewDAO;

    @Transactional
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(studentClassReportViewDAO, request, converter);
    }
}
