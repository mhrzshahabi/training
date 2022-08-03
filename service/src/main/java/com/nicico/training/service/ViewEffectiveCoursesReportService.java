package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewEffectiveCoursesReportDTO;
import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;
import com.nicico.training.iservice.IViewEffectiveCoursesReportService;
import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
import com.nicico.training.model.ViewNeedAssessmentInRangeTime;
import com.nicico.training.repository.ViewEffectiveCourseReportDAO;
import com.nicico.training.repository.ViewNeedAssessmentInRangeTimeDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.function.Function;

@RequiredArgsConstructor
@Service
public class ViewEffectiveCoursesReportService implements IViewEffectiveCoursesReportService {
    private final ViewEffectiveCourseReportDAO effectiveCourseReportDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(effectiveCourseReportDAO, request, converter);
    }


}
