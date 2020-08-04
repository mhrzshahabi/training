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
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Tclass;
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

    @Loggable
    @PostMapping(value = "/sendSMS")
    public ResponseEntity sendSMS(final HttpServletRequest request, @RequestBody String data) throws IOException {
        List<Long> ids = new ArrayList<>();
        String type = "";
        List<String> mobiles = new ArrayList<>();
        List<String> fullName = new ArrayList<>();
        List<String> prefixFullName = new ArrayList<>();
        String personleAdress = request.getRequestURL().toString().replace(request.getServletPath(), "");
        Long classId;
        String courseName = "";
        String courseStartDate = "";
        String courseEndDate = "";
        String oMessage = "";

        ObjectMapper objectMapper = new ObjectMapper();

        JsonNode jsonNode = objectMapper.readTree(data);
        oMessage = jsonNode.get("message").asText("");

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
        }else if (jsonNode.has("classStudentHaventEvaluation")) {
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


        if (type == "classStudent") {
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
        } else if (type == "classTeacher") {
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
        } else if (type == "classStudentHaventEvaluation") {
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
        }

        for (int i = 0; i < mobiles.size(); i++) {
            String message = oMessage;
            message = message.replace("{prefix-full_name}", prefixFullName.get(i));
            message = message.replace("{full-name}", fullName.get(i));
            message = message.replace("{course-name}", courseName);
            message = message.replace("{start-date}", courseStartDate);
            message = message.replace("{end-date}", courseEndDate);
            message = message.replace("{personel-address}", personleAdress);
            message += "\nواحد ارزیابی امور آموزش";

            List<String> numbers = new ArrayList<>();
            numbers.add(mobiles.get(i));

            sendMessageService.asyncEnqueue(numbers, message);
        }

        return new ResponseEntity<>(HttpStatus.OK);
    }

}
