package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.ViewAttendanceReportDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IPersonnelCoursePassedOrNotPaseedNAReportViewService;
import com.nicico.training.model.PersonnelCoursePassedOrNotPaseedNAReportView;
import com.nicico.training.repository.PersonnelCoursePassedOrNotPaseedNAReportViewDAO;
import lombok.RequiredArgsConstructor;

import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class PersonnelCoursePassedOrNotPaseedNAReportViewService implements IPersonnelCoursePassedOrNotPaseedNAReportViewService {

    private final PersonnelCoursePassedOrNotPaseedNAReportViewDAO personnelCoursePassedOrNotPaseedNAReportViewDAO;
    private final ICategoryService iCategoryService;
    private final ModelMapper modelMapper;

    @Override
    public List<PersonnelCoursePassedOrNotPaseedNAReportView> getAll() {
        return personnelCoursePassedOrNotPaseedNAReportViewDAO.findAll();
    }

    @Override
    public List<PersonnelCoursePassedOrNotPaseedNAReportView> getPassedOrUnPassed(List<Long> catIds, String isPassed) {
        long passedOrNot;
        if (isPassed.equals("unPassed"))
            passedOrNot = 399L;
        else
            passedOrNot = 216L;

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(null);

        request.setSortBy("id");

        List<SearchDTO.CriteriaRq> listOfCriteria = new ArrayList<>();
        List<SearchDTO.CriteriaRq> listOfCriteria2 = new ArrayList<>();
        List<SearchDTO.CriteriaRq> listOfCriteria3 = new ArrayList<>();

        SearchDTO.CriteriaRq isPassedOrNotCriteria = null;
        SearchDTO.CriteriaRq courseCriteria = null;
        SearchDTO.CriteriaRq finalCriteria = null;

        isPassedOrNotCriteria = new SearchDTO.CriteriaRq();
        isPassedOrNotCriteria.setOperator(EOperator.equals);
        isPassedOrNotCriteria.setFieldName("isPassed");
        isPassedOrNotCriteria.setValue(passedOrNot);

        listOfCriteria.add(isPassedOrNotCriteria);

        for (Long id : catIds) {
            CategoryDTO.Info categoryDTO = iCategoryService.get(id);
            courseCriteria = new SearchDTO.CriteriaRq();
            courseCriteria.setOperator(EOperator.startsWith);
            courseCriteria.setFieldName("courseCode");
            courseCriteria.setValue(categoryDTO.getCode());

            listOfCriteria2.add(courseCriteria);

        }
        courseCriteria = new SearchDTO.CriteriaRq();
        courseCriteria.setCriteria(listOfCriteria2);
        courseCriteria.setOperator(EOperator.or);
        listOfCriteria3.add(courseCriteria);
        listOfCriteria3.add(isPassedOrNotCriteria);
        finalCriteria = new SearchDTO.CriteriaRq();
        finalCriteria.setCriteria(listOfCriteria3);
        finalCriteria.setOperator(EOperator.and);
        request.setCriteria(finalCriteria);
        SearchDTO.SearchRs result = search(request, o -> modelMapper.map(o, PersonnelCoursePassedOrNotPaseedNAReportView.class));
        return result.getList();


    }

    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(personnelCoursePassedOrNotPaseedNAReportViewDAO, request, converter);
    }
}
