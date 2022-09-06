
package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.dto.NeedsAssessmentWithGapDTO;
import com.nicico.training.iservice.INeedsAssessmentWithGapService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;

import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.function.Supplier;

import static com.nicico.training.service.BaseService.makeNewCriteria;


@RequiredArgsConstructor
@Service
public class NeedsAssessmentWithGapService  implements INeedsAssessmentWithGapService {
    private final ModelMapper modelMapper;
    private final NeedsAssessmentWithGapDAO needsAssessmentDAO;
    private final NeedsAssessmentReportsService needsAssessmentReportsService;

    @Override
    public SearchDTO.SearchRs<NeedsAssessmentWithGapDTO.Info> fullSearch(Long objectId, String objectType) {
        List<NeedsAssessmentWithGapDTO.Info> naList;
//        Integer readOnlyStatus = needsAssessmentTempService.readOnlyStatus(objectType, objectId);
//        if (readOnlyStatus == 1 /* || readOnlyStatus == 3 */)
//            naList = modelMapper.map(needsAssessmentReportsService.getUnverifiedNeedsAssessmentList(objectId, objectType), new TypeToken<List<NeedsAssessmentDTO.Info>>() {
//            }.getType());
//        else
            naList = modelMapper.map(getNeedsAssessmentList(objectId, objectType), new TypeToken<List<NeedsAssessmentWithGapDTO.Info>>() {
            }.getType());
        SearchDTO.SearchRs<NeedsAssessmentWithGapDTO.Info> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) naList.size());
        rs.setList(naList);
        return rs;
    }

    private Object getNeedsAssessmentList(Long objectId, String objectType) {
        List<NeedsAssessmentWithGap> needsAssessmentList = new ArrayList<>();
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.or, new ArrayList<>()));
        criteriaRq.getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
        needsAssessmentReportsService.addCriteria(criteriaRq.getCriteria().get(0), objectType, objectId, true, true);
        if (!criteriaRq.getCriteria().get(0).getCriteria().isEmpty())
            needsAssessmentList = needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq));
        return removeDuplicateNAs(needsAssessmentList);
    }



    private List<NeedsAssessmentWithGap> removeDuplicateNAs(List<NeedsAssessmentWithGap> needsAssessmentList) {
        needsAssessmentList.sort(Comparator.comparingInt(a -> NeedsAssessment.priorityList.indexOf(a.getObjectType())));
        List<NeedsAssessmentWithGap> withoutDuplicate = new ArrayList<>();
        needsAssessmentList.forEach(needsAssessment -> {
            if (withoutDuplicate.stream().noneMatch(wd -> wd.getSkill().equals(needsAssessment.getSkill())))
                withoutDuplicate.add(needsAssessment);
        });
        return withoutDuplicate;
    }

}