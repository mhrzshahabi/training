/**
 * Author:    Mehran Golrokhi
 * Created:    1399.04.02
 * Description:  send sms with copper
 */
package com.nicico.training.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IMessageContactService;
import com.nicico.training.iservice.ISendMessageService;
import com.nicico.training.iservice.IViewActivePersonnelService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import com.nicico.training.service.sms.SmsFeignClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.minidev.json.JSONObject;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import response.SmsResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;


@RequiredArgsConstructor
@Service
@Slf4j
public class SendMessageService implements ISendMessageService {

    private final MessageContactDAO messageContactDAO;
    private final ClassStudentDAO classStudentDAO;
    private final ComplexDAO complexDAO;
    private final AffairsDAO affairsDAO;
    private final MessageContactLogDAO messageContactLogDAO;
    private final ModelMapper modelMapper;
    private final ClassStudentService classStudentService;
    private final EvaluationService evaluationService;
    private final IViewActivePersonnelService iViewActivePersonnelService;
    private final TeacherService teacherService;
    private final TclassService tclassService;
    private final ParameterService parameterService;
    private final ParameterValueService parameterValueService;
    private final MessageService messageService;
    private final SmsFeignClient smsFeignClient;
    private final IMessageContactService messageContactService;
    private final TclassDAO tclassDAO;
    private final MessageParameterDAO messageParameterDAO;

    @Value("${nicico.elsSmsUrl}")
    private String elsSmsUrl;

    @Override
    public List<String> syncEnqueue(String pid, Map<String, String> paramValMap, List<String> recipients,Long messageId,Long classId,Long objectId) {
        JSONObject json = new JSONObject();
        json.put("to", recipients);
        json.put("pid", pid);
        json.put("params", new JSONObject(paramValMap));

        try {
            SmsResponse res=   smsFeignClient.sendSms(json);
            if (messageId!=null){
                Optional<MessageContact> optionalMessage=  messageContactDAO.findFirstById(messageId);
                if (optionalMessage.isPresent() &&res.getReceivers().size()>0){
                    MessageContact message=optionalMessage.get();
                    message.setTrackingNumber(res.getReceivers().get(0).getTrackingNumber());
                    messageContactDAO.save(message);
                }
            }else {
                if (objectId!=null){
                    Message message =new Message();
                    message.setContextText("null");
                    message.setContextHtml("null");
                    message.setPId(pid);
                    message.setUserTypeId(702L);
                    message.setCountSend(0);
                    message.setInterval(0);
                    message.setTclassId(classId);
                    Message  saved=   messageService.save(message);
                    MessageContact messageContact =new MessageContact();
                    messageContact.setStatusId(588L);
                    messageContact.setObjectMobile(res.getReceivers().get(0).getNumber());
                    messageContact.setObjectType("ClassStudent");
                    messageContact.setObjectId(objectId);
                    messageContact.setMessageId(saved.getId());

                    messageContact.setTrackingNumber(res.getReceivers().get(0).getTrackingNumber());
                    messageContactDAO.save(messageContact);
                }


            }
            List<String> result = new ArrayList<>(recipients.size());
            recipients.forEach(p -> result.add(String.valueOf(System.currentTimeMillis())));
            return result;
        } catch (Exception e) {
            return null;
        }

//        return nimadSMSService.syncEnqueue(pid, paramValMap, recipients);

    }

    @Scheduled(cron = "0 0 9 * * ?", zone = "Asia/Tehran")
    @Transactional
    @Override
    public void scheduling() {

        List<MessageContactDTO.AllMessagesForSend> masterList = messageContactService.getAllMessageContactForSend();
        Integer cnt = masterList.size();

        for (int i = 0; i < cnt; i++) {
            Long classId=0L;
            Long id=0L;
            if (masterList.get(i).getObjectType().equals("ClassStudent")) {
                ClassStudent model = classStudentDAO.findById(masterList.get(i).getObjectId()).orElse(null);
                classId= model != null ? model.getTclassId() : 0L;
                id= model != null ? model.getId() : 0L;
                if (model != null && !model.getEvaluationStatusReaction().equals(1)) {
                    messageContactDAO.deleteById(masterList.get(i).getMessageContactId());
                }
            } else if (masterList.get(i).getObjectType().equals("Teacher")) {
                Tclass model = tclassDAO.findById(masterList.get(i).getClassId()).orElse(null);
                classId= model != null ? model.getId() : 0L;
                id= model != null ? model.getTeacherId() : 0L;

                if (model != null && !model.getEvaluationStatusReactionTeacher().equals(1)) {
                    messageContactDAO.deleteById(masterList.get(i).getMessageContactId());
                }
            }


            List<String> numbers = new ArrayList<>();
            numbers.add(masterList.get(i).getObjectMobile());

            Map<String, String> paramValMap = new HashMap<>();

            List<MessageParameter> listParameter = messageParameterDAO.findByMessageContactId(masterList.get(i).getMessageContactId());

            for (MessageParameter parameter : listParameter) {
                paramValMap.put(parameter.getName(), parameter.getValue());
            }

            try {
//job

                 List<String> returnMessage = syncEnqueue(masterList.get(i).getPid(), paramValMap, numbers,null,classId,id);
                Long returnMessageId = null;

                MessageContactLog log = new MessageContactLog();

                log.setMessageContactId(masterList.get(i).getMessageContactId());

                if (returnMessage == null) {
                    log.setErrorMessage("Error Exception");
                    log.setReturnMessageId(null);
                    messageContactLogDAO.save(log);
                } else {
                    try {
                        returnMessageId = Long.parseLong(returnMessage.get(0));
                        MessageContact messageContact = messageContactDAO.findById(masterList.get(i).getMessageContactId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

                        messageContact.setLastSentDate(new Date());
                        messageContact.setCountSent(messageContact.getCountSent() + 1);

                        messageContactDAO.save(messageContact);

                        log.setErrorMessage("");
                        log.setReturnMessageId(returnMessageId.toString());
                        messageContactLogDAO.save(log);

                    } catch (Exception ex) {
                        log.setErrorMessage(ex.getMessage());
                        log.setReturnMessageId(null);
                        messageContactLogDAO.save(log);
                    }
                }

                MessageContact messageContact = messageContactDAO.findById(masterList.get(i).getMessageContactId()).orElse(null);

                if (messageContact.getCountSent() >= masterList.get(i).getCountSend()) {
                    messageContactDAO.deleteById(messageContact.getId());
                } else {
                    if (log.getReturnMessageId() != null) {
                        messageContactDAO.updateAfterSendMessage((long) (messageContact.getCountSent() + 1), new Date(), messageContact.getId());
                    }
                }
            } catch (Exception ex) {

            }
        }
    }


    @Scheduled(cron = "0 30 17 1/1 * ?")
    @Transactional
    @Override
    public void sendSmsForUsers() throws IOException {

        log.info("send sms for scheduled");
        log.info("zaza");

        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("ClassConfig");


        int dayBeforeStartCourse = Integer.parseInt(Objects.requireNonNull(parameters.getResponse().getData().stream().filter(p -> p.getCode().equals("dayBeforeStartCourse")).findFirst().orElse(null)).getValue()) + 1;
        List<Object> list = classStudentDAO.findAllUserMobiles(DateUtil.todayDate(), DateUtil.convertMiToKh(LocalDate.now().plusDays(dayBeforeStartCourse).toString()));
        List<ClassStudentUser> classStudentUsers = new ArrayList<>();
        JSONObject json = new JSONObject();
        String data = "%prefix-full_name% %full-name%شما در دوره «%course-name%» ثبت نام شده اید. لطفا برای مشاهده جزئیات این دوره به آدرس %personnel-address% مراجعه فرمایید.%institute%واحد آموزش";
        json.put("message", data);
        json.put("link", "https://mobiles.nicico.com");
        json.put("maxRepeat", 0);
        json.put("timeBMessages", 1);
        json.put("type", Collections.singletonList("sms"));

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd");


        if (list.size() > 0) {
            classStudentUsers = new ArrayList<>(list.size());
            for (Object o : list) {
                Object[] arr = (Object[]) o;
                classStudentUsers.add(new ClassStudentUser(arr[0].toString(), (arr[1] == null ? "" : arr[1].toString()), arr[2].toString(), arr[3].toString()));
            }
        }
        for (ClassStudentUser classStudentUser : classStudentUsers) {
            LocalDate secondDate = LocalDate.parse(DateUtil.convertMiToKh(LocalDate.now().plusDays(-1).toString()), dtf);
            LocalDate courseStartDate = LocalDate.parse(classStudentUser.getStartDate(), dtf);

            long daysBetween = ChronoUnit.DAYS.between(secondDate, courseStartDate);
            if (daysBetween == dayBeforeStartCourse && null != classStudentUser.getMobile()) {
                json.put("classID", classStudentUser.getClassID());
                json.put("classStudentRegistered", Collections.singletonList(classStudentUser.getClassStudentRegistered()));
//                sendMessage(json.toString());
            }
        }


    }

    public ResponseEntity sendMessage(@RequestBody String data) throws IOException {
        List<Long> ids = new ArrayList<>();
        String type = "";
        String link = "";
        List<String> mobiles = new ArrayList<>();
        List<String> fullName = new ArrayList<>();
        List<String> prefixFullName = new ArrayList<>();
        List<String> nationalCode = new ArrayList<>();
        Long classId = null;
        String courseName = "";
        String genderTo = "";
        String fullNameTo = "";
        String courseStartDate = "";
        String courseEndDate = "";
        String institute = "";
        String department = "";
        String unit = "";
        String duration = "";
        String oMessage = "";
        int maxRepeat = 0;
        int timeBMessages = 0;
        ParameterValue parameterValue;

        ObjectMapper objectMapper = new ObjectMapper();

        JsonNode jsonNode = objectMapper.readTree(data);
        oMessage = jsonNode.get("message").asText("");
        maxRepeat = Integer.parseInt(jsonNode.get("maxRepeat").asText(""));
        timeBMessages = Integer.parseInt(jsonNode.get("timeBMessages").asText(""));
        link = jsonNode.get("link").asText("ثبت نشده");
        if (link == null || link.length() == 0)
            link = "ثبت نشده";
        TclassDTO.Info tclassDTO = null;
        if (jsonNode.has("classID")) {
            classId = jsonNode.get("classID").asLong();
            tclassDTO = tclassService.get(classId);
            courseName = tclassDTO.getCourse().getTitleFa();
            courseStartDate = tclassDTO.getStartDate();
            courseEndDate = tclassDTO.getEndDate();
            if (null != tclassDTO.getInstitute())
                institute = tclassDTO.getInstitute().getTitleFa();
            else
                institute = "ثبت نشده";
            if (null != tclassDTO.getComplexId())
                department = complexDAO.findById(tclassDTO.getComplexId() != null ? tclassDTO.getComplexId() : null).get().getTitle();
            else
                department = "ثبت نشده";
            if (null != tclassDTO.getHDuration())
                duration = tclassDTO.getHDuration().toString();
            else
                duration = "ثبت نشده";


            if (null != tclassDTO.getAffairsId())
                unit = affairsDAO.findById(tclassDTO.getAffairsId() != null ? tclassDTO.getAffairsId() : null).get().getTitle();
            else
                unit = "ثبت نشده";

        } ////////////////


        if (jsonNode.has("classStudent")) {        //ارزیابی فراگیران
            jsonNode = jsonNode.get("classStudent");
            type = "classStudent";

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    ids.add(objNode.asLong());
                }
            }
        } else if (jsonNode.has("classTeacher")) {   //ارزیابی استاد
            jsonNode = jsonNode.get("classTeacher");
            type = "classTeacher";

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    ids.add(objNode.asLong());
                }
            }
        } else if (jsonNode.has("classStudentRegistered")) { //کلاس  فراگیران
            jsonNode = jsonNode.get("classStudentRegistered");
            type = "classStudentRegistered";

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    ids.add(objNode.asLong());
                }
            }
        } else if (jsonNode.has("classTeacher2")) { //کلاس  استاد
            jsonNode = jsonNode.get("classTeacher2");
            type = "classTeacher2";

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    ids.add(objNode.asLong());
                }
            }
        } else if (jsonNode.has("classStudentHaventEvaluation")) { //ارزیابی رفتاری
            jsonNode = jsonNode.get("classStudentHaventEvaluation");
            type = "behavioral";

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    ids.add(objNode.asLong());
                }
            }
        }


        if (ids.size() == 0) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
        if (oMessage.length() == 0) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } else {
            parameterValue = parameterValueService.getIdByDescription(oMessage);
        }

//

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        searchRq.setCount(1000);
        searchRq.setStartIndex(0);
        searchRq.setSortBy("id");
        searchRq.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));

        switch (type) {
            case "classStudent":
            case "classStudentRegistered": {
                SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));

                searchRs.getList().forEach(p -> {
                            mobiles.add(p.getStudent().getContactInfo().getSmSMobileNumber());
                            fullName.add(p.getFullName());
                            prefixFullName.add(p.getStudent().getGender() == null ? "جناب آقای/سرکار خانم" : (p.getStudent().getGender().equals("مرد") ? "جناب آقای" : (p.getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
                        }
                );
                break;
            }
            case "classTeacher":
            case "classTeacher2": {
                SearchDTO.SearchRs<TeacherDTO.Info> searchRs = teacherService.search(searchRq);

                searchRs.getList().forEach(p -> {
                            mobiles.add(p.getPersonality().getContactInfo().getMobile());
                            fullName.add(p.getFullName());
                            prefixFullName.add(p.getPersonality().getGenderId() == null ? "جناب آقای/سرکار خانم" : (p.getPersonality().getGenderId() == 1 ? "جناب آقای" : (p.getPersonality().getGenderId() == 2 ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
                        }
                );
                break;
            }
            case "behavioral": {
                SearchDTO.SearchRs<EvaluationDTO.Info> searchRs = evaluationService.search(searchRq);

        if(searchRs.getList().size()>0){
            EvaluationDTO.Info evaluationDTO = modelMapper.map(searchRs.getList().get(0), EvaluationDTO.Info.class);
            tclassDTO=  tclassService.get(evaluationDTO.getClassId());
            courseName = tclassDTO.getCourse().getTitleFa();
            courseStartDate = tclassDTO.getStartDate();
            courseEndDate = tclassDTO.getEndDate();
            Optional<ClassStudent> classStudent = classStudentDAO.findById(evaluationDTO.getEvaluatedId());
if (classStudent.isPresent()){
    fullNameTo=classStudent.get().getStudent().getFirstName()+" "+classStudent.get().getStudent().getLastName();
    genderTo=classStudent.get().getStudent().getGender() == null ? "جناب آقای/سرکار خانم" : (classStudent.get().getStudent().getGender().equals("مرد") ? "جناب آقای" : (classStudent.get().getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم"));
 }else {
    genderTo="جناب آقای/سرکار خانم";
    fullNameTo="ثبت نشده";
}



        }

                searchRs.getList().forEach(p -> {
                            EvaluationDTO.Info info = modelMapper.map(p, EvaluationDTO.Info.class);
                            if (info.getEvaluatorTypeId() == 188L) {
                                Optional<ClassStudent> classStudent = classStudentDAO.findById(info.getEvaluatorId());
                                if (classStudent.isPresent() && classStudent.get().getStudent() !=null){
                                    mobiles.add(classStudent.get().getStudent().getContactInfo().getMobile());
                                    nationalCode.add(classStudent.get().getStudent().getNationalCode());
                            fullName.add(classStudent.get().getStudent().getFirstName()+" "+classStudent.get().getStudent().getLastName());
                            prefixFullName.add(classStudent.get().getStudent().getGender() == null ? "جناب آقای/سرکار خانم" : (classStudent.get().getStudent().getGender().equals("مرد") ? "جناب آقای" : (classStudent.get().getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
                                }
                             }else {
                                Optional<ViewActivePersonnel> classStudent = iViewActivePersonnelService.findById(info.getEvaluatorId());
                                if (classStudent.isPresent() ){
                                    mobiles.add(classStudent.get().getMobile());
                                    nationalCode.add(classStudent.get().getNationalCode());
                                    fullName.add(classStudent.get().getFirstName()+" "+classStudent.get().getLastName());
                                    prefixFullName.add(classStudent.get().getGender() == null ? "جناب آقای/سرکار خانم" : (classStudent.get().getGender().equals("مرد") ? "جناب آقای" : (classStudent.get().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
                                }
                            }


                        }
                );
                break;
            }
        }

        MessageDTO.Create oMessageModel = new MessageDTO.Create();

        oMessageModel.setContextText(oMessage);
        oMessageModel.setContextHtml(oMessage);

        oMessageModel.setUserTypeId(parameterValue.getId());
        oMessageModel.setInterval(0);
        oMessageModel.setCountSend(0);
        oMessageModel.setTclassId(classId);
        oMessageModel.setMessageContactList(new ArrayList<>());

        TotalResponse<ParameterValueDTO.Info> pIds = parameterService.getByCode("MessageContent");
        String textMessage = parameterValue.getDescription();

        oMessageModel.setPId(parameterValue.getValue());
        oMessageModel.setContextText(textMessage);
        oMessageModel.setContextHtml(" ");

        for (int i = 0; i < mobiles.size(); i++) {
            MessageContactDTO.Create messageContact = new MessageContactDTO.Create();
            messageContact.setObjectId(ids.get(i));

            String tmpLink = "";

            switch (type) {
                case "classStudent":
                case "classStudentRegistered":
                    messageContact.setObjectType("ClassStudent");
                    tmpLink = link;
                    break;
                case "classTeacher":
                case "classTeacher2":
                    messageContact.setObjectType("Teacher");
                    tmpLink = link;
                    break;
                    case "behavioral":
                    messageContact.setObjectType("behavioral");
                    tmpLink = link;
                    break;
            }

            messageContact.setObjectMobile(mobiles.get(i));

            List<MessageParameterDTO.Create> parameters = new ArrayList<>();


            switch (type) {
                case "classStudent":
                case "classTeacher":
                    parameters.add(new MessageParameterDTO.Create("mrms", prefixFullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("prefix-full_name", prefixFullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("username", fullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("full-name", fullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("classname", courseName));
                    parameters.add(new MessageParameterDTO.Create("course-name", courseName));
                    parameters.add(new MessageParameterDTO.Create("personnel-address", elsSmsUrl));
                    parameters.add(new MessageParameterDTO.Create("institute", institute));
                    parameters.add(new MessageParameterDTO.Create("url", elsSmsUrl));
                    break;
                case "classStudentRegistered":
                    parameters.add(new MessageParameterDTO.Create("mrms", prefixFullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("prefix-full_name", prefixFullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("username", fullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("full-name", fullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("classname", courseName));
                    parameters.add(new MessageParameterDTO.Create("course-name", courseName));
                    parameters.add(new MessageParameterDTO.Create("personnel-address", elsSmsUrl));
                    parameters.add(new MessageParameterDTO.Create("url", elsSmsUrl));
                    parameters.add(new MessageParameterDTO.Create("institute", institute));
                    parameters.add(new MessageParameterDTO.Create("duration", duration));
                    parameters.add(new MessageParameterDTO.Create("startdate", courseStartDate));
                    parameters.add(new MessageParameterDTO.Create("enddate", courseEndDate));
                    parameters.add(new MessageParameterDTO.Create("department", department));
                    parameters.add(new MessageParameterDTO.Create("unit", unit));
                    parameters.add(new MessageParameterDTO.Create("uurl", tmpLink));
                    break;
                case "classTeacher2":
                    parameters.add(new MessageParameterDTO.Create("mrms", prefixFullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("prefix-full_name", prefixFullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("username", fullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("full-name", fullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("classname", courseName));
                    parameters.add(new MessageParameterDTO.Create("course-name", courseName));
                    parameters.add(new MessageParameterDTO.Create("personnel-address", elsSmsUrl));
                    parameters.add(new MessageParameterDTO.Create("institute", institute));
                    parameters.add(new MessageParameterDTO.Create("url", elsSmsUrl));
                    parameters.add(new MessageParameterDTO.Create("duration", duration));
                    parameters.add(new MessageParameterDTO.Create("startdate", courseStartDate));
                    parameters.add(new MessageParameterDTO.Create("enddate", courseEndDate));
                    parameters.add(new MessageParameterDTO.Create("department", department));
                    parameters.add(new MessageParameterDTO.Create("unit", unit));
                    parameters.add(new MessageParameterDTO.Create("uurl", tmpLink));
                    break;
                    case "behavioral":
                    parameters.add(new MessageParameterDTO.Create("Kodmeli",nationalCode.get(i) ));
                    parameters.add(new MessageParameterDTO.Create("url", elsSmsUrl));
                    parameters.add(new MessageParameterDTO.Create("GensiatM", fullName.get(i)));
                    parameters.add(new MessageParameterDTO.Create("GensiatF", genderTo));
                    parameters.add(new MessageParameterDTO.Create("NameM",prefixFullName.get(i) ));
                    parameters.add(new MessageParameterDTO.Create("NameF", fullNameTo));
                    parameters.add(new MessageParameterDTO.Create("Dore",courseName ));
                    parameters.add(new MessageParameterDTO.Create("Tarikh1",courseStartDate ));
                    parameters.add(new MessageParameterDTO.Create("Tarikh2", courseEndDate));
                    break;
            }


            messageContact.setMessageParameterList(convertMessageParameterToMapV2(parameters, parameterValue.getDescription()));

            oMessageModel.getMessageContactList().add(messageContact);
        }

        MessageDTO.Info result = messageService.create(oMessageModel);

        for (int i = 0; i < mobiles.size(); i++) {

            List<String> numbers = new ArrayList<>();
            numbers.add(mobiles.get(i));

            MessageContact messageContact = messageContactDAO.findById(result.getMessageContactList().get(i).getId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            List<String> returnMessage = syncEnqueue(parameterValue.getValue(), convertMessageParameterToMap(oMessageModel.getMessageContactList().get(i).getMessageParameterList(), parameterValue.getDescription()), numbers,messageContact.getId(),result.getTclassId(),null);
            Long returnMessageId = null;

            MessageContactLog log = new MessageContactLog();

            log.setMessageContactId(messageContact.getId());

            if (returnMessage == null) {
                log.setErrorMessage("Error Exception");
                log.setReturnMessageId(null);
                messageContactLogDAO.save(log);
            } else {
                try {
                    returnMessageId = Long.parseLong(returnMessage.get(0));
//                    messageContact.setLastSentDate(new Date());
//                    messageContact.setCountSent(messageContact.getCountSent() + 1);
//                    messageContactDAO.save(messageContact);

                    log.setErrorMessage("");
                    log.setReturnMessageId(returnMessageId.toString());
                    messageContactLogDAO.save(log);

                } catch (Exception ex) {
                    log.setErrorMessage(ex.getMessage());
                    log.setReturnMessageId(null);
                    messageContactLogDAO.save(log);
                }
            }
        }

        if (maxRepeat > 0) {

            if (type.equals("classStudent") || type.equals("behavioral")) {
                oMessageModel.setPId(parameterValue.getValue());
                oMessageModel.setContextText(parameterValue.getDescription());
                oMessageModel.setContextHtml(" ");
            }

            oMessageModel.setOrginalMessageId(result.getId());
            oMessageModel.setInterval(timeBMessages);
            oMessageModel.setCountSend(maxRepeat);

            messageService.create(oMessageModel);
        }

        return new ResponseEntity<>(HttpStatus.OK);
    }

    private Map<String, String> convertMessageParameterToMap(List<MessageParameterDTO.Create> model, String message) {

        int count = 0;

        for (int i = 0; i < message.length(); i++) {
            if (message.charAt(i) == '%')
                count++;
        }
        String[] parts = message.split("%");
        Map<String, String> parameters = new HashMap<>();

        for (int z = 0; z <= count; z++) {
            if (z % 2 != 0) {
                String data = parts[z];
                parameters.put(data.trim(), Objects.requireNonNull(model.stream().filter(p -> p.getName().equals(data.trim())).findFirst().orElse(null)).getValue());
            }

        }
        return parameters;

    }

    private List<MessageParameterDTO.Create>  convertMessageParameterToMapV2(List<MessageParameterDTO.Create> model, String message) {
        List<MessageParameterDTO.Create> convertData=new ArrayList<>();
        int count = 0;

        for (int i = 0; i < message.length(); i++) {
            if (message.charAt(i) == '%')
                count++;
        }
        String[] parts = message.split("%");
        Map<String, String> parameters = new HashMap<>();

        for (int z = 0; z <= count; z++) {
            if (z % 2 != 0) {
                String data = parts[z];
                convertData.add(new MessageParameterDTO.Create(data.trim(), Objects.requireNonNull(model.stream().filter(p -> p.getName().equals(data.trim())).findFirst().orElse(null)).getValue()));
            }
        }

      return   convertData;

    }
}
