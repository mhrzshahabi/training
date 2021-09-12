package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.LoginLogDTO;
import com.nicico.training.iservice.ILoginLogService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/log/")
public class LogController {

    private final ModelMapper modelMapper;
    private final ILoginLogService iLoginLogService;

    @Loggable
    @GetMapping(value = "/user/list")
    public ResponseEntity<ISC<LoginLogDTO>> loginLog(HttpServletRequest iscRq) throws IOException, ParseException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = new GregorianCalendar();

        String startRq = (String) searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.greaterOrEqual)).collect(Collectors.toList()).get(0).getValue().get(0);
        String startGre = DateUtil.convertKhToMi1(startRq);
        Date startDate = dateFormat.parse(startGre);
        searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.greaterOrEqual)).collect(Collectors.toList()).get(0).setValue(startDate);

        String endRq = (String) searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.lessOrEqual)).collect(Collectors.toList()).get(0).getValue().get(0);
        String endGre = DateUtil.convertKhToMi1(endRq);
        Date endDate = dateFormat.parse(endGre);
        calendar.setTime(endDate);
        calendar.set(Calendar.HOUR, 11);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 59);
        calendar.set(Calendar.AM_PM, Calendar.PM);
        searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.lessOrEqual)).collect(Collectors.toList()).get(0).setValue(calendar.getTime());

        SearchDTO.SearchRs<LoginLogDTO> result = iLoginLogService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(result, searchRq.getStartIndex()), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/user/excelList")
    public ResponseEntity<ISC<LoginLogDTO.ExcelDTO>> loginLogExportExcel(HttpServletRequest iscRq) throws IOException, ParseException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = new GregorianCalendar();

        String startRq = (String) searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.greaterOrEqual)).collect(Collectors.toList()).get(0).getValue().get(0);
        String startGre = DateUtil.convertKhToMi1(startRq);
        Date startDate = dateFormat.parse(startGre);
        searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.greaterOrEqual)).collect(Collectors.toList()).get(0).setValue(startDate);

        String endRq = (String) searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.lessOrEqual)).collect(Collectors.toList()).get(0).getValue().get(0);
        String endGre = DateUtil.convertKhToMi1(endRq);
        Date endDate = dateFormat.parse(endGre);
        calendar.setTime(endDate);
        calendar.set(Calendar.HOUR, 11);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 59);
        calendar.set(Calendar.AM_PM, Calendar.PM);
        searchRq.getCriteria().getCriteria().stream().filter(a -> a.getOperator().equals(EOperator.lessOrEqual)).collect(Collectors.toList()).get(0).setValue(calendar.getTime());

        SearchDTO.SearchRs<LoginLogDTO> result = iLoginLogService.search(searchRq);
        List<LoginLogDTO> resultList = result.getList();
        List<LoginLogDTO.ExcelDTO> finalResultList = new ArrayList<>();
        resultList.forEach(res -> {
            String format = dateFormat.format(res.getCreateDate());
            String s = DateUtil.convertMiToKh(format);
            LoginLogDTO.ExcelDTO map = modelMapper.map(res, LoginLogDTO.ExcelDTO.class);
            map.setCreateDate(s);
            finalResultList.add(map);
        });

        ISC.Response<LoginLogDTO.ExcelDTO> response = new ISC.Response<>();
        response.setStartRow(0);
        response.setEndRow(finalResultList.size());
        response.setTotalRows(finalResultList.size());
        response.setData(finalResultList);
        ISC<LoginLogDTO.ExcelDTO> excelDTOISC = new ISC<>(response);
        return new ResponseEntity<>(excelDTOISC, HttpStatus.OK);
    }

}
