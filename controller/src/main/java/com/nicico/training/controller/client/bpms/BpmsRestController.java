package com.nicico.training.controller.client.bpms;


import com.nicico.bpmsclient.model.flowable.process.ProcessDefinitionRequestDTO;
import com.nicico.bpmsclient.service.BpmsClientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Slf4j
@RestController
@RequestMapping("/bpms")
@RequiredArgsConstructor
public class BpmsRestController {

    private final BpmsClientService client;

    @PostMapping({"/processes/definition-search"})
    public Object searchProcess(@RequestBody ProcessDefinitionRequestDTO processDefinitionRequestDTO, @RequestParam int page, @RequestParam int size) {
        return client.searchProcess(processDefinitionRequestDTO, page, size);
    }

//    @GetMapping({"/processes/definition-search"})
//    public String getProcessDefinitionKey() {
//        ProcessDefinitionRequestDTO processDefinitionRequestDTO = new ProcessDefinitionRequestDTO();
//        processDefinitionRequestDTO.setTenantId("Training");
//        Object object = client.searchProcess(processDefinitionRequestDTO, 0, 10);
//        List<?> list = (List<?>) object;
//        return "";
//    }

}
