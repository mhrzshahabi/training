package com.nicico.training.service.sms;

import net.minidev.json.JSONObject;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import response.SmsDeliveryResponse;
import response.SmsResponse;


@FeignClient(value = "trainingClient", url ="${nicico.sms}")
public interface SmsFeignClient {

    @RequestMapping(method = RequestMethod.POST, value = "/message/api/sms/nimad")
    SmsResponse sendSms(@RequestBody JSONObject request);

    @RequestMapping(method = RequestMethod.GET, value = "/message/api/sms/nimad/delivery/{id}")
    SmsDeliveryResponse delivery(@PathVariable String id);
}
