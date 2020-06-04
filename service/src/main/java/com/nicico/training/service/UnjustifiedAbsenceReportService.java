package com.nicico.training.service;

import com.nicico.training.dto.PreTestScoreReportDTO;
import com.nicico.training.dto.unjustifiedAbsenceReportDTO;
import com.nicico.training.iservice.IUnjustifiedAbsenceReportService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UnjustifiedAbsenceReportService implements IUnjustifiedAbsenceReportService {
    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper mapper;
    @Transactional
    @Override
    public List<unjustifiedAbsenceReportDTO> print(String startDate, String endDate) throws Exception{
        StringBuilder stringBuilder=new StringBuilder().append("SELECT DISTINCT\n" +
                "              tbl_session.c_session_date,\n" +
                "                tbl_student.last_name,\n" +
                "                tbl_student.first_name,\n" +
                "                tbl_class.c_title_class,\n" +
                "                tbl_class.c_start_date, \n" +
               "                tbl_class.c_end_date,\n" +
                "                tbl_class.c_code,\n" +
                "                tbl_session.c_session_end_hour,\n" +
                "                tbl_session.c_session_start_hour,\n" +
                "                tbl_session.c_session_state\n" +
                "            FROM\n" +
                "                tbl_attendance\n" +
                "                INNER JOIN tbl_session ON tbl_session.id = tbl_attendance.f_session\n" +
                "                INNER JOIN tbl_class ON tbl_class.id = tbl_session.f_class_id\n" +
                "                INNER JOIN tbl_student ON tbl_student.id = tbl_attendance.f_student\n" +
                "            WHERE\n" +
                "                tbl_attendance.c_state = '3'\n" +
                "                AND   tbl_class.c_start_date >= :startDate \n" +
                "            AND   tbl_class.c_end_date <= :endDate order by  tbl_class.c_title_class, tbl_student.last_name, tbl_student.first_name");
        List<Object> list=new ArrayList<>();
        list= (List<Object>) entityManager.createNativeQuery(stringBuilder.toString())
                .setParameter("startDate",startDate)
                .setParameter("endDate",endDate).getResultList();
        List<unjustifiedAbsenceReportDTO> unjustifiedAbsenceReportDTO=new ArrayList<>();
        if(list != null)
        {  for(int i=0;i<list.size();i++)
        {
            Object[] arr = (Object[]) list.get(i);
          //  unjustifiedAbsenceReportDTO.add(new unjustifiedAbsenceReportDTO(String.valueOf(arr[0]),String.valueOf(arr[1]),String.valueOf(arr[2]),String.valueOf(arr[3]),String.valueOf(arr[6]),String.valueOf(arr[5]),String.valueOf(arr[7]),String.valueOf(arr[8]),String.valueOf(arr[9])));
            unjustifiedAbsenceReportDTO.add(new unjustifiedAbsenceReportDTO(String.valueOf(arr[0]),String.valueOf(arr[1]),String.valueOf(arr[2]),String.valueOf(arr[3] == null ? "" :arr[3]),String.valueOf(arr[4]),String.valueOf(arr[5]),String.valueOf(arr[6]),String.valueOf(arr[7]),String.valueOf(arr[8])));
        }}
        return (mapper.map(unjustifiedAbsenceReportDTO, new TypeToken<List<unjustifiedAbsenceReportDTO>>() {
        }.getType()));
    }

}
