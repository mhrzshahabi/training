package com.nicico.training.controller;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SystemStatusDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@RestController
@RequestMapping("/api/system-status")
@RequiredArgsConstructor
public class SystemStatusRestController {

    @Value("${nicico.elsActuatorUrl}")
	private String elsActuatorUrl;
    @Value("${nicico.fmsActuatorUrl}")
    private String fmsActuatorUrl;
    @Value("${nicico.masterDataActuatorUrl}")
    private String masterDataActuatorUrl;

    private final ObjectMapper objectMapper;


    @GetMapping("/get-status")
    public ResponseEntity<ISC<SystemStatusDTO>> getAllSystemStatus(HttpServletRequest iscRq) throws IOException {

        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<SystemStatusDTO> searchRs = new SearchDTO.SearchRs<>();
        List<SystemStatusDTO> systemStatusDTOList = new ArrayList<>();

        String token = iscRq.getParameter("token");
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        SystemStatusDTO elsSystemStatusDTO = new SystemStatusDTO();
        ResponseEntity<String> elsResponse = restTemplate.exchange(elsActuatorUrl + "/health", HttpMethod.GET, entity, String.class);
        if (elsResponse.getStatusCode() == HttpStatus.OK) {
            elsSystemStatusDTO = objectMapper.readValue(elsResponse.getBody(), SystemStatusDTO.class);
        } else {
            elsSystemStatusDTO.setStatus("Down");
        }
        elsSystemStatusDTO.setSystemName("Els");
        systemStatusDTOList.add(elsSystemStatusDTO);


        SystemStatusDTO fmsSystemStatusDTO = new SystemStatusDTO();
        ResponseEntity<String> fmsResponse = restTemplate.exchange(fmsActuatorUrl + "/health", HttpMethod.GET, entity, String.class);
        if (fmsResponse.getStatusCode() == HttpStatus.OK) {
            fmsSystemStatusDTO = objectMapper.readValue(fmsResponse.getBody(), SystemStatusDTO.class);
        } else {
            fmsSystemStatusDTO.setStatus("Down");
        }
        fmsSystemStatusDTO.setSystemName("FMS");
        systemStatusDTOList.add(fmsSystemStatusDTO);


        SystemStatusDTO masterDataSystemStatusDTO = new SystemStatusDTO();
        ResponseEntity<String> masterDataResponse = restTemplate.exchange(masterDataActuatorUrl + "/health", HttpMethod.GET, entity, String.class);
        if (masterDataResponse.getStatusCode() == HttpStatus.OK) {
            masterDataSystemStatusDTO = objectMapper.readValue(masterDataResponse.getBody(), SystemStatusDTO.class);
        } else {
            masterDataSystemStatusDTO.setStatus("Down");
        }
        masterDataSystemStatusDTO.setSystemName("Master Data");
        systemStatusDTOList.add(masterDataSystemStatusDTO);


        searchRs.setTotalCount((long) systemStatusDTOList.size());
        searchRs.setList(systemStatusDTOList);
        ISC<SystemStatusDTO> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }
}
