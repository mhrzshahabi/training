package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassesReactiveAssessmentHasNotReachedQuorumDTO;
import com.nicico.training.iservice.IClassesReactiveAssessmentHasNotReachedQuorumService;
import com.nicico.training.model.ClassesReactiveAssessmentHasNotReachedQuorum;
import com.nicico.training.repository.ClassesReactiveAssessmentHasNotReachedQuorumDAO;
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
public class ClassesReactiveAssessmentHasNotReachedQuorumService implements IClassesReactiveAssessmentHasNotReachedQuorumService {
    private final ClassesReactiveAssessmentHasNotReachedQuorumDAO hasNotReachedQuorumDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(hasNotReachedQuorumDAO, request, converter);
    }

    @Transactional(readOnly = true)
    @Override
    public List<ClassesReactiveAssessmentHasNotReachedQuorumDTO.Info> getList(String startDate, String endDate) throws ParseException {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date parsedDate = dateFormat.parse(startDate);
        Date parsedDate2 = dateFormat.parse(endDate);
        Timestamp firstTime = new Timestamp(parsedDate.getTime());
        Timestamp secondDate = new Timestamp(parsedDate2.getTime());

        final List<ClassesReactiveAssessmentHasNotReachedQuorum> accountInfos = hasNotReachedQuorumDAO.findAllByClassStartDateBetween(firstTime,secondDate);
        return modelMapper.map(accountInfos, new TypeToken<List<ClassesReactiveAssessmentHasNotReachedQuorumDTO.Info>>() {}.getType());
    }
}
