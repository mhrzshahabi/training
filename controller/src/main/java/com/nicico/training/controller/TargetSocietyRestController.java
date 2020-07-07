package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.dto.TargetSocietyDTO;
import com.nicico.training.model.TargetSociety;
import com.nicico.training.service.MasterDataService;
import com.nicico.training.service.ParameterValueService;
import com.nicico.training.service.TargetSocietyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/target-society")
public class TargetSocietyRestController {

    private final TargetSocietyService societyService;
    private final MasterDataService masterDataService;
    private final ParameterValueService parameterValueService;

    @Loggable
    @GetMapping("/getList")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getList(){
        List<TargetSocietyDTO.Info> infoList = new ArrayList<>();
        return new ResponseEntity<List<TargetSocietyDTO.Info>>(infoList, HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/getListById/{id}")
    public ResponseEntity<List<TargetSocietyDTO.Info>> getListById(@PathVariable Long id){
        Long type = parameterValueService.getId("single");
        Integer count = 0;
        try{
            String criteria = "{\"fieldName\":\"id\",\"operator\":\"inSet\",\"value\":[";//]}
            List<TargetSocietyDTO.Info> infoList = new ArrayList<>();
            Iterator<TargetSocietyDTO.Info> infoIterator = societyService.getListById(id).iterator();
            while (infoIterator.hasNext()){
                TargetSocietyDTO.Info info = infoIterator.next();
                if(type.equals(info.getTargetSocietyTypeId())) {
                    criteria += info.getSocietyId().toString();
                    if(infoIterator.hasNext()) {
                        criteria += ",";
                        count++;
                    }
                }else{
                    infoList.add(info);
                    if(criteria.substring(criteria.length()-1).equals(","))
                        criteria = criteria.substring(0,criteria.length()-2);
                }
            }
            criteria += "]}";
        List<MasterDataService.CompetenceWebserviceDTO> departments = masterDataService.getDepartmentsByParams(criteria,count.toString(),"and","0","");
        for(MasterDataService.CompetenceWebserviceDTO deparment : departments){
            TargetSocietyDTO.Info info = new TargetSocietyDTO.Info();
            info.setSocietyId(deparment.getId());
            info.setTitle(deparment.getTitle());
            info.setTargetSocietyTypeId(type);
            infoList.add(info);
        }
        return new ResponseEntity<List<TargetSocietyDTO.Info>>(infoList, HttpStatus.OK);
        }catch (IOException io){
            return null;
        }
    }
}
