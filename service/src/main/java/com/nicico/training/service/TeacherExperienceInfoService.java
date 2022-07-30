package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.dto.TeacherExperienceInfoDTO;
import com.nicico.training.iservice.ITeacherExperienceInfoService;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.TeacherDAO;
import com.nicico.training.repository.TeacherExperienceInfoDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TeacherExperienceInfoService  implements ITeacherExperienceInfoService {
    private final TeacherExperienceInfoDAO teacherExperienceInfoDAO;
    private final ModelMapper modelMapper;
//    @Override
//    public SearchDTO.SearchRs<TeacherExperienceInfoDTO> search(SearchDTO.SearchRq request, Long teacherId) {
//
//        request = (request != null) ? request : new SearchDTO.SearchRq();
//        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
//        request.setDistinct(true);
//        if (teacherId != null) {
//            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
//            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
//            if (request.getCriteria() != null) {
//                for (SearchDTO.CriteriaRq o : request.getCriteria().getCriteria()) {
//                    if(o.getFieldName().equalsIgnoreCase("categories"))
//                        o.setValue(Long.parseLong(o.getValue().get(0)+""));
//                    if(o.getFieldName().equalsIgnoreCase("subCategories"))
//                        o.setValue(Long.parseLong(o.getValue().get(0)+""));
//                }
//                if (request.getCriteria().getCriteria() != null)
//                    request.getCriteria().getCriteria().add(criteriaRq);
//                else
//                    request.getCriteria().setCriteria(list);
//            } else
//                request.setCriteria(criteriaRq);
//        }
//        for (SearchDTO.CriteriaRq  criteriaRq : request.getCriteria().getCriteria()) {
//            if(criteriaRq.getFieldName() != null) {
//                if (criteriaRq.getFieldName().equalsIgnoreCase("subCategoriesIds"))
//                    criteriaRq.setFieldName("subCategories");
//                if (criteriaRq.getFieldName().equalsIgnoreCase("categoriesIds"))
//                    criteriaRq.setFieldName("categories");
//                if (criteriaRq.getFieldName().equalsIgnoreCase("persianStartDate"))
//                    criteriaRq.setFieldName("startDate");
//                if (criteriaRq.getFieldName().equalsIgnoreCase("persianEndDate"))
//                    criteriaRq.setFieldName("endDate");
//            }
//        }
//        return SearchUtil.search(teacherExperienceInfoDAO, request, teacherExperienceInfo -> modelMapper.map( teacherExperienceInfo, TeacherExperienceInfoDTO.class));
//    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        return BaseService.makeNewCriteria(fieldName, value, operator, criteriaRqList);
    }

}
