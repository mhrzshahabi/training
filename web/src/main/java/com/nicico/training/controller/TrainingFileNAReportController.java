/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/08
 * Last Modified: 2020/09/08
 */

package com.nicico.training.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.oauth.common.domain.CustomUserDetails;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IPersonnelCourseNotPassedReportViewService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.repository.PersonnelDAO;
import com.nicico.training.repository.PersonnelRegisteredDAO;
import com.nicico.training.repository.StudentClassReportViewDAO;
import com.nicico.training.service.*;
import com.nicico.training.utility.CriteriaConverter;
import lombok.RequiredArgsConstructor;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static net.minidev.json.parser.JSONParser.DEFAULT_PERMISSIVE_MODE;

@RequiredArgsConstructor
@Controller
@RequestMapping("/training-file-na-report")
public class TrainingFileNAReportController {

    private final TrainingFileNAReportService trainingFileNAReportService;
    private final ViewActivePersonnelService personnelService;

    private final ModelMapper modelMapper;


    @GetMapping(value = {"/generate-report"})
    public void generateReport(@RequestParam MultiValueMap<String, String> criteria,
                               final HttpServletResponse response) throws Exception {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        nicicoCriteria.set_startRow(null);

        List<ViewActivePersonnelDTO.Info> list = modelMapper.map(personnelService.search(nicicoCriteria).getResponse().getData(), new TypeToken<List<ViewActivePersonnelDTO.Info>>() {
        }.getType());

        trainingFileNAReportService.generateReport(response, list);


    }


}
