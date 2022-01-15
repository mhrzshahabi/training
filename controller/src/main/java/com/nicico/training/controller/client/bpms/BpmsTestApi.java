package com.nicico.training.controller.client.bpms;

import com.nicico.bpmsclient.config.BPMSClientConfiguration;
import com.nicico.bpmsclient.model.flowable.base.BpmsResponse;
import com.nicico.bpmsclient.model.flowable.group.FlowableGroup;
import com.nicico.bpmsclient.model.flowable.process.*;
import com.nicico.bpmsclient.model.flowable.report.InstanceStateDTO;
import com.nicico.bpmsclient.model.flowable.task.TaskDetail;
import com.nicico.bpmsclient.model.flowable.task.TaskInfo;
import com.nicico.bpmsclient.model.request.*;
import com.nicico.bpmsclient.model.servicedef.CallerResultDTO;
import com.nicico.bpmsclient.model.servicedef.CallerStartDTO;
import feign.Response;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.Set;


@FeignClient(
        value = "BPMN-CLIENT",
        url = "http://staging.icico.net.ir/bpmn/api/v2",
        configuration = {BPMSClientConfiguration.class}
)
public interface BpmsTestApi {


    @PostMapping({"/tasks/search"})
    Object searchTask(@RequestBody TaskSearchDto taskSearchDto, @RequestParam int page, @RequestParam int size);


}
