package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.InstituteDTO;
import com.nicico.training.dto.ViewAttendanceReportDTO;
import com.nicico.training.iservice.IAttendanceReportService;
import com.nicico.training.model.ViewAttendanceReport;
import com.nicico.training.repository.ViewAttendanceReportDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.function.Function;

@Service
@RequiredArgsConstructor

public class AttendanceReportService implements IAttendanceReportService {
    private final ModelMapper modelMapper;

    private final ViewAttendanceReportDAO viewAttendanceReportDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(viewAttendanceReportDAO, request, converter);
    }


}
