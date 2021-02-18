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
import com.nicico.copper.core.service.sms.nimad.NimadSMSService;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ISendMessageService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import com.nicico.training.service.sms.SmsFeignClient;
import lombok.RequiredArgsConstructor;
import net.minidev.json.JSONObject;
import org.modelmapper.ModelMapper;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import com.nicico.training.model.ClassStudentUser;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.service.ClassSessionService.getPersianDate;


@RequiredArgsConstructor
@Service
public class SendMessageService implements ISendMessageService {

    private final NimadSMSService nimadSMSService;
    private final MessageContactService messageContactService;
    private final MessageContactDAO messageContactDAO;
    private final MessageParameterDAO messageParameterDAO;
    private final ClassStudentDAO classStudentDAO;
    private final TclassDAO tclassDAO;
    private final MessageContactLogDAO messageContactLogDAO;
    private final ModelMapper modelMapper;
    private final ClassStudentService classStudentService;
    private final TeacherService teacherService;
    private final TclassService tclassService;
    private final ParameterService parameterService;
    private final MessageService messageService;
    private final SmsFeignClient smsFeignClient;
    private final Environment environment;

    @Override
    public List<String> syncEnqueue(String pid, Map<String, String> paramValMap, List<String> recipients) {
        JSONObject json = new JSONObject();
        json.put("to", recipients);
        json.put("pid", pid);
        json.put("params", new JSONObject(paramValMap));

        try {
            smsFeignClient.sendSms(json);
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

            if (masterList.get(i).getObjectType().equals("ClassStudent")) {
                ClassStudent model = classStudentDAO.findById(masterList.get(i).getObjectId()).orElse(null);

                if (model != null && !model.getEvaluationStatusReaction().equals(1)) {
                    messageContactDAO.deleteById(masterList.get(i).getMessageContactId());
                }
            } else if (masterList.get(i).getObjectType().equals("Teacher")) {
                Tclass model = tclassDAO.findById(masterList.get(i).getClassId()).orElse(null);

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

                List<String> returnMessage = syncEnqueue(masterList.get(i).getPid(), paramValMap, numbers);
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


    @Scheduled(cron = "0 0 15,10 * * *", zone = "Asia/Tehran")
    @Transactional
    @Override
    public void sendSmsForUsers() throws IOException {
        System.out.println("send sms for scheduled");
        System.out.println("zaza");

        int dayBeforeStartCourse = Integer.parseInt(Objects.requireNonNull(environment.getProperty("nicico.training.dayBeforeStartCourse")));
        List<Object> list = classStudentDAO.findAllUserMobiles(DateUtil.todayDate(), DateUtil.convertMiToKh(LocalDate.now().plusDays(dayBeforeStartCourse).toString()));
        List<ClassStudentUser> classStudentUsers = new ArrayList<>();
        JSONObject json = new JSONObject();
        String data = "%prefix-full_name% %full-name%شما در دوره «%course-name%» ثبت نام شده اید. لطفا برای مشاهده جزئیات این دوره به آدرس %personnel-address% مراجعه فرمایید.%institute%واحد آموزش";
        json.put("message", data);
        json.put("link", "http://mobiles.nicico.com");
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
            LocalDate secondDate = LocalDate.parse(DateUtil.convertMiToKh(LocalDate.now().plusDays(dayBeforeStartCourse).toString()), dtf);
            LocalDate courseStartDate = LocalDate.parse(classStudentUser.getStartDate(), dtf);

            long daysBetween = ChronoUnit.DAYS.between(courseStartDate, secondDate);
            if (daysBetween == dayBeforeStartCourse && null!=classStudentUser.getMobile()) {
                json.put("classID", classStudentUser.getClassID());
                json.put("classStudentRegistered", Collections.singletonList(classStudentUser.getClassStudentRegistered()));
//                sendMessage(json.toString());
            }
        }





    }

    public ResponseEntity sendMessage( @RequestBody String data) throws IOException {
        List<Long> ids = new ArrayList<>();
        String type = "";
        String link = "";
        List<String> mobiles = new ArrayList<>();
        List<String> fullName = new ArrayList<>();
        List<String> prefixFullName = new ArrayList<>();
//        String personelAddress = request.getRequestURL().toString().replace(request.getServletPath(), "");
        Long classId = null;
        String courseName = "";
        String courseStartDate = "";
        String courseEndDate = "";
        String institute = "";
        String oMessage = "";
        Integer maxRepeat = 0;
        Integer timeBMessages = 0;
        String code = null;
        String pid = "";

        TotalResponse<ParameterValueDTO.Info> parameter = null;

        ObjectMapper objectMapper = new ObjectMapper();

        JsonNode jsonNode = objectMapper.readTree(data);
        oMessage = jsonNode.get("message").asText("");
        maxRepeat = Integer.parseInt(jsonNode.get("maxRepeat").asText(""));
        timeBMessages = Integer.parseInt(jsonNode.get("timeBMessages").asText(""));
        link = jsonNode.get("link").asText("");

        if (jsonNode.has("classID")) {
            classId = jsonNode.get("classID").asLong();
            TclassDTO.Info tclassDTO = tclassService.get(classId);
            courseName = tclassDTO.getCourse().getTitleFa();
            courseStartDate = tclassDTO.getStartDate();
            courseEndDate = tclassDTO.getEndDate();
            if (null!=tclassDTO.getInstitute())
            institute = tclassDTO.getInstitute().getTitleFa();
            else
                institute = "ثبت نشده";
        }

        if (jsonNode.has("classStudent")) {
            jsonNode = jsonNode.get("classStudent");
            type = "classStudent";

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    ids.add(objNode.asLong());
                }
            }
        } else if (jsonNode.has("classTeacher")) {
            jsonNode = jsonNode.get("classTeacher");
            type = "classTeacher";

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    ids.add(objNode.asLong());
                }
            }
        } else if (jsonNode.has("classStudentRegistered")) {
            jsonNode = jsonNode.get("classStudentRegistered");
            type = "classStudentRegistered";

            if (jsonNode.isArray()) {
                for (final JsonNode objNode : jsonNode) {
                    ids.add(objNode.asLong());
                }
            }
        }

        if (ids.size() == 0) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }


        if (type.equals("classStudent")) {

            code = "CS";

            SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
            searchRq.setCount(1000);
            searchRq.setStartIndex(0);
            searchRq.setSortBy("id");
            searchRq.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));

            SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));

            searchRs.getList().forEach(p -> {
                        mobiles.add(p.getStudent().getMobile());
                        fullName.add(p.getFullName());
                        prefixFullName.add(p.getStudent().getGender() == null ? "جناب آقای/سرکار خانم" : (p.getStudent().getGender().equals("مرد") ? "جناب آقای" : (p.getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
                    }
            );
        } else if (type.equals("classTeacher")) {
            code = "Teacher";

            SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
            searchRq.setCount(1000);
            searchRq.setStartIndex(0);
            searchRq.setSortBy("id");
            searchRq.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));

            SearchDTO.SearchRs<TeacherDTO.Info> searchRs = teacherService.search(searchRq);

            searchRs.getList().forEach(p -> {
                        mobiles.add(p.getPersonality().getContactInfo().getMobile());
                        fullName.add(p.getFullName());
                        prefixFullName.add(p.getPersonality().getGenderId() == null ? "جناب آقای/سرکار خانم" : (p.getPersonality().getGenderId() == 1 ? "جناب آقای" : (p.getPersonality().getGenderId() == 2 ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
                    }
            );
        } else if (type.equals("classStudentRegistered")) {

            code = "CSR";

            SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
            searchRq.setCount(1000);
            searchRq.setStartIndex(0);
            searchRq.setSortBy("id");
            searchRq.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));

            SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));

            searchRs.getList().forEach(p -> {
                        mobiles.add(p.getStudent().getMobile());
                        fullName.add(p.getFullName());
                        prefixFullName.add(p.getStudent().getGender() == null ? "جناب آقای/سرکار خانم" : (p.getStudent().getGender().equals("مرد") ? "جناب آقای" : (p.getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم")));
                    }
            );
        }

        MessageDTO.Create oMessageModel = new MessageDTO.Create();

        oMessageModel.setContextText(oMessage);
        oMessageModel.setContextHtml(oMessage);

        parameter = parameterService.getByCode("MessageUserType");

        String finalCode = code;
        ParameterValueDTO.Info parameterValue = modelMapper.map(((TotalResponse) parameter).getResponse().getData().stream().filter(p -> ((ParameterValueDTO.Info) p).getCode().equals(finalCode)).toArray()[0], ParameterValueDTO.Info.class);

        oMessageModel.setUserTypeId(parameterValue.getId());
        oMessageModel.setInterval(0);
        oMessageModel.setCountSend(0);
        oMessageModel.setTclassId(classId);
        oMessageModel.setMessageContactList(new ArrayList<>());

        TotalResponse<ParameterValueDTO.Info> pIds = parameterService.getByCode("MessageContent");
        String textMessage = "";

        ParameterValueDTO.Info prmv;

        if (type.equals("classStudent")) {

            prmv = pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MCS1")).findFirst().orElseThrow(null);
            pid = prmv.getValue();
            textMessage = prmv.getDescription();

        } else if (type.equals("classTeacher")) {

            prmv = pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MTeacher")).findFirst().orElseThrow(null);
            pid = prmv.getValue();
            textMessage = prmv.getDescription();

        } else if (type.equals("classStudentRegistered")) {

            prmv = pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MCSR")).findFirst().orElseThrow(null);
            pid = prmv.getValue();
            textMessage = prmv.getDescription();

        }

        oMessageModel.setPId(pid);
        oMessageModel.setContextText(textMessage);
        oMessageModel.setContextHtml(" ");

        for (int i = 0; i < mobiles.size(); i++) {
            MessageContactDTO.Create messageContact = new MessageContactDTO.Create();
            messageContact.setObjectId(ids.get(i));

            String tmpLink = "";

            if (type.equals("classStudent")) {
                messageContact.setObjectType("ClassStudent");
                tmpLink = link;
            } else if (type.equals("classTeacher")) {
                messageContact.setObjectType("Teacher");
                tmpLink = link;
            } else if (type.equals("classStudentRegistered")) {
                messageContact.setObjectType("ClassStudent");
                tmpLink = link;
            }

            messageContact.setObjectMobile(mobiles.get(i));

            List<MessageParameterDTO.Create> parameters = new ArrayList<>();
            parameters.add(new MessageParameterDTO.Create("prefix-full_name", prefixFullName.get(i)));
            parameters.add(new MessageParameterDTO.Create("full-name", fullName.get(i)));
            parameters.add(new MessageParameterDTO.Create("course-name", courseName));

            if (type.equals("classStudent")) {
                parameters.add(new MessageParameterDTO.Create("personnel-address", tmpLink));
            } else if (type.equals("classTeacher")) {
                parameters.add(new MessageParameterDTO.Create("personnel-address", tmpLink));
            } else if (type.equals("classStudentRegistered")) {
                parameters.add(new MessageParameterDTO.Create("personnel-address", tmpLink));
                parameters.add(new MessageParameterDTO.Create("institute", institute));
            }

            messageContact.setMessageParameterList(parameters);

            oMessageModel.getMessageContactList().add(messageContact);
        }

        MessageDTO.Info result = messageService.create(oMessageModel);

        for (int i = 0; i < mobiles.size(); i++) {

            List<String> numbers = new ArrayList<>();
            numbers.add(mobiles.get(i));

            MessageContact messageContact = messageContactDAO.findById(result.getMessageContactList().get(i).getId()).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            List<String> returnMessage = syncEnqueue(pid, convertMessageParameterToMap(oMessageModel.getMessageContactList().get(i).getMessageParameterList()), numbers);
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
        }

        if (maxRepeat > 0) {

            if (type.equals("classStudent")) {
                pid = pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MCS2")).findFirst().orElseThrow(null).getValue();
                oMessageModel.setPId(pid);
                oMessageModel.setContextText(pIds.getResponse().getData().stream().filter(p -> p.getCode().equals("MCS2")).findFirst().orElseThrow(null).getDescription());
                oMessageModel.setContextHtml(" ");
            }

            oMessageModel.setOrginalMessageId(result.getId());
            oMessageModel.setInterval(timeBMessages);
            oMessageModel.setCountSend(maxRepeat);

            messageService.create(oMessageModel);
        }

        return new ResponseEntity<>(HttpStatus.OK);
    }

    private Map<String, String> convertMessageParameterToMap(List<MessageParameterDTO.Create> model) {
        Map<String, String> parameters = new HashMap<>();

        for (MessageParameterDTO.Create item : model) {
            parameters.put(item.getName(), item.getValue());
        }

        return parameters;
    }
}
