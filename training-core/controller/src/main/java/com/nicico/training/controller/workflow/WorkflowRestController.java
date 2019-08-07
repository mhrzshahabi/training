package com.nicico.training.controller.workflow;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.nicico.copper.activiti.config.json.ResultSetConverter;
import com.nicico.copper.activiti.domain.*;
import com.nicico.copper.activiti.domain.iservice.IBusinessWorkflowEngine;
import com.nicico.copper.core.domain.util.GridResponse;
import com.nicico.copper.core.domain.util.TotalResponse;
import com.nicico.copper.core.util.file.FileUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.form.FormProperty;
import org.activiti.engine.form.StartFormData;
import org.activiti.engine.form.TaskFormData;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.activiti.image.impl.DefaultProcessDiagramGenerator;
import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/workflow")///api/workflow/uploadProcessDefinition
public class WorkflowRestController {


    private final Environment environment;
    private final ObjectMapper objectMapper;
    private final IBusinessWorkflowEngine businessWorkflowEngine;
    private final TaskService taskService;
    private final RepositoryService repositoryService;
    private final RuntimeService runtimeService;
    private final FileUtil fileUtil;
    private final ResultSetConverter resultSetConverter;

    @Value("${nicico.bpmn.upload.dir}")
    private String bpmnUploadDir;

    @PostMapping(value = "/uploadProcessDefinition")
    public ResponseEntity<Void> uploadProcessDefinition(@RequestParam("file") MultipartFile file) {
        File uploadedFile = null;

        if (!file.isEmpty()) {
            String fileName = file.getOriginalFilename();
            try {
                if (!fileName.substring(fileName.lastIndexOf('.')).equalsIgnoreCase(".bpmn"))
                    return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);

                uploadedFile = fileUtil.upload(file, bpmnUploadDir);
                repositoryService.createDeployment().addInputStream(uploadedFile.getName(), new FileInputStream(uploadedFile)).deploy();
                uploadedFile.delete();
                return new ResponseEntity<>(HttpStatus.OK);
            } catch (Exception e) {
                uploadedFile.delete();
                return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } else {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
    }

    @GetMapping(value = {"/processDefinition/list"})
    public String getProcessDefinitionList(final Map<String, Object> params, final HttpServletRequest httpRequest) {
        List<CustomProcessDefinition> processList = businessWorkflowEngine.getProcessDefinitionList();

        return getTotalResponseInJson(httpRequest, processList);
    }


    @GetMapping(value = {"/allProcessInstance/list"}, produces = "application/json;Charset=utf-8")
    public String getAllProcessInstanceList(final Map<String, Object> params, final HttpServletRequest httpRequest) {
        List<CustomProcessInstance> processList = businessWorkflowEngine.getProcessInstance();

        return getTotalResponseInJson(httpRequest, processList);
    }


    @GetMapping(value = "/groupTask/list")
    public String getGroupTasksWhichUserBelongsTo(HttpServletRequest req,
                                                  @RequestParam(value = "roles", required = false) String roles) {
        List<String> groupArr = new ArrayList<String>(Arrays.asList(roles.replace("[", "").replace("]", "").split(", ")));
        List<UserTask> userTasksByGroups = new ArrayList<>();
        if (groupArr.size() > 0) {
            userTasksByGroups = businessWorkflowEngine.getUserTasksByGroups(groupArr);
            checkDescriptionTask(userTasksByGroups);
        }
        return getTotalResponseInJson(req, userTasksByGroups);

    }

    private void checkDescriptionTask(List<UserTask> userTasksByGroups) {
        for (UserTask ut : userTasksByGroups) {
//            ut.setProcessVariables(businessWorkflowEngine.getProcessInstanceById(ut.getProcessInstanceId()).getVariableInstances());
        }
    }


    @GetMapping(value = "/userTask/list")
    public String getUserTasks(HttpServletRequest request, HttpServletResponse res,
                               @RequestParam(value = "usr", required = false) String usr) {
        List<UserTask> userTasksByName = businessWorkflowEngine.getUserTasks(usr);
        checkDescriptionTask(userTasksByName);

        return getTotalResponseInJson(request, userTasksByName);
    }

    @GetMapping(value = "/historyVal/list")
    public String getHistoryVar(HttpServletRequest httpRequest, HttpServletResponse res,
                                @RequestParam(value = "documentId", required = false) String documentId) {
        int startRow;
        int endRow;
        Map<String, String> sortBy;
        int totalRowsCount = 0;

        try {
            if (documentId == null || documentId.equalsIgnoreCase(""))
                documentId = "331594";
            List<JsonObject> data = new ArrayList<JsonObject>();

            GridResponse gridResponse = new GridResponse();
            TotalResponse totalResponse = new TotalResponse();
            if (httpRequest.getParameter("_startRow") != null)
                startRow = new Integer(httpRequest.getParameter("_startRow"));
            else startRow = 0;
            if (httpRequest.getParameter("_endRow") != null)
                endRow = new Integer(httpRequest.getParameter("_endRow"));
            else endRow = 80;

            List<Object[]> list = businessWorkflowEngine.getHistoryVar(documentId);
            List<JsonObject> jsonArr = resultSetConverter.toJsonArray(list, new String[]{"id", "crDate", "assignee", "recom", "documentId"});

            if (list != null && !list.isEmpty()) {
                totalRowsCount = list.size();
            }

            gridResponse.setStartRow(startRow);
            gridResponse.setEndRow(endRow);
            gridResponse.setStatus(0);
            gridResponse.setTotalRows(totalRowsCount);
            gridResponse.setData(jsonArr);
            totalResponse.setResponse(gridResponse);

            return objectMapper.writeValueAsString(totalResponse);
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }


    @GetMapping(value = "/TbluserRoleDS/list")
    public String getTblUserRoleDS(HttpServletRequest httpRequest, HttpServletResponse res,
                                   @RequestParam(value = "roleName", required = false) String roleName) {

        int startRow;
        int endRow;
        Map<String, String> sortBy;
        int totalRowsCount = 0;


        try {
            if (roleName == null || roleName.equalsIgnoreCase(""))
                roleName = "_";
            List<JsonObject> data = new ArrayList<JsonObject>();

            GridResponse gridResponse = new GridResponse();
            TotalResponse totalResponse = new TotalResponse();
            if (httpRequest.getParameter("_startRow") != null)
                startRow = new Integer(httpRequest.getParameter("_startRow"));
            else startRow = 0;
            if (httpRequest.getParameter("_endRow") != null)
                endRow = new Integer(httpRequest.getParameter("_endRow"));
            else endRow = 8000;

            List<Object[]> list = businessWorkflowEngine.findUserRoles(roleName);
            List<JsonObject> jsonArr = resultSetConverter.toJsonArray(list, new String[]{"assignee", "name", "roleDesc", "roleName", "id"});

            if (list != null && !list.isEmpty()) {
                totalRowsCount = list.size();

            }

            gridResponse.setStartRow(startRow);
            gridResponse.setEndRow(endRow);
            gridResponse.setStatus(0);
            gridResponse.setTotalRows(totalRowsCount);
            gridResponse.setData(jsonArr);
            totalResponse.setResponse(gridResponse);

            return objectMapper.writeValueAsString(totalResponse);
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }


    @GetMapping(value = "/userTask/count/{usr}")
    public ResponseEntity<String> getUserTasksCount(@PathVariable(value = "usr", required = false) String usr) {
        List<UserTask> userTasksByName = businessWorkflowEngine.getUserTasks(usr);


        return new ResponseEntity<>(String.valueOf(userTasksByName.size()), HttpStatus.OK);
    }


    @GetMapping("/userTaskHistory/list/{pId}")
    public String getUserTaskHistory(@PathVariable String pId, HttpServletRequest httpRequest) {
        List<UserTask> history = businessWorkflowEngine.getTaskInstanceHistory(pId);
        return getTotalResponseInJson(httpRequest, history);
    }

    @RequestMapping(value = "/doClaimTaskToUser", method = RequestMethod.POST)
    public String doClaimTaskToUser(HttpServletRequest req, HttpServletResponse res, @RequestBody String data,
                                    @RequestParam(value = "user", required = false) String user, @RequestParam(value = "taskId", required = false) String taskId) {
        businessWorkflowEngine.claimTask(taskId, user);

        return "success";
    }


    @RequestMapping(value = "/doUserTask", method = RequestMethod.POST)
    public String doUserTask(HttpSession session, HttpServletResponse res, @RequestBody String data,
                             @RequestParam(value = "usr", required = false) String user, @RequestParam(value = "taskId", required = false) String taskId) throws IOException {
        Map<String, Object> params = getParamsFromFormData(data);
        if (params.get("TblUserRoleCityDS_ERJA") != null)
            businessWorkflowEngine.setTaskAssignee(taskId, params.get("TblUserRoleCityDS_ERJA").toString());
        else
            businessWorkflowEngine.completeTask(taskId, params, user);
//        int cc = businessWorkflowEngine.getUserTasks(user).size();


        return "success";
    }


    @DeleteMapping(value = "/processDefinition/remove/{id}")
    public ResponseEntity<String> removeProcessDefinition(@PathVariable String id) {

        try {
            repositoryService.deleteDeployment(id);
            return new ResponseEntity<>("success", HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>("failed", HttpStatus.INTERNAL_SERVER_ERROR);
        }

    }

    @PostMapping(value = "/startProcess")
    public ResponseEntity<String> startProcess(@RequestBody String data,
                                               @RequestHeader(value = "user", required = false) String user,
                                               @RequestHeader(value = "processDefId", required = false) String processDefId,
                                               @RequestHeader(value = "processKey", required = false) String processKey) throws IOException {
        String processInstanceID = "";
        try {
            Map<String, Object> params = getParamsFromFormData(data);
            params.put("username", user);
//            if (processDefId == null && processKey != null) {
//                List<CustomProcessDefinition> processDefinitionList = businessWorkflowEngine.getProcessDefinitionList();
//                for (CustomProcessDefinition customProcessDefinition : processDefinitionList) {
//                    if (customProcessDefinition.getKey().equals(processKey)) {
//                        processDefId = customProcessDefinition.getId();
//
//                    }
//                }
//            }
//            if (processDefId != null) {
                ProcessInstance processInstance = businessWorkflowEngine
                        .startProcessInstanceById(
                                businessWorkflowEngine.getProcessLatestVersionList(processKey).get(0).getId(), params);
                processInstanceID = processInstance.getId();
//            } else
//                throw new Exception();
        } catch (Exception e) {
            return new ResponseEntity<String>("failed", HttpStatus.OK);
        }

        return new ResponseEntity<String>("success", HttpStatus.OK);
    }


    @RequestMapping(value = "/exportProcessImage")
    public void viewPic(HttpServletRequest request,
                        HttpServletResponse response,
                        @RequestParam("processId") String processId) throws Exception {
        businessWorkflowEngine.getProcessDiagram(processId);
    }


    public <T> List<JsonObject> getJsonList(int startRow, int endRow, List<T> entityList) {
        Gson gson = new Gson();
        List<JsonObject> data = new ArrayList<JsonObject>();
        for (int j = startRow; j < endRow; j++) {
            try {
                JsonElement element = gson.fromJson(gson.toJson(entityList.get(j)), JsonElement.class);
                data.add(element.getAsJsonObject());
            } catch (Exception ex) {
                System.out.println(ex.getMessage());
            }
        }

        return data;
    }

    private Map<String, Object> getParamsFromFormData(String data) {
        Gson gson = new Gson();
        Map<String, Object> params = gson.fromJson(data, Map.class);
//        data = data.replace("\"", "");
//        data = data.substring(1, data.length() - 1);
//        String[] split = data.split(",");
//        for (String s : split) {
//            String key=s.substring(0, s.indexOf(":"));
//                params.put(key, s.substring(s.indexOf(":") + 1));
//        }
        return params;
    }

    private <T> String getTotalResponseInJson(HttpServletRequest httpRequest, List<T> processList) {
        int startRow;
        int endRow;
        int totalRowsCount = 0;
        Gson gson = new Gson();

        try {


            List<JsonObject> data = new ArrayList<JsonObject>();

            GridResponse gridResponse = new GridResponse();
            TotalResponse totalResponse = new TotalResponse();

            startRow = new Integer(httpRequest.getParameter("_startRow"));
            endRow = new Integer(httpRequest.getParameter("_endRow"));


            if (processList != null && !processList.isEmpty()) {
                totalRowsCount = processList.size();
                data = getJsonList(startRow, Integer.min(endRow, totalRowsCount), processList);

            }

            gridResponse.setStartRow(startRow);
            gridResponse.setEndRow(endRow);
            gridResponse.setStatus(0);
            gridResponse.setTotalRows(totalRowsCount);
            gridResponse.setData(data);
            totalResponse.setResponse(gridResponse);

            return gson.toJson(totalResponse);

        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    @GetMapping(value = "/processInstance/diagram/{id}")
    public ResponseEntity<byte[]> processInstanceDiagram(@PathVariable String id, @RequestHeader(value = "procDefId", defaultValue = "") String procDefId, ModelMap modelMap) {

        if (procDefId.equals("")) {
            procDefId = businessWorkflowEngine.getProcessInstanceById(id).getProcessDefinitionId();
        }


        List<Task> tasks = taskService.createTaskQuery().processInstanceId(id).list();
        BpmnModel bpmnModel = repositoryService.getBpmnModel(procDefId);
        DefaultProcessDiagramGenerator processDiagramGenerator = new DefaultProcessDiagramGenerator();
        InputStream definitionImageStream = processDiagramGenerator.generateDiagram(bpmnModel, "png", runtimeService.getActiveActivityIds(tasks.get(0).getExecutionId()));
        ByteArrayOutputStream baos = getByteArrayOutputStream(definitionImageStream);
        return new ResponseEntity<>(baos.toByteArray(), HttpStatus.OK);
    }

    @GetMapping(value = "/processDefinition/diagram/{id}")
    public ResponseEntity<byte[]> processDefinitionDiagram(@PathVariable String id, ModelMap modelMap) {
        InputStream processDiagram = repositoryService.getProcessDiagram(id);
        ByteArrayOutputStream baos = getByteArrayOutputStream(processDiagram);
        return new ResponseEntity<>(baos.toByteArray(), HttpStatus.OK);
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

    @GetMapping(value = {"/getProcessDefinitionDetailForm/{id}"})
    public ResponseEntity<ModelMap> getProcessDefinitionFormFields(@PathVariable String id, ModelMap modelMap) {
        StartFormData processFormData = businessWorkflowEngine.getStartFormData(id);
        List<CustomFormProperty> formProperties = new ArrayList<CustomFormProperty>();

        fillFormProperties(formProperties, processFormData.getFormProperties());

        modelMap.addAttribute("formProperties", formProperties);
        modelMap.addAttribute("id", processFormData.getProcessDefinition().getId());
        modelMap.addAttribute("title", processFormData.getProcessDefinition().getName());
        modelMap.addAttribute("description", processFormData.getProcessDefinition().getDescription());
        modelMap.addAttribute("username", (SecurityContextHolder.getContext().getAuthentication().getPrincipal()));
        return new ResponseEntity<>(modelMap, HttpStatus.OK);

    }

    @GetMapping(value = {"/getUserCartableDetailForm/{id}/{assignee}"})
    public ResponseEntity<ModelMap> getUserCartableDetailFormFields(@PathVariable String id, @PathVariable String assignee, ModelMap modelMap) {
        TaskFormData taskFormData = businessWorkflowEngine.getTaskFormData(id);
        prepareTaskForm(modelMap, taskFormData);
        return new ResponseEntity<>(modelMap, HttpStatus.OK);
    }

    private String setType(String type) {
        return type;
    }

    private void fillFormProperties(List<CustomFormProperty> formProperties, List<FormProperty> formProperties2) {
        StringEscapeUtils escapeUtils = new StringEscapeUtils();
        String[] tmp;
        for (int i = 0; i < formProperties2.size(); i++) {
            if (formProperties2.get(i).getValue()!=null &&
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


}
