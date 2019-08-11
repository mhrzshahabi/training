package com.nicico.training.controller.workflow;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.nio.charset.Charset;
import java.util.Base64;


/*
Author : p-dodangeh
 Date: 1/2/2019
 Time: 3:56 PM

*/

@Controller
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/web/workflow")
public class WorkflowWebController {
	private final OAuth2AuthorizedClientService authorizedClientService;

    @Autowired
    Environment environment;

    @Value("${nicico.rest-api.url}")
    private String restApiUrl;

    @GetMapping("/processDefinition/showForm")
    public String showProcessDefinitionList() {
        return "workflow/processDefinitionForm";
    }

    @GetMapping("/processInstance/showForm")
    public String showProcessInstanceList() {
        return "workflow/processInstanceForm";
    }

    @GetMapping("/userCartable/showForm")
    public String showUserCartable() {
        return "workflow/userCartableForm";
    }

    @GetMapping("/groupCartable/showForm")
    public String showGroupCartable() {
        return "workflow/groupCartableForm";
    }


    @GetMapping(value = {"/getUserCartableDetailForm/{id}/{assignee}"})
    public String getUserCartableDetailFormFields(@PathVariable String id, @PathVariable String assignee, ModelMap modelMap, @RequestParam("Authorization") String auth) {
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", auth);
        HttpEntity<String> request = new HttpEntity<String>(headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<ModelMap> modelMapFromRest = restTemplate.exchange(restApiUrl + "/api/workflow/getUserCartableDetailForm/"+id +"/" + assignee, HttpMethod.GET, request, ModelMap.class);

        ModelMap dummy = modelMapFromRest.getBody();

        for (String s : dummy.keySet()) {
            modelMap.addAttribute(s, dummy.get(s));
        }

        return "workflow/userCartableDetailForm";
    }

    @GetMapping(value = {"/getGroupCartableDetailForm/{id}"})
    public String getGroupTaskFormFields(@PathVariable String id, ModelMap modelMap) {
        return "workflow/groupCartableDetailForm";
    }

    @GetMapping(value = {"/getUserTaskHistoryForm/{id}"})
    public String getUserTaskHistoryForm(@PathVariable String id, ModelMap modelMap) {
        modelMap.addAttribute("pId", id);
        return "workflow/processInstanceHistoryDetailForm";
    }

    @GetMapping(value = {"/getProcessDefinitionDetailForm/{id}"})
    public String getProcessDefinitionFormFields(@PathVariable String id, ModelMap modelMap, @RequestParam("Authorization") String auth) {
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", auth);
        HttpEntity<String> request = new HttpEntity<String>(headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<ModelMap> modelMapFromRest = restTemplate.exchange(restApiUrl + "/api/workflow/getProcessDefinitionDetailForm/" + id, HttpMethod.GET, request, ModelMap.class);

        ModelMap dummy = modelMapFromRest.getBody();

        for (String s : dummy.keySet()) {
            modelMap.addAttribute(s, dummy.get(s));
        }

        return "workflow/processDefinitionDetailForm";

    }

    @GetMapping(value = {"/getProcessInstanceDetailForm/{id}"})
    public String getProcessInstanceFormFields(@PathVariable String id, ModelMap modelMap) {
        return "workflow/processInstanceDetailForm";

    }


    @GetMapping(value = "/processInstance/diagram/{id}")
    public String processInstanceDiagram(@PathVariable String id, @RequestParam(value = "procDefId", defaultValue = "") String procDefId, ModelMap modelMap,@RequestParam("Authorization") String auth) {
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", auth);
        headers.add("procDefId", procDefId);
        HttpEntity<String> request = new HttpEntity<String>(headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<byte[]> processDiagram = restTemplate.exchange(restApiUrl + "/api/workflow/processInstance/diagram/" + id, HttpMethod.GET, request, byte[].class);
        modelMap.addAttribute("diagramName",  Base64.getEncoder().encodeToString(processDiagram.getBody()));
        return "workflow/processDiagramForm";

    }


    @GetMapping(value = "/processDefinition/diagram/{id}")
	public String processDefinitionDiagram(@PathVariable String id, ModelMap modelMap, Authentication authentication) {
		String token = "";
		if (authentication instanceof OAuth2AuthenticationToken) {
			OAuth2AuthorizedClient client = authorizedClientService
					.loadAuthorizedClient(
							((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId(),
							authentication.getName());
			token = client.getAccessToken().getTokenValue();
		}
        HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + token);
        HttpEntity<String> request = new HttpEntity<String>(headers);

        RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<byte[]> processDiagram = restTemplate.exchange(restApiUrl + "/api/workflow/processDefinition/diagram/" + id, HttpMethod.GET, request, byte[].class);
		modelMap.addAttribute("diagramName", Base64.getEncoder().encodeToString(processDiagram.getBody()));
        return "workflow/processDiagramForm";
    }


    @RequestMapping(value = "/processDefinition/remove/{id}", method = RequestMethod.POST)
    @ResponseBody
    public String removeProcessDefinition(@PathVariable String id,@RequestParam("Authorization") String auth) {
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", auth);
        HttpEntity<String> request = new HttpEntity<String>(headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> res = restTemplate.exchange(restApiUrl + "/api/workflow/processDefinition/remove/" + id, HttpMethod.DELETE, request, String.class);


        return res.getBody();
    }


    @RequestMapping(value = "/startProcess", method = RequestMethod.POST)
    @ResponseBody
    public String startProcess(@RequestBody String data,
                               @RequestParam(value = "user", required = false) String user,
                               @RequestParam(value = "processKey", required = false) String processKey,
                               @RequestParam("Authorization") String auth) throws IOException {

        HttpHeaders headers = new HttpHeaders();


        headers.add("user", user);
        headers.add("processKey", processKey);
        headers.add("Authorization", auth);
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
        HttpEntity<String> request = new HttpEntity<String>(data, headers);

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters()
                .add(0, new StringHttpMessageConverter(Charset.forName("UTF-8")));
        ResponseEntity<String> res = restTemplate.exchange(restApiUrl + "/api/workflow/startProcess/", HttpMethod.POST, request, String.class);


        return res.getBody();


    }



        private String setType(String type) {
        return type;
    }

    @ExceptionHandler(value = {NullPointerException.class, NumberFormatException.class})
    public void workflowExceptionHandler(NullPointerException e) {

    }



}
