package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;

import com.nicico.training.dto.ViewNeedAssessmentInRangeDTO;
import com.nicico.training.iservice.IViewNeedAssessmentInRangeTimeService;
import com.nicico.training.model.ViewNeedAssessmentInRangeTime;
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
public class ViewNeedAssessmentInRangeTimeService implements IViewNeedAssessmentInRangeTimeService {
    private final ViewNeedAssessmentInRangeTimeDAO viewNeedAssessmentInRangeTimeDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(viewNeedAssessmentInRangeTimeDAO, request, converter);
    }

//    @Override
//    public List<Object> getList() {
//        @Transactional(readOnly = true)
//        @Override
//        public List<AccountInfoDTO.Info> getAllAccountForExcel(Long instituteId) {
//            final List<AccountInfo> accountInfos = accountInfoDAO.getAllByInstituteId(instituteId);
//            return modelMapper.map(accountInfos, new TypeToken<List<AccountInfoDTO.Info>>() {}.getType());
//        }
//        return Collections.singletonList("securityContext");
//    }

    @Transactional(readOnly = true)
    @Override
    public List<ViewNeedAssessmentInRangeDTO.Info> getList(String startDate, String endDate) throws ParseException {

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedDate = dateFormat.parse(startDate);
            Date parsedDate2 = dateFormat.parse(endDate);
            Timestamp firstTime = new Timestamp(parsedDate.getTime());
            Timestamp secondDate = new Timestamp(parsedDate2.getTime());

        final List<ViewNeedAssessmentInRangeTime> accountInfos = viewNeedAssessmentInRangeTimeDAO.findAllByUpdateAtBetween(firstTime,secondDate);
        return modelMapper.map(accountInfos, new TypeToken<List<ViewNeedAssessmentInRangeDTO.Info>>() {}.getType());
    }

}
