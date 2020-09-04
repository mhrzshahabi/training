package com.nicico.training.controller;
import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.AnnualStatisticalReportDTO;
import com.nicico.training.model.AnnualStatisticalReport;
import com.nicico.training.repository.AnnualStatisticalReportDAO;
import com.nicico.training.service.AnnualStatisticalService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.tomcat.util.json.JSONParser;
import org.hibernate.validator.constraints.Length;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityManager;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/annualStatisticsReport")
public class AnnualRestController {
    private final ModelMapper modelMapper;
    private final AnnualStatisticalService annualStatisticalService;
    @Autowired
    EntityManager entityManager;

    @Loggable
    @GetMapping(value = "/list")
    @Transactional(readOnly = true)
    public ResponseEntity<AnnualStatisticalReportDTO.AnnualStatisticalReportDTOSpecRs> list(@RequestParam(value = "data") String data) {
        JSONObject jsonObject = new JSONObject(data);
        List<Object> list= new ArrayList<>();
        List<AnnualStatisticalReportDTO> DTOList = null;
        JSONParser parser = null;
        String startDate1 = null;

        String startDate2 = null;

        String endDate1 = null;

        String endDate2 = null;

        String courseCategory = null;

        String institute = null;

        String classYear = null;

        String termId = null;

        String Unit = null;

        String Affairs = null;

        String Assistant = null;

        String complex_MSReport = null;

        List<String> listYear = null;

        List<Long> listTerm = null;

        List<Long> listCategory = null;

        List<Long> listInstituteid = null;

        if (!jsonObject.isNull("startDate"))
            startDate1 = modelMapper.map(jsonObject.get("startDate"), String.class);

        if (!jsonObject.isNull("startDate2"))
            startDate2 = modelMapper.map(jsonObject.get("startDate2"), String.class);

        if (!jsonObject.isNull("endDate"))
            endDate1 = modelMapper.map(jsonObject.get("endDate"), String.class);

        if (!jsonObject.isNull("endDate2"))
            endDate2 = modelMapper.map(jsonObject.get("endDate2"), String.class);

        if (!jsonObject.isNull("institute"))
        {
            institute = modelMapper.map(jsonObject.get("institute"), String.class);
            String[] instituteid = institute.substring(1, institute.length() - 1).split(",");
            listInstituteid = Arrays.stream(instituteid).map(x -> Long.parseLong(x)).collect(Collectors.toList());
        }

        if (!jsonObject.isNull("category"))
        {
            courseCategory = modelMapper.map(jsonObject.get("category"), String.class);
            String[] Category = courseCategory.substring(1, courseCategory.length() - 1).split(",");
            listCategory = Arrays.stream(Category).map(x -> Long.parseLong(x)).collect(Collectors.toList());
        }

        if (!jsonObject.isNull("classYear"))
        {
            classYear = modelMapper.map(jsonObject.get("classYear"), String.class);
            Gson converter = new Gson();
            Type type = new TypeToken<List<String>>(){}.getType();
            listYear =  converter.fromJson(classYear, type );
        }
        if (!jsonObject.isNull("termId"))
        {
            termId = modelMapper.map(jsonObject.get("termId"), String.class);
            String[] term = termId.substring(1, termId.length() - 1).split(",");
            listTerm = Arrays.stream(term).map(x -> Long.parseLong(x)).collect(Collectors.toList());
        }
        if (!jsonObject.isNull("Unit"))
            Unit = modelMapper.map(jsonObject.get("Unit"), String.class);

        if (!jsonObject.isNull("Affairs"))
            Affairs = modelMapper.map(jsonObject.get("Affairs"), String.class);

        if (!jsonObject.isNull("Assistant"))
            Assistant = modelMapper.map(jsonObject.get("Assistant"), String.class);

        if (!jsonObject.isNull("complex_MSReport"))
            complex_MSReport = modelMapper.map(jsonObject.get("complex_MSReport"), String.class);

        list= Collections.singletonList(annualStatisticalService.list(listTerm != null ? listTerm : null, listYear != null ? listYear : null, complex_MSReport,listInstituteid != null ? listInstituteid: null, Assistant, Affairs,Unit, null, listCategory != null ? listCategory : null, startDate1, endDate1, startDate2, endDate2));

        if (list != null) {
            DTOList = new ArrayList<>(list.size());
            for (int i = 0; i < ((ArrayList) list.get(0)).size(); i++) {
                AnnualStatisticalReportDTO statisticalReportDTO = (AnnualStatisticalReportDTO)((ArrayList) list.get(0)).get(i);
                DTOList.add(statisticalReportDTO);
            }
        }
        List<AnnualStatisticalReportDTO.Info> response = DTOList != null ? modelMapper.map(DTOList, new TypeToken<List<AnnualStatisticalReportDTO.Info>>() {
        }.getType()) : null;

        final AnnualStatisticalReportDTO.SpecRs specResponse = new AnnualStatisticalReportDTO.SpecRs();
        final AnnualStatisticalReportDTO.AnnualStatisticalReportDTOSpecRs specRs = new AnnualStatisticalReportDTO.AnnualStatisticalReportDTOSpecRs();
        specResponse.setData(response)
                .setStartRow(0)
                .setEndRow(response.size())
                .setTotalRows(response.size());

        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }
}
