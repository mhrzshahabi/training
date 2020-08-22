/**
 * Author:    Mehran Golrokhi
 * Created:    1399.04.02
 * Description:  send sms
 */
package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.MessageContactDAO;
import com.nicico.training.repository.MessageDAO;
import com.nicico.training.repository.ParameterValueDAO;
import com.nicico.training.repository.TclassDAO;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/sendMessage")
public class SendMessageRestController {

    private final ModelMapper modelMapper;
    private final SendMessageService sendMessageService;
    private final ClassStudentService classStudentService;
    private final TeacherService teacherService;
    private final PersonnelService personnelService;
    private final TclassService tclassService;
    private final ParameterService parameterService;
    private final MessageDAO messageDAO;
    private final MessageContactDAO messageContactDAO;
    private final ParameterValueDAO parameterValueDAO;

    @Loggable
    @PostMapping(value = "/sendSMS")
    public ResponseEntity sendSMS(final HttpServletRequest request, @RequestBody String data) throws IOException {
        List<Long> ids = new ArrayList<>();
        String type = "";
        List<String> mobiles = new ArrayList<>();
        List<String> fullName = new ArrayList<>();
        List<String> prefixFullName = new ArrayList<>();
        String personelAdress = request.getRequestURL().toString().replace(request.getServletPath(), "");
        Long classId = null;
        String courseName = "";
        String courseStartDate = "";
        String courseEndDate = "";
        String oMessage = "";
        Integer maxRepeat = 0;
        Integer timeBMessages = 0;
        String code = null;

        TotalResponse<ParameterValueDTO.Info> parameter = null;

        ObjectMapper objectMapper = new ObjectMapper();

        JsonNode jsonNode = objectMapper.readTree(data);
        oMessage = jsonNode.get("message").asText("");
        maxRepeat = Integer.parseInt(jsonNode.get("maxRepeat").asText(""));
        timeBMessages = Integer.parseInt(jsonNode.get("timeBMessages").asText(""));

        if (jsonNode.has("classID")) {
            classId = jsonNode.get("classID").asLong();
            TclassDTO.Info tclassDTO = tclassService.get(classId);
            courseName = tclassDTO.getCourse().getTitleFa();
            courseStartDate = tclassDTO.getStartDate();
            courseEndDate = tclassDTO.getEndDate();
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
        } else if (jsonNode.has("classStudentHaventEvaluation")) {
            jsonNode = jsonNode.get("classStudentHaventEvaluation");
            type = "classStudentHaventEvaluation";

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
                        prefixFullName.add(p.getStudent().getGender().equals("مرد") ? "جناب آقای" : (p.getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم"));
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
                        prefixFullName.add(p.getPersonality().getGenderId() == 1 ? "جناب آقای" : (p.getPersonality().getGenderId() == 2 ? "سرکار خانم" : "جناب آقای/سرکار خانم"));
                    }
            );
        } /*else if (type.equals("classStudentHaventEvaluation")) {
            code = "CSHE";

            SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
            searchRq.setCount(1000);
            searchRq.setStartIndex(0);
            searchRq.setSortBy("id");
            searchRq.setCriteria(makeNewCriteria("id", ids, EOperator.inSet, null));

            SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));

            searchRs.getList().forEach(p -> {
                        mobiles.add(p.getStudent().getMobile());
                        fullName.add(p.getFullName());
                        prefixFullName.add(p.getStudent().getGender().equals("مرد") ? "جناب آقای" : (p.getStudent().getGender().equals("زن") ? "سرکار خانم" : "جناب آقای/سرکار خانم"));
                    }
            );
        }*/

        Message oMessageModel = new Message();

        if (maxRepeat > 0) {

            oMessageModel.setContextText(oMessage);
            oMessageModel.setContextHtml(oMessage);

            parameter = parameterService.getByCode("MessageUserType");

            String finalCode = code;
            ParameterValueDTO.Info parameterValue = modelMapper.map(((TotalResponse) parameter).getResponse().getData().stream().filter(p -> ((ParameterValueDTO.Info) p).getCode().equals(finalCode)).toArray()[0], ParameterValueDTO.Info.class);

            oMessageModel.setUserTypeId(parameterValue.getId());
            List<ParameterValue> sentWays = new ArrayList<>();

            parameter = parameterService.getByCode("MessageSendWays");

            parameterValue = modelMapper.map(((TotalResponse) parameter).getResponse().getData().stream().filter(p -> ((ParameterValueDTO.Info) p).getCode().equals("sms")).toArray()[0], ParameterValueDTO.Info.class);

            sentWays.add(parameterValueDAO.findById(parameterValue.getId()).orElse(null));

            oMessageModel.setSendWays(sentWays);
            oMessageModel.setInterval(timeBMessages);
            oMessageModel.setCountSend(maxRepeat);
            oMessageModel.setTclassId(classId);

            messageDAO.save(oMessageModel);
        }
        for (int i = 0; i < mobiles.size(); i++) {
            String message = oMessage;
            message = message.replace("{prefix-full_name}", prefixFullName.get(i));
            message = message.replace("{full-name}", fullName.get(i));
            message = message.replace("{course-name}", courseName);
            message = message.replace("{start-date}", courseStartDate);
            message = message.replace("{end-date}", courseEndDate);
            message = message.replace("{personel-address}", personelAdress);
            message += "\nواحد ارزیابی امور آموزش";

            List<String> numbers = new ArrayList<>();
            numbers.add(mobiles.get(i));

            Long messageId = sendMessageService.asyncEnqueue(numbers, message);

            if (maxRepeat > 0) {

                MessageContact messageContact = new MessageContact();
                messageContact.setCountSent(0);
                messageContact.setContextText(message);
                messageContact.setContextHtml(message);
                messageContact.setLastSentDate(new Date());
                messageContact.setReturnMessageId(messageId);
                messageContact.setStatusId((long) 588);

                messageContact.setObjectId(ids.get(i));

                if (type.equals("classStudent")) {
                    messageContact.setObjectType("ClassStudent");
                } else if (type.equals("classTeacher")) {
                    messageContact.setObjectType("Teacher");
                }

                messageContact.setObjectMobile(mobiles.get(i));
                messageContact.setMessageId(oMessageModel.getId());
                messageContactDAO.save(messageContact);
            }
        }

        return new ResponseEntity<>(HttpStatus.OK);
    }

}
