package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/teacherInformation")
public class TeacherInformationRestController {
    private final TclassService tclassService;
    private final TclassDAO tclassDAO;
    private final ModelMapper modelMapper;

    private <T> ResponseEntity<ISC<T>> search(HttpServletRequest iscRq, SearchDTO.CriteriaRq criteria,Class<T> infoClass) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(criteria);
        if (searchRq.getCriteria() != null)
            criteriaRq.getCriteria().add(searchRq.getCriteria());
        searchRq.setCriteria(criteriaRq);
        SearchDTO.SearchRs<T> searchRs = tclassService.search1(searchRq,infoClass);

        List<TclassDTO.teacherInfo> listTotal = new ArrayList(searchRs.getList());

        List<TclassDTO.teacherInfo> newList = new ArrayList<>();
        SearchDTO.SearchRs<TclassDTO.teacherInfo>  newList1=new SearchDTO.SearchRs<>();
        List<String> nationalCodeList = new ArrayList<>();


        for (int i = 0; i < listTotal.size(); i++) {
            if (!nationalCodeList.contains(listTotal.get(i).getTeacher().getPersonality().getNationalCode())) {
                nationalCodeList.add(listTotal.get(i).getTeacher().getPersonality().getNationalCode());
                newList.add(listTotal.get(i));
            }
        }
    newList1.setList(newList);
        newList1.setTotalCount((long) newList.size());
        SearchDTO.SearchRs<T> searchRs1 = (SearchDTO.SearchRs<T>) newList1;

        return new ResponseEntity<>(ISC.convertToIscRs(searchRs1, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/teacher-information-iscList/{courseCode}")
    public ResponseEntity<ISC<TclassDTO.teacherInfo>> scoresList(HttpServletRequest iscRq, @PathVariable String courseCode) throws IOException {
        return search(iscRq, makeNewCriteria("course.code", courseCode, EOperator.equals, null),TclassDTO.teacherInfo.class);
    }
    //, c -> modelMapper.map(c,TeacherDTO.Info.class)

}
