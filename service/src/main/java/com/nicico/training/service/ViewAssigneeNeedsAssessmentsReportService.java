package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IViewAssigneeNeedsAssessmentsReport;
import com.nicico.training.repository.ViewAssigneeNeedsAssessmentsReportDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.function.Function;

@RequiredArgsConstructor
@Service
public class ViewAssigneeNeedsAssessmentsReportService implements IViewAssigneeNeedsAssessmentsReport {
    private final ViewAssigneeNeedsAssessmentsReportDAO viewAssigneeNeedsAssessmentsReportDAO;
//    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(viewAssigneeNeedsAssessmentsReportDAO, request, converter);
    }
}
