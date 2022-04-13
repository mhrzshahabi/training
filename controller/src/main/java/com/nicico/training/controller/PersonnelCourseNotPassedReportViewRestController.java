package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PersonnelCourseNotPassedReportViewDTO;
import com.nicico.training.iservice.IClassStudentService;
import com.nicico.training.iservice.IPersonnelCourseNotPassedReportViewService;
import com.nicico.training.model.TargetSociety;
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
import java.util.Objects;
import java.util.function.Function;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/personnel-course-not-passed-report")
public class PersonnelCourseNotPassedReportViewRestController {

    private final IPersonnelCourseNotPassedReportViewService personnelCourseNotPassedReportViewService;
    private final ModelMapper modelMapper;
    private final IClassStudentService iClassStudentService;

    private <E, T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, Function<E, T> converter, List<String> nationalCodes) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (searchRq.getCriteria().getCriteria().size() > 0) {
            searchRq.getCriteria().getCriteria().removeIf(criteriaRq -> criteriaRq.getFieldName().equals("startDate") || criteriaRq.getFieldName().equals("endDate"));
        }

        if (nationalCodes != null){
            List<SearchDTO.CriteriaRq> criteriaList = new ArrayList<>();

            criteriaList.add(makeNewCriteria("personnelNationalCode", nationalCodes, EOperator.notInSet, null));


            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, criteriaList);
            if (searchRq.getCriteria() != null) {
                if (searchRq.getCriteria().getCriteria() != null)
                    searchRq.getCriteria().getCriteria().add(criteriaRq);
                else
                    searchRq.getCriteria().setCriteria(criteriaList);
            } else {
                searchRq.setCriteria(criteriaRq);
            }
        }


        SearchDTO.SearchRs<T> searchRs = personnelCourseNotPassedReportViewService.search(searchRq, converter);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping
    public ResponseEntity<ISC<PersonnelCourseNotPassedReportViewDTO.Info>> list(HttpServletRequest iscRq) throws IOException {

        String startDate = null;
        String endDate = null;
        String personnelNos = null;
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (searchRq.getCriteria().getCriteria().size() > 0) {
            Iterator<SearchDTO.CriteriaRq> criteriaRqIterator = searchRq.getCriteria().getCriteria().iterator();
            while (criteriaRqIterator.hasNext()) {

                SearchDTO.CriteriaRq criteriaRq = criteriaRqIterator.next();
                if (criteriaRq.getFieldName().equals("startDate")) {
                    startDate = criteriaRq.getValue().toString().replace("[", "").replace("]", "");
                    criteriaRqIterator.remove();
                }
                if (criteriaRq.getFieldName().equals("endDate")) {
                    endDate = criteriaRq.getValue().toString().replace("[", "").replace("]", "");
                    criteriaRqIterator.remove();
                }
                if (criteriaRq.getFieldName().equals("personnelPersonnelNo")) {
                    personnelNos = criteriaRq.getValue().toString().replace("[", "").replace("]", "");
                }
            }
        }
        if (startDate != null && endDate != null) {
            List<String> nationalList = iClassStudentService.getStudentBetWeenRangeTime(startDate, endDate, personnelNos);
            return search(iscRq, p -> modelMapper.map(p, PersonnelCourseNotPassedReportViewDTO.Info.class), nationalList);

        }
        return search(iscRq, p -> modelMapper.map(p, PersonnelCourseNotPassedReportViewDTO.Info.class), null);

    }

}