package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.StudentClassReportViewDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.StudentClassReportViewDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class StudentClassReportViewService implements IStudentClassReportViewService {

    private final StudentClassReportViewDAO studentClassReportViewDAO;
    private final ModelMapper modelMapper;

    @Transactional
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(studentClassReportViewDAO, request, converter);
    }

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<StudentClassReportViewDTO.Info> search(SearchDTO.SearchRq request) {
        SearchDTO.SearchRs<StudentClassReportView> search = SearchUtil.search(studentClassReportViewDAO, request, course -> modelMapper.map(course, StudentClassReportView.class));
        SearchDTO.SearchRs<StudentClassReportViewDTO.Info> exitList = new SearchDTO.SearchRs<>();
        exitList.setTotalCount(search.getTotalCount());
        List<StudentClassReportViewDTO.Info> infoList = new ArrayList<>();
        List<StudentClassReportView> list = search.getList();
        for (StudentClassReportView s : list) {
            StudentClassReportViewDTO.Info map = modelMapper.map(s, StudentClassReportViewDTO.Info.class);
            infoList.add(map);
        }
        exitList.setList(infoList);
        return exitList;
    }
    @Transactional(readOnly = true)
    public List<StudentClassReportViewDTO.Info> list() {
        final List<StudentClassReportView> gAll = studentClassReportViewDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<StudentClassReportViewDTO.Info>>() {
        }.getType());
    }
}
