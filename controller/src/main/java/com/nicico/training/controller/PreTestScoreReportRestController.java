package com.nicico.training.controller;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.PreTestScoreReportDTO;
import com.nicico.training.iservice.IPreTestScoreReportService;
import com.nicico.training.service.PreTestScoreReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.nicico.copper.common.util.date.DateUtil;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/preTestScoreReport")
public class PreTestScoreReportRestController {
    private final DateUtil dateUtil;
    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final IPreTestScoreReportService iPreTestScoreReportService;



    @Loggable
    @GetMapping(value = "/spec-list/{startDate}/{endDate}")
    public ResponseEntity<PreTestScoreReportDTO.preTestScoreReportSpecRs> list(@PathVariable String startDate, @PathVariable String endDate) throws Exception {

        List<PreTestScoreReportDTO.printScoreInfo> list;
        startDate = startDate.substring(0, 4) + "/" + startDate.substring(4, 6) + "/" + startDate.substring(6, 8);
        endDate = endDate.substring(0, 4) + "/" + endDate.substring(4, 6) + "/" + endDate.substring(6, 8);

        list = iPreTestScoreReportService.print(startDate,endDate);

        final PreTestScoreReportDTO.SpecRs specResponse = new PreTestScoreReportDTO.SpecRs();
        final PreTestScoreReportDTO.preTestScoreReportSpecRs specRs = new PreTestScoreReportDTO.preTestScoreReportSpecRs();

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
    @PostMapping(value = {"/printPreTestScore"})
    public void prin(HttpServletResponse response, @RequestParam(value = "startDate") String startDate, @RequestParam(value = "endDate") String endDate)  throws Exception{

        startDate = startDate.substring(0, 4) + "/" + startDate.substring(4, 6) + "/" + startDate.substring(6, 8);
        endDate = endDate.substring(0, 4) + "/" + endDate.substring(4, 6) + "/" + endDate.substring(6, 8);
        Object object= iPreTestScoreReportService.print(startDate,endDate);
        String data = null;
        data = "{" + "\"PreTestScore\": " + objectMapper.writeValueAsString(object) + "}";
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE, "PDF");
        reportUtil.export("/reports/printPreTestScore.jasper", params, jsonDataSource, response);
    }
}
