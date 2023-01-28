package com.nicico.training.controller;


import com.nicico.copper.common.Loggable;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.Objects;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/hrm")
public class HrmClientController {

    @Autowired
    private RestTemplate restTemplate;

    @Value("${nicico.hrmBackend}")
    private String hrmUrl;

    @Loggable
    @GetMapping(value = "/jobHistory-by-nationalCode/{nationalCode}")
    public  ResponseEntity<ISC<HrmJobHistoryDto.SpecRs>> jobHistory(@PathVariable String nationalCode) {
        if (nationalCode!=null){
            String url = hrmUrl + "/post-persons/filter-by-criteria-custom";
            HttpEntity<HrmRequestDto> request = new HttpEntity<>(CreatHrmCriteria(nationalCode,"personnel.person.nationalCode"));
            try {
                ResponseEntity<HrmJobHistoryDto> data = restTemplate.exchange(url, HttpMethod.POST, request, HrmJobHistoryDto.class);
                ISC.Response<HrmJobDto> response = new ISC.Response<>();
                response.setStartRow(0);
                response.setEndRow(Objects.requireNonNull(data.getBody()).getList().size());
                response.setTotalRows(data.getBody().getTotalCount());
                response.setData(data.getBody().getList());
                ISC<HrmJobHistoryDto.SpecRs> infoISC = new ISC<>(response);
                return new ResponseEntity<>(infoISC, data.getStatusCode());


            }catch (Exception e){
                throw new TrainingException(TrainingException.ErrorType.Unauthorized, "خطا در دسترسی به سیستم منابع انسانی");

            }
        }else {
            throw new TrainingException(TrainingException.ErrorType.NotFound, "کد ملی وارد نشده است");

        }


    }
    @Loggable
    @GetMapping(value = "/postHistory-by-postCode")
    public ResponseEntity<ISC<HrmPostHistoryDto.SpecRs>> postHistory(HttpServletRequest req) {
        String postCode = req.getParameter("postCode");
        if (postCode!=null){
            String url = hrmUrl + "/post-persons/filter-by-criteria-custom";
            HttpEntity<HrmRequestDto> request = new HttpEntity<>(CreatHrmCriteria(postCode,"post.code"));
            try {
                ResponseEntity<HrmPostHistoryDto> data = restTemplate.exchange(url, HttpMethod.POST, request, HrmPostHistoryDto.class);

                ISC.Response<HrmJobDto> response = new ISC.Response<>();
                response.setStartRow(0);
                response.setEndRow(Objects.requireNonNull(data.getBody()).getList().size());
                response.setTotalRows(data.getBody().getTotalCount());
                response.setData(data.getBody().getList());
                ISC<HrmPostHistoryDto.SpecRs> infoISC = new ISC<>(response);
                return new ResponseEntity<>(infoISC, data.getStatusCode());

            }catch (Exception e){
                throw new TrainingException(TrainingException.ErrorType.Unauthorized, "خطا در دسترسی به سیستم منابع انسانی");

            }
        }else {
            throw new TrainingException(TrainingException.ErrorType.NotFound, "کد پست وارد نشده است");

        }


    }

    private HrmRequestDto CreatHrmCriteria(String value, String field) {
        HrmRequestDto hrmRequestDto = new HrmRequestDto();
        HrmCustomCriteria3 hrmCustomCriteria3 = new HrmCustomCriteria3();
        HrmCustomCriteria2 hrmCustomCriteria2 = new HrmCustomCriteria2();
        HrmCustomCriteria hrmCustomCriteria = new HrmCustomCriteria();
        hrmRequestDto.setCount(75);
        hrmRequestDto.setStartIndex(0);

        hrmCustomCriteria3.setOperator("equals");
        hrmCustomCriteria3.setFieldName(field);
        hrmCustomCriteria3.setValue(value);

        hrmCustomCriteria2.setCriteria(Collections.singletonList(hrmCustomCriteria3));
        hrmCustomCriteria2.setOperator("and");

        hrmCustomCriteria.setCriteria(Collections.singletonList(hrmCustomCriteria2));
        hrmCustomCriteria.setOperator("or");

        hrmRequestDto.setCriteria(hrmCustomCriteria);
        return hrmRequestDto;
    }


}