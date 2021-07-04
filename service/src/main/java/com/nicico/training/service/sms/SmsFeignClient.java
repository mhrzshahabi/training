package com.nicico.training.service.sms;

import net.minidev.json.JSONObject;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import response.BaseResponse;


@FeignClient(value = "trainingClient", url ="${nicico.sms}")
public interface SmsFeignClient {

    @RequestMapping(method = RequestMethod.POST, value = "/message/api/sms/nimad")
    BaseResponse sendSms(@RequestBody JSONObject request);
}
