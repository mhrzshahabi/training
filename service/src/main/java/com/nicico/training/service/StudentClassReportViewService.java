package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.StudentClassReportViewDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.StudentClassReportViewDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
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

    @Transactional(readOnly = true)
    public List<StudentClassReportViewDTO.InfoTuple> listTuple() {
        final List<StudentClassReportView> gAll = studentClassReportViewDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<StudentClassReportViewDTO.InfoTuple>>() {
        }.getType());
    }

    @Transactional
    public SearchDTO.SearchRs<StudentClassReportViewDTO.FieldValue> findAllValuesOfOneFieldFromPersonnel(String fieldName) {
        List<String> values = null;
        switch (fieldName) {
            case "company":
                values = studentClassReportViewDAO.findAllCompanySCRV();
                break;
            case "scoreState":
                values = studentClassReportViewDAO.findAllScoreStateFromViewSCRV();
                break;
            case "complex":
                values = studentClassReportViewDAO.findAllComplexSCRV();
                break;
            case "assistant":
                values = studentClassReportViewDAO.findAllAssistantSCRV();
                break;
            case "affairs":
                values = studentClassReportViewDAO.findAllAffairsSCRV();
                break;
            case "section":
                values = studentClassReportViewDAO.findAllSectionSCRV();
                break;
            case "unit":
                values = studentClassReportViewDAO.findAllUnitSCRV();
                break;
            case "area":
                values = studentClassReportViewDAO.findAllAreaSCRV();
                break;
            case "termCode":
                values = studentClassReportViewDAO.findAllTermCodeSCRV();
                break;
        }
        SearchDTO.SearchRs<StudentClassReportViewDTO.FieldValue> response = new SearchDTO.SearchRs<>();
        response.setList(new ArrayList<>());
        values.forEach(value -> response.getList().add(new StudentClassReportViewDTO.FieldValue(value)));
        response.setTotalCount((long) response.getList().size());
        return response;
    }

    public List<StudentClassReportViewDTO.CourseInfoSCRV> findCourses(){
        List<ICourseSCRV> scrv = studentClassReportViewDAO.findDistinctByCourseIdIsNotNull();
        return modelMapper.map(scrv, new TypeToken<List<StudentClassReportViewDTO.CourseInfoSCRV>>() {
        }.getType());
    }
}
