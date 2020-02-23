package com.nicico.training.controller;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.dto.unjustifiedAbsenceDTO;
import com.nicico.training.service.UnjustifiedAbsenceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import com.nicico.copper.common.util.date.DateUtil;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/unjustifiedAbsence")
public class unjustifiedAbsenceRestController {
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final UnjustifiedAbsenceService unjustifiedAbsenceService;



    @Loggable
    @GetMapping(value = "/spec-list/{startDate}/{endDate}")
    public ResponseEntity<unjustifiedAbsenceDTO.unjustifiedAbsenceSpecRs> list(@PathVariable String startDate,@PathVariable String endDate) throws Exception {

        List<unjustifiedAbsenceDTO.printScoreInfo> list;
        startDate = startDate.substring(0, 4) + "/" + startDate.substring(4, 6) + "/" + startDate.substring(6, 8);
        endDate = endDate.substring(0, 4) + "/" + endDate.substring(4, 6) + "/" + endDate.substring(6, 8);

        list = unjustifiedAbsenceService.print(startDate,endDate);

        final unjustifiedAbsenceDTO.SpecRs specResponse = new unjustifiedAbsenceDTO.SpecRs();
        final unjustifiedAbsenceDTO.unjustifiedAbsenceSpecRs specRs = new unjustifiedAbsenceDTO.unjustifiedAbsenceSpecRs();

        if (list != null) {
            specResponse.setData(list)
                    .setStartRow(0)
                    .setEndRow(list.size())
                    .setTotalRows(list.size());
            specRs.setResponse(specResponse);
        }

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = {"/print"})
    public void print(HttpServletResponse response, @RequestParam(value = "startDate") String startDate, @RequestParam(value = "endDate") String endDate)  throws Exception{

        startDate = startDate.substring(0, 4) + "/" + startDate.substring(4, 6) + "/" + startDate.substring(6, 8);
        endDate = endDate.substring(0, 4) + "/" + endDate.substring(4, 6) + "/" + endDate.substring(6, 8);

        Object object=unjustifiedAbsenceService.unjustified(startDate,endDate);
        String data = null;
        data = "{" + "\"unjustifiedAbsence\": " + objectMapper.writeValueAsString(object) + "}";
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/unjustified_absence.jasper", params, jsonDataSource, response);
    }

    @Loggable
    @PostMapping(value = {"/printPreTestScore"})
    public void prin(HttpServletResponse response, @RequestParam(value = "startDate") String startDate, @RequestParam(value = "endDate") String endDate)  throws Exception{

        startDate = startDate.substring(0, 4) + "/" + startDate.substring(4, 6) + "/" + startDate.substring(6, 8);
        endDate = endDate.substring(0, 4) + "/" + endDate.substring(4, 6) + "/" + endDate.substring(6, 8);

        Object object=unjustifiedAbsenceService.PreTestScore(startDate,endDate);
       String str=((List) object).toArray()[0].toString();

        String data = null;
        data = "{" + "\"PreTestScore\": " + objectMapper.writeValueAsString(object) + "}";
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
       // params.put("preTestScore",.);

        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/printPreTestScore.jasper", params, jsonDataSource, response);
    }
}
