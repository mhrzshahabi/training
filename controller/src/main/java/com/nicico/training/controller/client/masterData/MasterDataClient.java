package com.nicico.training.controller.client.masterData;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import response.masterData.JobExpResponse;

import java.util.List;

@FeignClient(value = "masterDataClient", url ="${nicico.masterDataUrl}")
public interface MasterDataClient {

    @GetMapping("/emp-assignment/by-national-code/{nationalCode}")
    List<JobExpResponse> getJobExperiences(@PathVariable("nationalCode") String nationalCode, @RequestHeader("Authorization") String token);

    @GetMapping("/emp-assignment/by-post-code?postCode={postCode}")
    List<JobExpResponse> getPostRecords(@PathVariable("postCode") String postCode, @RequestHeader("Authorization") String token);
}
