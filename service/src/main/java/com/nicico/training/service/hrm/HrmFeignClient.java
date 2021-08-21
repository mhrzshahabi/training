package com.nicico.training.service.hrm;

import com.nicico.training.dto.HrmMobileListDTO;
import com.nicico.training.dto.HrmPersonDTO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;

@FeignClient(value = "hrmClient", url ="${nicico.hrmClient}")
public interface HrmFeignClient {

    @GetMapping("/persons/person/{nationalCode}")
    HrmPersonDTO getPersonByNationalCode(@PathVariable("nationalCode") String nationalCode, @RequestHeader("Authorization") String token);


    @PostMapping("/persons/mobiles-by-national-codes")
    HrmMobileListDTO.Response getMobilesByNationalCodes(@RequestBody HrmMobileListDTO.Request nationalCodes, @RequestHeader("Authorization") String token);

}
