/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/09/08
 */

package com.nicico.training.controller;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.training.dto.ViewActivePersonnelDTO;
import com.nicico.training.service.TrainingFileNAReportService;
import com.nicico.training.service.ViewActivePersonnelService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

@RequiredArgsConstructor
@Controller
@RequestMapping("/training-file-na-report")
public class TrainingFileNAReportController {

    private final TrainingFileNAReportService trainingFileNAReportService;
    private final ViewActivePersonnelService personnelService;

    private final ModelMapper modelMapper;


    @GetMapping(value = {"/generate-report"})
    public void generateReport(@RequestParam MultiValueMap<String, String> criteria, final HttpServletResponse response) throws Exception {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        nicicoCriteria.set_startRow(null);

        List<ViewActivePersonnelDTO.Info> list = modelMapper.map(personnelService.search(nicicoCriteria).getResponse().getData(), new TypeToken<List<ViewActivePersonnelDTO.Info>>() {
        }.getType());

        trainingFileNAReportService.generateReport(response, list);


    }


}
