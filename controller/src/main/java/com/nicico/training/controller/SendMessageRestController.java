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
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.QuestionnaireDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.service.ClassStudentService;
import com.nicico.training.service.PersonnelService;
import com.nicico.training.service.SendMessageService;
import com.nicico.training.service.TeacherService;
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

    @Loggable
    @PostMapping(value = "/sendSMS")
    public ResponseEntity sendSMS(@RequestBody String data) throws IOException {
        List<Long> classStudentIDs = new ArrayList<>();
        List<String> mobiles = new ArrayList<>();
        List<String> fullName = new ArrayList<>();
        List<String> prefixFullName = new ArrayList<>();
        String className = "";

        String oMessage = "";

        ObjectMapper objectMapper = new ObjectMapper();

        JsonNode jsonNode = objectMapper.readTree(data);
        oMessage = jsonNode.get("message").asText("");


        jsonNode = jsonNode.get("classStudent");

        if (jsonNode.isArray()) {
            for (final JsonNode objNode : jsonNode) {
                classStudentIDs.add(objNode.asLong());
            }
        }

        if (classStudentIDs.size() == 0) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }


        if(classStudentIDs.size()>0){
            SearchDTO.SearchRq searchRq =new SearchDTO.SearchRq();
            searchRq.setCount(1000);
            searchRq.setStartIndex(0);
            searchRq.setSortBy("id");
            searchRq.setCriteria(makeNewCriteria("id",classStudentIDs, EOperator.inSet,null));

            SearchDTO.SearchRs<ClassStudentDTO.ClassStudentInfo> searchRs = classStudentService.search(searchRq, c -> modelMapper.map(c, ClassStudentDTO.ClassStudentInfo.class));

            searchRs.getList().forEach(p->{
                mobiles.add(p.getStudent().getMobile());
                fullName.add(p.getFullName());
                prefixFullName.add(p.getStudent().getGender().equals("مرد")?"جناب آقای":(p.getStudent().getGender().equals("زن")?"سرکار خانم":"جناب آقای/سرکار خانم"));
            }
            );
            className=searchRs.getList().get(0).getTclass().getCourse().getTitleFa();
        }

        for (int i=0;i<mobiles.size();i++) {
            String message=oMessage;
            message=message.replace("{prefix-full_name}",prefixFullName.get(i));
            message=message.replace("{full-name}",fullName.get(i));
            message=message.replace("{class-name}",className);

            List<String> numbers=new ArrayList<>();
            numbers.add(mobiles.get(i));

            sendMessageService.asyncEnqueue(numbers, message);
        }

        return new ResponseEntity<>(HttpStatus.OK);
    }

}
