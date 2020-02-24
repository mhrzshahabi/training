package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.unjustifiedAbsenceDTO;
import com.nicico.training.iservice.IunjustifiedAbsenceService;
import com.nicico.training.repository.unjustifiedAbsenceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UnjustifiedAbsenceService implements IunjustifiedAbsenceService {
    @Autowired
    protected EntityManager entityManager;
    private final  unjustifiedAbsenceDAO unjustifiedAbsenceDAO;
    private final ModelMapper mapper;


    @Transactional
    @Override
    public List<unjustifiedAbsenceDTO.printScoreInfo> print(String startDate, String endDate) throws Exception{
        StringBuilder stringBuilder=new StringBuilder().append("SELECT    tbl_class.c_code,\n" +
                "                tbl_class.c_title_class,\n" +
                "                tbl_class_student.pre_test_score,\n" +
                "                tbl_student.first_name,\n" +
                "                tbl_student.last_name,\n" +
                "                tbl_class.c_start_date,\n" +
                "                tbl_class.c_end_date,         \n" +
                "             ( CASE\n" +
                "              WHEN  tbl_student.emp_no IS NULL\n" +
                "               THEN 'ندارد'\n" +
                "               END) as emp_no,\n" +
                "              tbl_student.personnel_no ,\n" +
                "             tbl_student.national_code,\n" +
                "              (SELECT\n" +
                "                        tbl_parameter_value.c_value\n" +
                "                    FROM\n" +
                "                        tbl_parameter_value\n" +
                "                    WHERE\n" +
                "                        tbl_parameter_value.c_code = 'minScorePreTestEB') as ScorePreTest\n" +
                "   \n" +
                "            FROM\n" +
                "                tbl_class\n" +
                "                INNER JOIN tbl_class_student ON tbl_class.id = tbl_class_student.class_id\n" +
                "                INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id\n" +
                "            WHERE\n" +
                "                tbl_class_student.pre_test_score >= (\n" +
                "                    SELECT\n" +
                "                        tbl_parameter_value.c_value\n" +
                "                    FROM\n" +
                "                        tbl_parameter_value\n" +
                "                    WHERE\n" +
                "                        tbl_parameter_value.c_code = 'minScorePreTestEB'\n" +
                "                )\n" +
                "             AND   tbl_class.pre_course_test = 1  AND   tbl_class.c_start_date >= :startDate   AND   tbl_class.c_end_date <=  :endDate order by  tbl_class.c_title_class, tbl_student.last_name, tbl_student.first_name \n" +
                "           ");
        List<Object> list=new ArrayList<>();
        list= (List<Object>) entityManager.createNativeQuery(stringBuilder.toString())
              .setParameter("startDate",startDate)
              .setParameter("endDate",endDate).getResultList();
              List<unjustifiedAbsenceDTO.printScoreInfo> unjustifiedAbsenceDTO=new ArrayList<>();
             if(list != null)
             {  for(int i=0;i<list.size();i++)
             {
                 Object[] arr = (Object[]) list.get(i);
                 unjustifiedAbsenceDTO.add(new unjustifiedAbsenceDTO.printScoreInfo(arr[0].toString(),arr[1].toString(),arr[2].toString(),arr[3].toString(),arr[4].toString(),arr[5].toString(),arr[6].toString(),arr[7].toString(),arr[8].toString()));
             }}
        return (mapper.map(unjustifiedAbsenceDTO, new TypeToken<List<unjustifiedAbsenceDTO.printScoreInfo>>() {
        }.getType()));
    }



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
