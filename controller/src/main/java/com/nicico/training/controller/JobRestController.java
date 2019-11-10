/*
ghazanfari_f, 8/29/2019, 11:41 AM
*/
package com.nicico.training.controller;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.service.JobService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/job/")
public class JobRestController {

    private final JobService jobService;

    @GetMapping("list")
    public ResponseEntity<List<JobDTO.Info>> list() {
        return new ResponseEntity<>(jobService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "iscList")
    public ResponseEntity<TotalResponse<JobDTO.Info>> list(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(jobService.search(nicicoCriteria), HttpStatus.OK);
    }

    @PostMapping("print/{type}")
    public ResponseEntity printJob() {

        return null;
    }

    @PostMapping("/printWithCriteria/{type}")
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String type) {
        System.out.println(request);
        return null;
/*//		String token = (String) request.getSession().getAttribute(ConstantVARs.ACCESS_TOKEN);
        String token = request.getParameter("myToken");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/course/printWithCriteria/PDF", HttpMethod.POST, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/course/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/course/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
        else
            return null;*/
    }

}
