package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelCoursePassedNAReportViewDTO;
import com.nicico.training.iservice.IPersonnelCoursePassedNAReportViewService;
import com.nicico.training.model.PersonnelCoursePassedNAReportView;
import com.nicico.training.repository.PersonnelCoursePassedNAReportViewDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PersonnelCoursePassedNAReportViewService implements IPersonnelCoursePassedNAReportViewService {

    private final PersonnelCoursePassedNAReportViewDAO personnelCoursePassedNAReportViewDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(personnelCoursePassedNAReportViewDAO, request, converter);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PersonnelCoursePassedNAReportViewDTO.Grid> searchCourseList(SearchDTO.SearchRq request) {
        List<PersonnelCoursePassedNAReportView> personnelCourseList = personnelCoursePassedNAReportViewDAO.findAll(NICICOSpecification.of(request.getCriteria()));
        List<PersonnelCoursePassedNAReportViewDTO.Grid> result = new ArrayList<>();
        Map<Long, List<PersonnelCoursePassedNAReportView>> personnelCourseMap = personnelCourseList.stream().collect(Collectors.groupingBy(PersonnelCoursePassedNAReportView::getCourseId));
        personnelCourseMap.forEach((courseId, personnelCourse) -> {
            PersonnelCoursePassedNAReportViewDTO.Grid course = new PersonnelCoursePassedNAReportViewDTO.Grid()
                    .setCourseId(courseId).setCourseCode(personnelCourse.get(0).getCourseCode())
                    .setCourseTitleFa(personnelCourse.get(0).getCourseTitleFa())
                    .setTotalEssentialPersonnelCount((int) personnelCourse.stream().filter(pc -> pc.getPriorityId() == 111L).count())
                    .setNotPassedEssentialPersonnelCount((int) personnelCourse.stream().filter(pc -> pc.getPriorityId() == 111L && !pc.getIsPassed()).count())
                    .setTotalImprovingPersonnelCount((int) personnelCourse.stream().filter(pc -> pc.getPriorityId() == 112L).count())
                    .setNotPassedImprovingPersonnelCount((int) personnelCourse.stream().filter(pc -> pc.getPriorityId() == 112L && !pc.getIsPassed()).count())
                    .setTotalDevelopmentalPersonnelCount((int) personnelCourse.stream().filter(pc -> pc.getPriorityId() == 113L).count())
                    .setNotPassedDevelopmentalPersonnelCount((int) personnelCourse.stream().filter(pc -> pc.getPriorityId() == 113L && !pc.getIsPassed()).count());
            result.add(course);
        });
        SearchDTO.SearchRs<PersonnelCoursePassedNAReportViewDTO.Grid> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setList(result);
        searchRs.setTotalCount((long) personnelCourseMap.keySet().size());
        return searchRs;
    }

//    @Transactional(readOnly = true)
//    public SearchDTO.SearchRs<PersonnelCoursePassedNAReportViewDTO.MinInfo> searchMinList(SearchDTO.SearchRq request) {
//        return search(request, r -> modelMapper.map(r, PersonnelCoursePassedNAReportViewDTO.MinInfo.class));
//        List<PersonnelCoursePassedNAReportView> personnelCourseList = personnelCoursePassedNAReportViewDAO.findAll(NICICOSpecification.of(request.getCriteria()));
//        List<PersonnelCoursePassedNAReportViewDTO.MinInfo> result = modelMapper.map(personnelCourseList, new TypeToken<List<PersonnelCoursePassedNAReportViewDTO.MinInfo>>(){}.getType());
//        SearchDTO.SearchRs<PersonnelCoursePassedNAReportViewDTO.MinInfo> searchRs = new SearchDTO.SearchRs<>();
//        searchRs.setList(result);
//        searchRs.setTotalCount(new Long(result.size()));
//        return searchRs;
//    }
}
