package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.iservice.ITeacherExperienceInfoService;
import com.nicico.training.model.TeacherExperienceInfo;
import com.nicico.training.repository.TeacherExperienceInfoDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TeacherExperienceInfoService  implements ITeacherExperienceInfoService {
    private final TeacherExperienceInfoDAO teacherExperienceInfoDAO;
    private final ModelMapper modelMapper;
    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherExperienceInfoDTO> search(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        request.setDistinct(true);
        if (teacherId != null) {
            list.add(makeNewCriteria("teacher", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                for (SearchDTO.CriteriaRq o : request.getCriteria().getCriteria()) {
                    if(o.getFieldName().equalsIgnoreCase("currencyId"))
                        o.setValue(Long.parseLong(o.getValue().get(0)+""));

                }
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
//        for (SearchDTO.CriteriaRq  criteriaRq : request.getCriteria().getCriteria()) {
//            if(criteriaRq.getFieldName() != null) {
//                if (criteriaRq.getFieldName().equalsIgnoreCase("currencyId"))
//                    criteriaRq.setFieldName("subCategories");
//                if (criteriaRq.getFieldName().equalsIgnoreCase("categoriesIds"))
//                    criteriaRq.setFieldName("categories");
//                if (criteriaRq.getFieldName().equalsIgnoreCase("persianStartDate"))
//                    criteriaRq.setFieldName("startDate");
//                if (criteriaRq.getFieldName().equalsIgnoreCase("persianEndDate"))
//                    criteriaRq.setFieldName("endDate");
//            }
//        }
        return SearchUtil.search(teacherExperienceInfoDAO, request, teacherExInfo -> modelMapper.map(teacherExInfo, TeacherExperienceInfoDTO.class));
    }



    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        return BaseService.makeNewCriteria(fieldName, value, operator, criteriaRqList);
    }

}
