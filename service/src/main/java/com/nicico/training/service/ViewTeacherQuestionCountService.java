package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTeacherQuestionCountDTO;
import com.nicico.training.iservice.IViewTeacherQuestionCountService;
import com.nicico.training.repository.ViewTeacherQuestionCountReportDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewTeacherQuestionCountService implements IViewTeacherQuestionCountService {

    private final ViewTeacherQuestionCountReportDAO dao;
    private final ModelMapper modelMapper;

    @Override
    public SearchDTO.SearchRs<ViewTeacherQuestionCountDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(dao, request, viewTeacherQuestionCountReport -> modelMapper.map(viewTeacherQuestionCountReport, ViewTeacherQuestionCountDTO.Info.class));
    }

}
