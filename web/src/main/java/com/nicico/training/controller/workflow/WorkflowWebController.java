package com.nicico.training.controller.workflow;
//test

import com.nicico.copper.activiti.domain.CustomFormProperty;
import com.nicico.copper.activiti.domain.ECustomFormPropertyType;
import com.nicico.copper.activiti.domain.iservice.IBusinessWorkflowEngine;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.form.FormProperty;
import org.activiti.engine.form.TaskFormData;
import org.activiti.engine.task.Task;
import org.activiti.image.impl.DefaultProcessDiagramGenerator;
import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.io.*;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Map;


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

    private final IBusinessWorkflowEngine businessWorkflowEngine;
    private final TaskService taskService;
    private final RepositoryService repositoryService;
    private final RuntimeService runtimeService;

    @Value("${nicico.rest-api.url}")
    private String restApiUrl;

    @Value("${nicico.dirs.upload-bpmn-img}")
    private String uploadDir;

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
    public String getUserCartableDetailFormFields(@PathVariable String id, @PathVariable String assignee, ModelMap modelMap) {
//        HttpHeaders headers = new HttpHeaders();
//        headers.add("Authorization", auth);
//        HttpEntity<String> request = new HttpEntity<String>(headers);
//
//        RestTemplate restTemplate = new RestTemplate();
//        ResponseEntity<ModelMap> modelMapFromRest = restTemplate.exchange(restApiUrl + "http://localhost:8080/evaluation/api/workflow/getUserCartableDetailForm/"+id +"/" + assignee, HttpMethod.GET, request, ModelMap.class);
//
//        ModelMap dummy = modelMapFromRest.getBody();
//
//        for (String s : dummy.keySet()) {
//            modelMap.addAttribute(s, dummy.get(s));
//        }


        TaskFormData taskFormData = businessWorkflowEngine.getTaskFormData(id);
        prepareTaskForm(modelMap, taskFormData);

        return "workflow/userCartableDetailForm";
    }


    @GetMapping(value = {"/getUserCartableDetailForm2/{id}"})
    public ResponseEntity<TaskFormData> getUserCartableDetailFormFields2(@PathVariable String id) {
        TaskFormData taskFormData = businessWorkflowEngine.getTaskFormData(id);
        return new ResponseEntity(taskFormData.getTask(), HttpStatus.OK);
    }


    @GetMapping(value = {"/getGroupCartableDetailForm/{id}"})
    public String getGroupTaskFormFields(@PathVariable String id, ModelMap modelMap) {
        return "workflow/groupCartableDetailForm";
    }

    @GetMapping(value = {"/getUserTaskHistoryForm/{id}"})
    public String getUserTaskHistoryForm(@PathVariable String id, ModelMap modelMap) {
        modelMap.remove("pId");
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
    public String processInstanceDiagram(@PathVariable String id, @RequestParam(value = "procDefId", defaultValue = "") String procDefId, ModelMap modelMap, @RequestParam("Authorization") String auth) {
        if (procDefId.equals("")) {
            procDefId = businessWorkflowEngine.getProcessInstanceById(id).getProcessDefinitionId();
        }


        List<Task> tasks = taskService.createTaskQuery().processInstanceId(id).list();
        BpmnModel bpmnModel = repositoryService.getBpmnModel(procDefId);
        DefaultProcessDiagramGenerator processDiagramGenerator = new DefaultProcessDiagramGenerator();
        InputStream definitionImageStream = processDiagramGenerator.generateDiagram(bpmnModel, "png", runtimeService.getActiveActivityIds(tasks.get(0).getExecutionId()));
        ByteArrayOutputStream baos = getByteArrayOutputStream(definitionImageStream);
//        return new ResponseEntity<>(baos.toByteArray(), HttpStatus.OK);
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.add("Authorization", auth);
//        headers.add("procDefId", procDefId);
//        HttpEntity<String> request = new HttpEntity<String>(headers);
//
//        RestTemplate restTemplate = new RestTemplate();
//
//        ResponseEntity<byte[]> processDiagram = restTemplate.exchange(restApiUrl + "http://localhost:8080/evaluation/api/workflow/processInstance/diagram/" + id, HttpMethod.GET, request, byte[].class);
        modelMap.addAttribute("diagramName", Base64.getEncoder().encodeToString(baos.toByteArray()));
        return "workflow/processDiagramForm";

    }

    @GetMapping(value = "/processDefinition/diagram/{id}")
    public String processDefinitionDiagram(@PathVariable String id, ModelMap modelMap) {
        InputStream processDiagram = repositoryService.getProcessDiagram(id);
//        return generateProcessDefinitionPng(id, modelMap, processDiagram);
        ByteArrayOutputStream baos = getByteArrayOutputStream(processDiagram);
        modelMap.addAttribute("diagramName", Base64.getEncoder().encodeToString(baos.toByteArray()));
        return "workflow/processDiagramForm";
    }


//    @GetMapping(value = "/processDefinition/diagram/{id}")
//	public String processDefinitionDiagram(@PathVariable String id, ModelMap modelMap, Authentication authentication,HttpSession session) {
//		String token = "";
//		final String token = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
//		if (authentication instanceof OAuth2AuthenticationToken) {
//			OAuth2AuthorizedClient client = authorizedClientService
//					.loadAuthorizedClient(
//							((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId(),
//							authentication.getName());
//			token = client.getAccessToken().getTokenValue();
//		}
//        HttpHeaders headers = new HttpHeaders();
//		headers.add("Authorization", "Bearer " + token);
//        HttpEntity<String> request = new HttpEntity<String>(headers);
//
//        RestTemplate restTemplate = new RestTemplate();
//		ResponseEntity<byte[]> processDiagram = restTemplate.exchange(restApiUrl + "/api/workflow/processDefinition/diagram/" + id, HttpMethod.GET, request, byte[].class);
//		modelMap.addAttribute("diagramName", Base64.getEncoder().encodeToString(processDiagram.getBody()));
//        return "workflow/processDiagramForm";
//    }

    private String generateProcessDefinitionPng(String id, ModelMap modelMap, InputStream definitionImageStream) {
        FileOutputStream stream = null;
        try {

            String filename = "snapshot-" + id.replace(":", "-") + ".png";
            modelMap.addAttribute("diagramName", filename);

            File file = new File(uploadDir);
            if (!file.exists()) {
                file.mkdirs();
            }
            stream = new FileOutputStream(uploadDir + "\\" + filename);
            int read = 0;
            byte[] bytes = new byte[1024];
            while ((read = definitionImageStream.read(bytes)) != -1) {
                stream.write(bytes, 0, read);
            }
            definitionImageStream.close();
            stream.close();
        } catch (Exception ex) {
            ex.printStackTrace();
            ex.getMessage();
        } finally {
            if (stream != null) {
                try {
                    stream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return "workflow/processDiagramForm";
    }

    @PostMapping(value = "/processDefinition/remove/{id}")
    @ResponseBody
    public String removeProcessDefinition(@PathVariable String id, @RequestParam("Authorization") String auth) {
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

    private void prepareTaskForm(ModelMap modelMap, TaskFormData taskFormData) {
        List<CustomFormProperty> formProperties = new ArrayList<CustomFormProperty>();
        fillFormProperties(formProperties, taskFormData.getFormProperties());

        modelMap.addAttribute("formProperties", formProperties);
        modelMap.addAttribute("id", taskFormData.getTask().getId());
        modelMap.addAttribute("title", taskFormData.getTask().getName());
        modelMap.addAttribute("assignee", taskFormData.getTask().getAssignee());
        if (taskFormData.getTask().getDescription() != null)
            modelMap.addAttribute("description", taskFormData.getTask().getDescription().replace("\\n", "<br/>"));
    }

    private void fillFormProperties(List<CustomFormProperty> formProperties, List<FormProperty> formProperties2) {
        StringEscapeUtils escapeUtils = new StringEscapeUtils();
        String[] tmp;
        for (int i = 0; i < formProperties2.size(); i++) {
            if (formProperties2.get(i).getValue() != null &&
                    formProperties2.get(i).getValue().equals("doNotRender101"))
                continue;
            CustomFormProperty formProperty = new CustomFormProperty();
            formProperty.setId(formProperties2.get(i).getId());
            formProperty.setName(formProperties2.get(i).getName());
            formProperty.setWidth("500");
            formProperty.setIsReadable(formProperties2.get(i).isReadable());
            formProperty.setIsWritable(formProperties2.get(i).isWritable());
            formProperty.setIsRequired(formProperties2.get(i).isRequired());

            formProperty.setValue(escapeUtils.escapeJava(formProperties2.get(i).getValue()));
            formProperty.setObjectType(setType(formProperties2.get(i).getType().getName()));


            Map<String, String> values = null;
            if (formProperties2.get(i).getType() != null && formProperties2.get(i).getType().getInformation("values") != null)
                values = (Map<String, String>) formProperties2.get(i).getType().getInformation("values");

            if (values != null) {
                StringBuilder stringBuilder = new StringBuilder();
                formProperty.setObjectType(ECustomFormPropertyType.SelectItem.name());
                if (!formProperties2.get(i).getId().startsWith("Tbl") && !formProperties2.get(i).getId().startsWith("re")) {


                    int j = 0;
                    for (Map.Entry<String, String> enumEntry : values.entrySet()) {
                        // Add value and label (if any)
                        j++;
                        stringBuilder.append('"')
                                .append(enumEntry.getKey())
                                .append('"')
                                .append(':')
                                .append('"')
                                .append(enumEntry.getValue())
                                .append('"');
                        if (j < values.entrySet().size())
                            stringBuilder.append(',').append('\n');
                    }

                    formProperty.setListValues(stringBuilder.toString());
                } else {
                    int j = 0;
                    stringBuilder.append('{');
                    for (Map.Entry<String, String> enumEntry : values.entrySet()) {


                        if (!enumEntry.getKey().startsWith("SHOWPROPERTY")) {
                            j++;
                            if (!enumEntry.getValue().contains("$")) {
                                stringBuilder
                                        .append(enumEntry.getKey())
                                        .append(':')
                                        .append('\'')
                                        .append(enumEntry.getValue())
                                        .append('\'');
                            } else {

                                String propertyName = enumEntry.getKey();


                                String propertyForSearch = enumEntry.getValue().substring(2, enumEntry.getValue().length() - 1);
                                String propertyValue = null;
                                for (int k = 0; k < formProperties2.size(); k++) {
                                    if (formProperties2.get(k).getId().equalsIgnoreCase(propertyForSearch)) {
                                        propertyValue = formProperties2.get(k).getValue();
                                        break;

                                    }
                                }

                                if (propertyValue != null) {
                                    stringBuilder
                                            .append(propertyName)
                                            .append(':')
                                            .append('\'')
                                            .append(propertyValue)
                                            .append('\'');
                                }


                            }
                            if (j < values.entrySet().size())
                                stringBuilder.append(',');

                        } else {
                            String[] t = enumEntry.getKey().split("_");
                            if (t != null && t[1] != null) {
                                if (t[1].equalsIgnoreCase("multiple")) {
                                    formProperty.setMultiple(enumEntry.getValue());

                                } else if (t[1].equalsIgnoreCase("pickListCriteria")) {
                                    formProperty.setPickListCriteria("{" + enumEntry.getValue().replace("=", ":") + "}");
                                }
                                if (t[1].equalsIgnoreCase("height")) {
                                    formProperty.setHeight(enumEntry.getValue());

                                }
                                if (t[1].equalsIgnoreCase("width")) {
                                    formProperty.setWidth(enumEntry.getValue());

                                }
                                if (t[1].equalsIgnoreCase("type")) {
                                    if (enumEntry.getValue().startsWith("textArea")) {
                                        ECustomFormPropertyType customFormPropertyType = ECustomFormPropertyType.TextArea;
                                        formProperty.setObjectType(customFormPropertyType.toString());
                                    }
                                }
                            }

                        }

                    }

                    stringBuilder.append('}');
                    if (formProperty.getObjectType().equalsIgnoreCase("selectitem"))
                        formProperty.setListValues(stringBuilder.toString());
                }
            }

            formProperties.add(formProperty);
        }
    }

    private ByteArrayOutputStream getByteArrayOutputStream(InputStream processDiagram) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        BufferedInputStream bis = new BufferedInputStream(processDiagram);
        try {
            byte[] buffer = new byte[1024];
            Integer count = 0;
            while ((count = bis.read(buffer)) != -1) {
                baos.write(buffer, 0, count);
            }
            baos.close();
            bis.close();
        } catch (Exception ex) {
            ex.getMessage();
        }
        return baos;
    }

}
