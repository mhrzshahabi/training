package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.dto.PersonnelCourseNotPassedReportViewDTO;
import com.nicico.training.iservice.IClassStudentService;
import com.nicico.training.iservice.IPersonnelCourseNotPassedReportViewService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.function.Function;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/personnel-course-not-passed-report")
public class PersonnelCourseNotPassedReportViewRestController {

    private final IPersonnelCourseNotPassedReportViewService personnelCourseNotPassedReportViewService;
    private final ModelMapper modelMapper;
    private final IClassStudentService iClassStudentService;

    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, Function<E, T> converter) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (searchRq.getCriteria().getCriteria().size() > 0) {
            searchRq.getCriteria().getCriteria().removeIf(criteriaRq -> criteriaRq.getFieldName().equals("startDate") || criteriaRq.getFieldName().equals("endDate"));
        }
        searchRq.setSortBy("courseId");
        SearchDTO.SearchRs<T> searchRs = personnelCourseNotPassedReportViewService.search(searchRq, converter);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<PersonnelCourseNotPassedReportViewDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        ResponseEntity<ISC<PersonnelCourseNotPassedReportViewDTO.Info>> data = search(iscRq, p -> modelMapper.map(p, PersonnelCourseNotPassedReportViewDTO.Info.class));

        String startDate = null;
        String endDate = null;
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (searchRq.getCriteria().getCriteria().size() > 0) {
            Iterator<SearchDTO.CriteriaRq> criteriaRqIterator = searchRq.getCriteria().getCriteria().iterator();
            while (criteriaRqIterator.hasNext()) {

                SearchDTO.CriteriaRq criteriaRq = criteriaRqIterator.next();
                if (criteriaRq.getFieldName().equals("startDate")) {
                    startDate = criteriaRq.getValue().toString().replace("[","").replace("]","");
                }
                if (criteriaRq.getFieldName().equals("endDate")) {
                    endDate =  criteriaRq.getValue().toString().replace("[","").replace("]","");
                }
                criteriaRqIterator.remove();
            }
        }
        if (startDate != null && endDate != null) {
           return getDataWithCourseFilter(startDate,endDate,data);
        }
         return data;
    }

    private ResponseEntity<ISC<PersonnelCourseNotPassedReportViewDTO.Info>> getDataWithCourseFilter(String startDate, String endDate, ResponseEntity<ISC<PersonnelCourseNotPassedReportViewDTO.Info>> data) {
        List<Object> removeList=new ArrayList<>();
        List<String> nationalList=iClassStudentService.getStudentBetWeenRangeTime(startDate,endDate);
        for (Object z:data.getBody().getResponse().getData()){
            PersonnelCourseNotPassedReportViewDTO.Info info = modelMapper.map(z, PersonnelCourseNotPassedReportViewDTO.Info.class);
            boolean var = nationalList.stream().anyMatch(element -> info.getPersonnelNationalCode().equalsIgnoreCase(element));
            if (var)
                removeList.add(z);
        }
        data.getBody().getResponse().getData().removeAll(removeList);
        data.getBody().getResponse().setEndRow(data.getBody().getResponse().getStartRow()+data.getBody().getResponse().getData().size());
        return data;
    }

}