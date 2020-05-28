package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.TargetSocietyDTO;
import com.nicico.training.model.TargetSociety;
import com.nicico.training.service.TargetSocietyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/target-society")
public class TargetSocietyRestController {

    private final TargetSocietyService societyService;

    @Loggable
    @GetMapping("/getList")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getList(){
        List<TargetSocietyDTO.Info> infoList = new ArrayList<>();
        String [] titles = {"عمومی" ,"خصوصی","فاوا"};
        for(int i = 0;i < 3; i++) {
            TargetSocietyDTO.Info info = new TargetSocietyDTO.Info();
            info.setTitle(titles[i]);
            info.setSocietyId(new Long(i));
            infoList.add(info);
        }
        return new ResponseEntity<List<TargetSocietyDTO.Info>>(infoList, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/getListById/{id}")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getListById(@PathVariable Long id){
        return new ResponseEntity<List<TargetSocietyDTO.Info>>(societyService.getListById(id), HttpStatus.OK);
    }
}
