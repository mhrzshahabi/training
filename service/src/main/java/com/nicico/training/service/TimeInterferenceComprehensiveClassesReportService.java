package com.nicico.training.service;

import com.nicico.training.dto.TimeInterferenceComprehensiveClassesDTO;
import com.nicico.training.iservice.ITimeInterferenceComprehensiveClassesReportService;
import com.nicico.training.repository.TimeInterferenceComprehensiveClassesReportDAO;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TimeInterferenceComprehensiveClassesReportService implements ITimeInterferenceComprehensiveClassesReportService {
    private  final TimeInterferenceComprehensiveClassesReportDAO timeInterferenceDAO;

    @Override
    public List<TimeInterferenceComprehensiveClassesDTO> list(String startDate, String endDate) throws Exception {
        List<Object> objectResult;
        objectResult = timeInterferenceDAO.list(startDate, endDate);
//        objectResult = timeInterferenceDAO.list("1399/12/05", "1401/04/04");

        return  convertObject(objectResult);
    }

    private List<TimeInterferenceComprehensiveClassesDTO> convertObject(List<Object> objectResult)
                                                             {
        List<TimeInterferenceComprehensiveClassesDTO> result = new ArrayList<>();

        try {
            if (objectResult.size() > 0) {
                for (Object o : objectResult) {
                    Object[] arr = (Object[]) o;
                    TimeInterferenceComprehensiveClassesDTO timeInterferenceComprehensiveClassesDTO = new TimeInterferenceComprehensiveClassesDTO();
                    timeInterferenceComprehensiveClassesDTO.setCount_TimeInterference((int) Long.parseLong(arr[0].toString()));
                    timeInterferenceComprehensiveClassesDTO.setStudentFullName((String) arr[1]);
                    timeInterferenceComprehensiveClassesDTO.setNationalCode((String) arr[2]);
                    timeInterferenceComprehensiveClassesDTO.setStudentWorkCode((String) arr[3]);
                    timeInterferenceComprehensiveClassesDTO.setStudentAffairs((String) arr[4]);
                    timeInterferenceComprehensiveClassesDTO.setConcurrentCourses((String) arr[5]);
                    timeInterferenceComprehensiveClassesDTO.setClassCode((String) arr[6]);
                    timeInterferenceComprehensiveClassesDTO.setAddingUser((String) arr[7]);
                    timeInterferenceComprehensiveClassesDTO.setLastModifiedBy((String) arr[8]);
                    timeInterferenceComprehensiveClassesDTO.setSessionDate((String) arr[9]);
                    timeInterferenceComprehensiveClassesDTO.setSessionStartHour((String) arr[10]);
                    timeInterferenceComprehensiveClassesDTO.setSessionEndHour((String) arr[11]);
                    timeInterferenceComprehensiveClassesDTO.setSession_id(Long.valueOf((String) arr[12]));
                    timeInterferenceComprehensiveClassesDTO.setStudent_id(Long.valueOf((String) arr[13]));
                    timeInterferenceComprehensiveClassesDTO.setClass_student_d_created_date((String) arr[14]);
                    timeInterferenceComprehensiveClassesDTO.setClass_student_d_last_modified_date((String) arr[15]);


                    result.add(timeInterferenceComprehensiveClassesDTO);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
//    @Override
//    @Transactional(readOnly = true)
//    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
//        return SearchUtil.search(timeInterferenceDAO, request, converter);
//    }
}
