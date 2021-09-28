package com.nicico.training.controller;

import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ICalendarService;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IPostService;
import com.nicico.training.mapper.calendar.CalendarBeanMapper;
import com.nicico.training.model.Calendar;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.service.ClassStudentReportService;
import com.nicico.training.service.NeedsAssessmentReportsService;
import com.nicico.training.service.ParameterService;
import com.nicico.training.service.TclassService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONArray;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "anonymous/api/Calendar")
public class CalendarRestController {

    private final ICalendarService calendarService;
    private final CalendarBeanMapper calendarBeanMapper;

    @Loggable
    @GetMapping(value = "/getAll")
    public ResponseEntity<List<CalendarDTO>> get() {
        List<Calendar> calendars=calendarService.getAllData();
        List<CalendarDTO> calendarDTOS=calendarBeanMapper.toCalendars(calendars);
        return new ResponseEntity<>(calendarDTOS, HttpStatus.OK);
    }


}
