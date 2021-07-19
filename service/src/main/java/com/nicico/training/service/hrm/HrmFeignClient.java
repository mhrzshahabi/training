package com.nicico.training.service.hrm;

import com.nicico.training.dto.HrmPersonDTO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;

@FeignClient(value = "hrmClient", url ="${nicico.hrmClient}")
public interface HrmFeignClient {

    @GetMapping("/persons/person/{nationalCode}")
    HrmPersonDTO getPersonByNationalCode(@PathVariable("nationalCode") String nationalCode, @RequestHeader("Authorization") String token);

}