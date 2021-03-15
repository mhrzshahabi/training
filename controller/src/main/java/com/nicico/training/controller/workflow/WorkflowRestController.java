package com.nicico.training.controller.workflow;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import com.nicico.copper.activiti.domain.*;
import com.nicico.copper.activiti.domain.iservice.IBusinessWorkflowEngine;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
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
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.DeploymentBuilder;
import org.activiti.engine.task.Task;
import org.activiti.image.impl.DefaultProcessDiagramGenerator;
import org.apache.commons.lang3.StringEscapeUtils;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
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
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping("/api/workflow")
public class WorkflowRestController {

    private final FileUtil fileUtil;
    private final ObjectMapper objectMapper;
    private final TaskService taskService;
    private final RuntimeService runtimeService;
    private final RepositoryService repositoryService;
    private final IBusinessWorkflowEngine businessWorkflowEngine;

    @Value("${nicico.dirs.upload-bpmn}")
    private String bpmnUploadDir;

    @PostMapping(value = "/uploadProcessDefinition")
    public ResponseEntity uploadProcessDefinition(@RequestParam("file") MultipartFile file) {

        File uploadedFile = null;
        FileInputStream stream = null;
        if (!file.isEmpty()) {

            String fileName = file.getOriginalFilename();
            try {

                if (fileName != null && !fileName.substring(fileName.lastIndexOf('.')).equalsIgnoreCase(".bpmn"))
                    return new ResponseEntity<>(HttpStatus.NOT_ACCEPTABLE);

                uploadedFile = fileUtil.upload(file, bpmnUploadDir);
                stream = new FileInputStream(uploadedFile);
                DeploymentBuilder deployment = repositoryService.createDeployment().addInputStream(uploadedFile.getName(), stream);
                Deployment deployId = deployment.deploy();
                return new ResponseEntity<>(HttpStatus.OK);
            } catch (Exception e) {

                if (uploadedFile != null)
                {
                    boolean fileDeleted=   uploadedFile.delete();
                    System.out.println("file delete :"+ fileDeleted);
                }


                return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
            } finally {
                if (stream != null) {
                    try {
                        stream.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        } else
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @GetMapping(value = {"/processDefinition/list"})
    public ResponseEntity<TotalResponse<CustomProcessDefinition>> getProcessDefinitionList(final Map<String, Object> params, final HttpServletRequest httpRequest) {

        return getTotalResponseInJson(httpRequest, businessWorkflowEngine.getProcessDefinitionList());
    }

    @GetMapping(value = {"/allProcessInstance/list"})
    public ResponseEntity<TotalResponse<CustomProcessInstance>> getAllProcessInstanceList(final Map<String, Object> params, final HttpServletRequest httpRequest) {

        return getTotalResponseInJson(httpRequest, businessWorkflowEngine.getProcessInstance());
    }

    @GetMapping(value = "/groupTask/list")
    public ResponseEntity<TotalResponse<UserTask>> getGroupTasksWhichUserBelongsTo(HttpServletRequest req, @RequestParam(value = "roles", required = false) String roles) {

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
    public ResponseEntity<TotalResponse<UserTask>> getUserTasks(HttpServletRequest request, HttpServletResponse res,
                                                                @RequestParam(value = "usr", required = false) String usr) {
        List<UserTask> userTasksByName = businessWorkflowEngine.getUserTasks(usr);
        checkDescriptionTask(userTasksByName);
        Map resp = new HashMap() {{
            put("response", new HashMap() {{
                put("data", userTasksByName);
            }});
        }};

        return getTotalResponseInJson(request, userTasksByName);
//        return new ResponseEntity<>(resp,HttpStatus.OK);
    }


    @GetMapping(value = "/historyVal/list")
    public ResponseEntity<TotalResponse<String>> getHistoryVar(HttpServletRequest httpRequest, HttpServletResponse res,
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
            if (httpRequest.getParameter("_startRow") != null)
                startRow = new Integer(httpRequest.getParameter("_startRow"));
            else startRow = 0;
            if (httpRequest.getParameter("_endRow") != null)
                endRow = new Integer(httpRequest.getParameter("_endRow"));
            else endRow = 80;

            List<Object[]> list = businessWorkflowEngine.getHistoryVar(documentId);
//            List<JsonObject> jsonArr = resultSetConverter.toJsonArray(list, new String[]{"id", "crDate", "assignee", "recom", "documentId"});

            if (list != null && !list.isEmpty()) {
                totalRowsCount = list.size();
            }

            gridResponse.setStartRow(startRow);
            gridResponse.setEndRow(endRow);
            gridResponse.setStatus(0);
            gridResponse.setTotalRows(totalRowsCount);
//            gridResponse.setData(jsonArr);

            return new ResponseEntity<>(new TotalResponse<String>(gridResponse), HttpStatus.OK);
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    @GetMapping(value = "/TbluserRoleDS/list")
    public ResponseEntity<TotalResponse<String>> getTblUserRoleDS(HttpServletRequest httpRequest, HttpServletResponse res,
                                                                  @RequestParam(value = "roleName", required = false) String roleName) {

        int startRow;
        int endRow;
        Map<String, String> sortBy;
        int totalRowsCount = 0;


        try {
            if (roleName == null || roleName.equalsIgnoreCase(""))
                roleName = "_";

            GridResponse gridResponse = new GridResponse();

            if (httpRequest.getParameter("_startRow") != null)
                startRow = Integer.parseInt(httpRequest.getParameter("_startRow"));
            else startRow = 0;
            if (httpRequest.getParameter("_endRow") != null)
                endRow = new Integer(httpRequest.getParameter("_endRow"));
            else endRow = 8000;

            List<Object[]> list = businessWorkflowEngine.findUserRoles(roleName);

            if (list != null && !list.isEmpty()) {
                totalRowsCount = list.size();

            }

            gridResponse.setStartRow(startRow);
            gridResponse.setEndRow(endRow);
            gridResponse.setStatus(0);
            gridResponse.setTotalRows(totalRowsCount);

            return new ResponseEntity<>(new TotalResponse<String>(gridResponse), HttpStatus.OK);
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
    public ResponseEntity<TotalResponse<UserTask>> getUserTaskHistory(@PathVariable String pId, HttpServletRequest httpRequest) {
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
    public ResponseEntity<Void> startProcess(@RequestBody List<Map<String, Object>> params) throws Exception {

        for (Map<String, Object> param : params) {

            String processKey = String.valueOf(param.get("processKey"));
            if (businessWorkflowEngine.getProcessLatestVersionList(processKey).size() > 0) {
                String processId = businessWorkflowEngine.getProcessLatestVersionList(processKey).get(0).getId();
                businessWorkflowEngine.startProcessInstanceById(processId, param);
            }
            else
                return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        return new ResponseEntity<>(HttpStatus.OK);
    }

    @RequestMapping(value = "/exportProcessImage")
    public void viewPic(HttpServletRequest request, HttpServletResponse response, @RequestParam("processId") String processId) throws Exception {
        businessWorkflowEngine.getProcessDiagram(processId);
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
    public ResponseEntity<ModelMap> getUserCartableDetailFormFields(@PathVariable String id, ModelMap modelMap) {
        TaskFormData taskFormData = businessWorkflowEngine.getTaskFormData(id);
        prepareTaskForm(modelMap, taskFormData);
        return new ResponseEntity<>(modelMap, HttpStatus.OK);
    }

    private String setType(String type) {
        return type;
    }

    private Map getParamsFromFormData(String data) throws IOException {

        return objectMapper.readValue(data, Map.class);
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

    private <T> List<T> getJsonList(int startRow, int endRow, List<T> entityList) {

        List<T> data = new ArrayList<>();
        for (int j = startRow; j < endRow; j++) {
            try {
                data.add(entityList.get(j));
            } catch (Exception ex) {
            }
        }

        return data;
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

    private <T> ResponseEntity<TotalResponse<T>> getTotalResponseInJson(HttpServletRequest httpRequest, List<T> processList) {

        int endRow;
        int startRow;
        int totalRowsCount = 0;

        try {

            List<T> data = new ArrayList<>();
            GridResponse<T> gridResponse = new GridResponse<>();

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

            return new ResponseEntity<>(new TotalResponse<>(gridResponse), HttpStatus.OK);

        } catch (Exception ex) {

            ex.printStackTrace();
            return null;
        }
    }
}
