package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelCoursePassedNAReportViewDTO;
import com.nicico.training.iservice.IPersonnelCoursePassedNAReportViewService;
import com.nicico.training.repository.PersonnelCoursePassedNAReportViewDAO;
import com.nicico.training.utility.CriteriaConverter;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class PersonnelCoursePassedNAReportViewService implements IPersonnelCoursePassedNAReportViewService {

    private final PersonnelCoursePassedNAReportViewDAO personnelCoursePassedNAReportViewDAO;

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(personnelCoursePassedNAReportViewDAO, request, converter);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PersonnelCoursePassedNAReportViewDTO.Grid> searchCourseList(SearchDTO.SearchRq request) {
        List<PersonnelCoursePassedNAReportViewDTO.Grid> result = new ArrayList<>();
        Map<String, Object[]> map = CriteriaConverter.criteria2ParamsMap(request.getCriteria());
        Object[] nullList = {-1};
        List<List> courseAndPersonnelCountList = personnelCoursePassedNAReportViewDAO.getPersonnelCountByPriority(
                map.get("courseCode") == null ? nullList : map.get("courseCode"),
                map.get("courseCode") == null ? 1 : 0,
                map.get("personnelPersonnelNo") == null ? nullList : map.get("personnelPersonnelNo"),
                map.get("personnelPersonnelNo") == null ? 1 : 0,
                map.get("postGradeId") == null ? nullList : map.get("postGradeId"),
                map.get("postGradeId") == null ? 1 : 0,
                map.get("personnelCompanyName") == null ? null : (String) map.get("personnelCompanyName")[0],
                map.get("personnelCcpArea") == null ? null : (String) map.get("personnelCcpArea")[0],
                map.get("personnelCcpAssistant") == null ? null : (String) map.get("personnelCcpAssistant")[0],
                map.get("personnelCcpSection") == null ? null : (String) map.get("personnelCcpSection")[0],
                map.get("personnelCcpUnit") == null ? null : (String) map.get("personnelCcpUnit")[0],
                map.get("personnelCcpAffairs") == null ? null : (String) map.get("personnelCcpAffairs")[0],
                map.get("personnelCppTitle") == null ? null : (String) map.get("personnelCppTitle")[0]
        );

        courseAndPersonnelCountList.forEach(courseAndPersonnelCount -> {
            PersonnelCoursePassedNAReportViewDTO.Grid courseAndPersonnelCountDTO = new PersonnelCoursePassedNAReportViewDTO.Grid()
                    .setCourseId(Long.parseLong(courseAndPersonnelCount.get(0).toString()))
                    .setCourseCode(courseAndPersonnelCount.get(1).toString())
                    .setCourseTitleFa(courseAndPersonnelCount.get(2).toString())
                    .setTotalEssentialServicePersonnelCount(Integer.parseInt(courseAndPersonnelCount.get(3).toString()))
                    .setNotPassedEssentialServicePersonnelCount(Integer.parseInt(courseAndPersonnelCount.get(4).toString()))
                    .setTotalEssentialAppointmentPersonnelCount(Integer.parseInt(courseAndPersonnelCount.get(5).toString()))
                    .setNotPassedEssentialAppointmentPersonnelCount(Integer.parseInt(courseAndPersonnelCount.get(6).toString()))
                    .setTotalImprovingPersonnelCount(Integer.parseInt(courseAndPersonnelCount.get(7).toString()))
                    .setNotPassedImprovingPersonnelCount(Integer.parseInt(courseAndPersonnelCount.get(8).toString()))
                    .setTotalDevelopmentalPersonnelCount(Integer.parseInt(courseAndPersonnelCount.get(9).toString()))
                    .setNotPassedDevelopmentalPersonnelCount(Integer.parseInt(courseAndPersonnelCount.get(10).toString()));
            result.add(courseAndPersonnelCountDTO);
        });

        SearchDTO.SearchRs<PersonnelCoursePassedNAReportViewDTO.Grid> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setList(result);
        searchRs.setTotalCount((long) result.size());
        return searchRs;
    }
}
