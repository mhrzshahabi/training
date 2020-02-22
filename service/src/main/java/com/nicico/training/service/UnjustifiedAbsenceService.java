package com.nicico.training.service;


import com.nicico.training.dto.unjustifiedAbsenceDTO;
import com.nicico.training.repository.unjustifiedAbsenceDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UnjustifiedAbsenceService  {
    private final  unjustifiedAbsenceDAO unjustifiedAbsenceDAO;
    public List<unjustifiedAbsenceDTO> unjustified(String startDate,String endDate)
    {
        List<Object> list = new ArrayList<>();
        list.addAll(unjustifiedAbsenceDAO.unjustified(startDate,endDate));
        List<unjustifiedAbsenceDTO> unjustifiedAbsenceDTOList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            Object[] arr = (Object[]) list.get(i);
              unjustifiedAbsenceDTOList.add(new unjustifiedAbsenceDTO(arr[0].toString(),arr[1].toString(),arr[2].toString(),arr[3].toString(),arr[4].toString(),arr[6].toString(),arr[7].toString(),arr[8].toString()));
        }
        return (unjustifiedAbsenceDTOList);
    }

    public List<unjustifiedAbsenceDTO.printScoreInfo> PreTestScore(String startDate, String endDate)
    {
        List<Object> list = new ArrayList<>();
        list.addAll(unjustifiedAbsenceDAO.printPreScore(startDate,endDate));
        List<unjustifiedAbsenceDTO.printScoreInfo> unjustifiedAbsenceDTOList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            Object[] arr = (Object[]) list.get(i);
            unjustifiedAbsenceDTO.printScoreInfo ff =new unjustifiedAbsenceDTO.printScoreInfo(arr[0].toString(),arr[1].toString(),arr[2].toString(),arr[3].toString(),arr[4].toString(),arr[5].toString(),arr[6].toString(),arr[7].toString(),arr[8].toString());
            unjustifiedAbsenceDTOList.add(ff);
        }
        return (unjustifiedAbsenceDTOList);
    }
}
