package com.nicico.training.service;

import com.nicico.training.dto.ViewLmsTrainingFileDTO;
import com.nicico.training.dto.ViewTrainingFileDTO;
import com.nicico.training.dto.ViewTrainingFileDTO.Info;
import com.nicico.training.iservice.IViewTrainingFileService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Service
public class ViewTrainingFileService implements IViewTrainingFileService {

    @Autowired
    private final EntityManager entityManager;

    public ViewTrainingFileDTO.SpecRs getByNationalCode(String nationalCode) {
        StringBuffer queryString = new StringBuffer();
        queryString.append("SELECT DEP.C_OMOR_TITLE,");
        queryString.append("       DEP.C_MOAVENAT_TITLE,");
        queryString.append("       DEP.C_MOJTAME_TITLE,");
        queryString.append("       CLASS_STUDENT.CLASS_CODE,");
        queryString.append("       CLASS_STUDENT.CLASS_STATUS,");
        queryString.append("       CLASS_STUDENT.COURSE_CODE,");
        queryString.append("       CLASS_STUDENT.COURSE_TITLE,");
        queryString.append("       CLASS_STUDENT.EMP_NO,");
        queryString.append("       CLASS_STUDENT.C_END_DATE,");
        queryString.append("       CLASS_STUDENT.ERUN_TYPE,");
        queryString.append("       CLASS_STUDENT.N_H_DURATION,");
        queryString.append("       CLASS_STUDENT.JOB_TITLE,");
        queryString.append("       CLASS_STUDENT.FIRST_NAME,");
        queryString.append("       CLASS_STUDENT.LAST_NAME,");
        queryString.append("       CLASS_STUDENT.NATIONAL_CODE,");
        queryString.append("       CASE");
        queryString.append("           WHEN (NVL(PRS.ID, 0) <> 0) THEN 1");
        queryString.append("           WHEN (NVL(PRS_REG.ID, 0) <> 0) THEN 2");
        queryString.append("           ELSE NULL END AS STUDENT_TYPE,");
        queryString.append("       CLASS_STUDENT.POST_CODE,");
        queryString.append("       CLASS_STUDENT.POST_GRADE_TITLE,");
        queryString.append("       CLASS_STUDENT.POST_TITLE,");
        queryString.append("       CLASS_STUDENT.SCORE,");
        queryString.append("       CLASS_STUDENT.SCORE_STATE,");
        queryString.append("       CLASS_STUDENT.C_START_DATE,");
        queryString.append("       CLASS_STUDENT.TEACHER,");
        queryString.append("       CLASS_STUDENT.TERM_TITLE, ");
        queryString.append("       CLASS_STUDENT.COMPANY_NAME, ");
        queryString.append("       CLASS_STUDENT.SCORES_STATE_ID, ");
        queryString.append("       CLASS_STUDENT.CLASS_STATUS_NUM, ");
        queryString.append("       CLASS_STUDENT.E_RUN_TYPE AS RUN_TYPE_NUM, ");
        queryString.append("       CLASS_STUDENT.PERSONNEL_NO,");
        queryString.append("       CASE");
        queryString.append("           WHEN (NVL(PRS.ID, 0) <> 0) THEN 'شرکتی'");
        queryString.append("           WHEN (NVL(PRS_REG.ID, 0) <> 0) THEN ' متفرقه'");
        queryString.append("           ELSE NULL END AS STUDENT_TYPE_NUM");
        queryString.append(" FROM (SELECT DEP.ID                                                                                 AS DEP_ID,");
        queryString.append("             S.EMP_NO,");
        queryString.append("             S.PERSONNEL_NO,");
        queryString.append("             S.NATIONAL_CODE,");
        queryString.append("             S.COMPANY_NAME,");
        queryString.append("             S.JOB_TITLE,");
        queryString.append("             S.POST_GRADE_TITLE,");
        queryString.append("             S.POST_CODE,");
        queryString.append("             S.POST_TITLE,");
        queryString.append("             CS.SCORE,");
        queryString.append("             C.C_CODE                                                                               AS CLASS_CODE,");
        queryString.append("             C.N_H_DURATION,");
        queryString.append("             C.C_START_DATE,");
        queryString.append("             C.C_END_DATE,");
        queryString.append("             C.C_STATUS                                                                             AS CLASS_STATUS_NUM,");
        queryString.append("             S.FIRST_NAME,");
        queryString.append("             S.LAST_NAME,");
        queryString.append("             CASE");
        queryString.append("                 WHEN C.C_STATUS = 1 THEN 'برنامه ریزی'");
        queryString.append("                 WHEN C.C_STATUS = 2 THEN 'در حال اجرا'");
        queryString.append("                 WHEN C.C_STATUS = 3 THEN 'پایان یافته' END                                         AS CLASS_STATUS,");
        queryString.append("             CS.SCORES_STATE_ID,");
        queryString.append("             PA.C_TITLE ||");
        queryString.append("             CASE WHEN CS.SCORE IS NOT NULL THEN ' نمره: ' || CS.SCORE ELSE '' END ||");
        queryString.append("             CASE WHEN CS.FAILURE_REASON_ID IS NOT NULL THEN ' <' || PA2.C_TITLE || '>' ELSE '' END AS SCORE_STATE,");
        queryString.append("             CASE");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 1 THEN 'داخلي'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 2 THEN 'اعزام'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 3 THEN 'سمينار داخلي'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 4 THEN 'سمينار اعزام'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 5 THEN 'حين كار'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 6 THEN 'خارجی'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 7 THEN 'سمینار خارجی'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 8 THEN 'مجازي'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 9 THEN 'بازآموزي'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 10 THEN 'جعبه ابزار' END                                      AS ERUN_TYPE,");
        queryString.append("             CO.E_RUN_TYPE,");
        queryString.append("             CO.C_TITLE_FA                                                                          AS COURSE_TITLE,");
        queryString.append("             TBL_TERM.C_TITLE_FA                                                                    AS TERM_TITLE,");
        queryString.append("             TBL_PERSONAL_INFO.C_FIRST_NAME_FA || ' ' || TBL_PERSONAL_INFO.C_LAST_NAME_FA           AS TEACHER,");
        queryString.append("             CO.C_CODE                                                                              AS COURSE_CODE");
        queryString.append("      FROM TBL_CLASS C");
        queryString.append("               INNER JOIN TBL_CLASS_STUDENT CS ON C.ID = CS.CLASS_ID");
        queryString.append("               INNER JOIN TBL_STUDENT S ON S.ID = CS.STUDENT_ID");
        queryString.append("               INNER JOIN TBL_COURSE CO ON CO.ID = C.F_COURSE");
        queryString.append("               INNER JOIN TBL_TEACHER ON TBL_TEACHER.ID = C.F_TEACHER");
        queryString.append("               INNER JOIN TBL_TERM ON TBL_TERM.ID = C.F_TERM");
        queryString.append("               INNER JOIN TBL_PERSONAL_INFO ON TBL_PERSONAL_INFO.ID = TBL_TEACHER.F_PERSONALITY");
        queryString.append("               LEFT JOIN TBL_PARAMETER_VALUE PA ON CS.SCORES_STATE_ID = PA.ID");
        queryString.append("               LEFT JOIN TBL_PARAMETER_VALUE PA2 ON CS.FAILURE_REASON_ID = PA2.ID");
        queryString.append("               LEFT JOIN TBL_DEPARTMENT DEP ON (DEP.ID = S.F_DEPARTMENT_ID OR");
        queryString.append("                                                (S.F_DEPARTMENT_ID IS NULL AND DEP.C_CODE = S.DEPARTMENT_CODE))");
        queryString.append("      WHERE S.NATIONAL_CODE = '").append(nationalCode).append("') CLASS_STUDENT");
        queryString.append("         LEFT JOIN TBL_DEPARTMENT DEP ON DEP.ID = CLASS_STUDENT.DEP_ID");
        queryString.append("         LEFT JOIN (SELECT PERSONNEL_NO,ID,ROW_NUMBER() OVER (PARTITION BY PERSONNEL_NO ORDER BY DELETED DESC) AS RW FROM TBL_PERSONNEL) PRS ");
        queryString.append(" ON (PRS.PERSONNEL_NO = CLASS_STUDENT.PERSONNEL_NO AND PRS.RW = 1)");
        queryString.append("         LEFT JOIN TBL_PERSONNEL_REGISTERED PRS_REG ON PRS_REG.PERSONNEL_NO = CLASS_STUDENT.PERSONNEL_NO ORDER BY C_START_DATE DESC");

        List<Object[]> resultList = entityManager.createNativeQuery(queryString.toString()).getResultList();
        List<ViewTrainingFileDTO> dtoList = new ArrayList<>();
        Info info = new Info();
        for (Object[] record : resultList) {
            ViewTrainingFileDTO dto = new ViewTrainingFileDTO();
            dto.setAffairs((String) record[0]);
            dto.setAssistant((String) record[1]);
            dto.setComplex((String) record[2]);
            dto.setClassCode((String) record[3]);
            dto.setClassStatus((String) record[4]);
            dto.setCourseCode((String) record[5]);
            dto.setCourseTitle((String) record[6]);
            dto.setEmpNo((String) record[7]);
            dto.setEndDate((String) record[8]);
            dto.setRunType((String) record[9]);
            if (record[10] != null)
                dto.setDuration(Integer.parseInt(record[10].toString()));
            dto.setJobTitle((String) record[11]);
            if (info.getFirstName() == null)
                info.setFirstName((String) record[12]);
            if (info.getLastName() == null)
                info.setLastName((String) record[13]);
            if (info.getNationalCode() == null)
                info.setNationalCode((String) record[14]);
            if (record[15] != null)
                dto.setPersonTypeNum(Integer.parseInt(record[15].toString()));
            dto.setPostCode((String) record[16]);
            dto.setPostGradeTitle((String) record[17]);
            dto.setPostTitle((String) record[18]);
            if (record[19] != null)
                dto.setScore(Float.parseFloat(record[19].toString()));
            dto.setScoresState(record[20].toString());
            dto.setStartDate((String) record[21]);
            dto.setTeacher((String) record[22]);
            dto.setTermTitleFa((String) record[23]);
            dto.setCompanyName((String) record[24]);
            if (record[25] != null)
                dto.setScoresStateNum(Integer.parseInt(record[25].toString()));
            if (record[26] != null)
                dto.setClassStatusNum(Integer.parseInt(record[26].toString()));
            if (record[27] != null)
                dto.setRunTypeNum(Integer.parseInt(record[27].toString()));
            dto.setPersonnelCode((String) record[28]);
            dto.setPersonType((String) record[29]);
            dtoList.add(dto);
        }

        return new ViewTrainingFileDTO.SpecRs()
                .setData(dtoList).setStartRow(0)
                .setInfo(info)
                .setEndRow(dtoList.size())
                .setTotalRows(dtoList.size());
    }

    public List<ViewLmsTrainingFileDTO> getDtoListByNationalCode(String nationalCode) {
        StringBuffer queryString = new StringBuffer();
        queryString.append("SELECT DEP.C_OMOR_TITLE,");
        queryString.append("       DEP.C_MOAVENAT_TITLE,");
        queryString.append("       DEP.C_MOJTAME_TITLE,");
        queryString.append("       CLASS_STUDENT.CLASS_CODE,");
        queryString.append("       CLASS_STUDENT.CLASS_STATUS,");
        queryString.append("       CLASS_STUDENT.COURSE_CODE,");
        queryString.append("       CLASS_STUDENT.COURSE_TITLE,");
        queryString.append("       CLASS_STUDENT.EMP_NO,");
        queryString.append("       CLASS_STUDENT.C_END_DATE,");
        queryString.append("       CLASS_STUDENT.ERUN_TYPE,");
        queryString.append("       CLASS_STUDENT.N_H_DURATION,");
        queryString.append("       CLASS_STUDENT.JOB_TITLE,");
        queryString.append("       CLASS_STUDENT.FIRST_NAME,");
        queryString.append("       CLASS_STUDENT.LAST_NAME,");
        queryString.append("       CLASS_STUDENT.NATIONAL_CODE,");
        queryString.append("       CASE");
        queryString.append("           WHEN (NVL(PRS.ID, 0) <> 0) THEN 1");
        queryString.append("           WHEN (NVL(PRS_REG.ID, 0) <> 0) THEN 2");
        queryString.append("           ELSE NULL END AS STUDENT_TYPE,");
        queryString.append("       CLASS_STUDENT.POST_CODE,");
        queryString.append("       CLASS_STUDENT.POST_GRADE_TITLE,");
        queryString.append("       CLASS_STUDENT.POST_TITLE,");
        queryString.append("       CLASS_STUDENT.SCORE,");
        queryString.append("       CLASS_STUDENT.SCORE_STATE,");
        queryString.append("       CLASS_STUDENT.C_START_DATE,");
        queryString.append("       CLASS_STUDENT.TEACHER,");
        queryString.append("       CLASS_STUDENT.TERM_TITLE, ");
        queryString.append("       CLASS_STUDENT.COMPANY_NAME, ");
        queryString.append("       CLASS_STUDENT.SCORES_STATE_ID, ");
        queryString.append("       CLASS_STUDENT.CLASS_STATUS_NUM, ");
        queryString.append("       CLASS_STUDENT.E_RUN_TYPE AS RUN_TYPE_NUM, ");
        queryString.append("       CLASS_STUDENT.PERSONNEL_NO,");
        queryString.append("       CASE");
        queryString.append("           WHEN (NVL(PRS.ID, 0) <> 0) THEN 'شرکتی'");
        queryString.append("           WHEN (NVL(PRS_REG.ID, 0) <> 0) THEN ' متفرقه'");
        queryString.append("           ELSE NULL END AS STUDENT_TYPE_NUM");
        queryString.append(" FROM (SELECT DEP.ID                                                                                 AS DEP_ID,");
        queryString.append("             S.EMP_NO,");
        queryString.append("             S.PERSONNEL_NO,");
        queryString.append("             S.NATIONAL_CODE,");
        queryString.append("             S.COMPANY_NAME,");
        queryString.append("             S.JOB_TITLE,");
        queryString.append("             S.POST_GRADE_TITLE,");
        queryString.append("             S.POST_CODE,");
        queryString.append("             S.POST_TITLE,");
        queryString.append("             CS.SCORE,");
        queryString.append("             C.C_CODE                                                                               AS CLASS_CODE,");
        queryString.append("             C.N_H_DURATION,");
        queryString.append("             C.C_START_DATE,");
        queryString.append("             C.C_END_DATE,");
        queryString.append("             C.C_STATUS                                                                             AS CLASS_STATUS_NUM,");
        queryString.append("             S.FIRST_NAME,");
        queryString.append("             S.LAST_NAME,");
        queryString.append("             CASE");
        queryString.append("                 WHEN C.C_STATUS = 1 THEN 'برنامه ریزی'");
        queryString.append("                 WHEN C.C_STATUS = 2 THEN 'در حال اجرا'");
        queryString.append("                 WHEN C.C_STATUS = 3 THEN 'پایان یافته' END                                         AS CLASS_STATUS,");
        queryString.append("             CS.SCORES_STATE_ID,");
        queryString.append("             PA.C_TITLE ||");
        queryString.append("             CASE WHEN CS.SCORE IS NOT NULL THEN ' نمره: ' || CS.SCORE ELSE '' END ||");
        queryString.append("             CASE WHEN CS.FAILURE_REASON_ID IS NOT NULL THEN ' <' || PA2.C_TITLE || '>' ELSE '' END AS SCORE_STATE,");
        queryString.append("             CASE");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 1 THEN 'داخلي'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 2 THEN 'اعزام'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 3 THEN 'سمينار داخلي'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 4 THEN 'سمينار اعزام'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 5 THEN 'حين كار'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 6 THEN 'خارجی'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 7 THEN 'سمینار خارجی'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 8 THEN 'مجازي'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 9 THEN 'بازآموزي'");
        queryString.append("                 WHEN CO.E_RUN_TYPE = 10 THEN 'جعبه ابزار' END                                      AS ERUN_TYPE,");
        queryString.append("             CO.E_RUN_TYPE,");
        queryString.append("             CO.C_TITLE_FA                                                                          AS COURSE_TITLE,");
        queryString.append("             TBL_TERM.C_TITLE_FA                                                                    AS TERM_TITLE,");
        queryString.append("             TBL_PERSONAL_INFO.C_FIRST_NAME_FA || ' ' || TBL_PERSONAL_INFO.C_LAST_NAME_FA           AS TEACHER,");
        queryString.append("             CO.C_CODE                                                                              AS COURSE_CODE");
        queryString.append("      FROM TBL_CLASS C");
        queryString.append("               INNER JOIN TBL_CLASS_STUDENT CS ON C.ID = CS.CLASS_ID");
        queryString.append("               INNER JOIN TBL_STUDENT S ON S.ID = CS.STUDENT_ID");
        queryString.append("               INNER JOIN TBL_COURSE CO ON CO.ID = C.F_COURSE");
        queryString.append("               INNER JOIN TBL_TEACHER ON TBL_TEACHER.ID = C.F_TEACHER");
        queryString.append("               INNER JOIN TBL_TERM ON TBL_TERM.ID = C.F_TERM");
        queryString.append("               INNER JOIN TBL_PERSONAL_INFO ON TBL_PERSONAL_INFO.ID = TBL_TEACHER.F_PERSONALITY");
        queryString.append("               LEFT JOIN TBL_PARAMETER_VALUE PA ON CS.SCORES_STATE_ID = PA.ID");
        queryString.append("               LEFT JOIN TBL_PARAMETER_VALUE PA2 ON CS.FAILURE_REASON_ID = PA2.ID");
        queryString.append("               LEFT JOIN TBL_DEPARTMENT DEP ON (DEP.ID = S.F_DEPARTMENT_ID OR");
        queryString.append("                                                (S.F_DEPARTMENT_ID IS NULL AND DEP.C_CODE = S.DEPARTMENT_CODE))");
        queryString.append("      WHERE S.NATIONAL_CODE = '").append(nationalCode).append("') CLASS_STUDENT");
        queryString.append("         LEFT JOIN TBL_DEPARTMENT DEP ON DEP.ID = CLASS_STUDENT.DEP_ID");
        queryString.append("         LEFT JOIN (SELECT PERSONNEL_NO,ID,ROW_NUMBER() OVER (PARTITION BY PERSONNEL_NO ORDER BY DELETED DESC) AS RW FROM TBL_PERSONNEL) PRS ");
        queryString.append(" ON (PRS.PERSONNEL_NO = CLASS_STUDENT.PERSONNEL_NO AND PRS.RW = 1)");
        queryString.append("         LEFT JOIN TBL_PERSONNEL_REGISTERED PRS_REG ON PRS_REG.PERSONNEL_NO = CLASS_STUDENT.PERSONNEL_NO ORDER BY C_START_DATE DESC");

        List<Object[]> resultList = entityManager.createNativeQuery(queryString.toString()).getResultList();
        List<ViewLmsTrainingFileDTO> dtoList = new ArrayList<>();
        for (Object[] record : resultList) {
            ViewLmsTrainingFileDTO dto = new ViewLmsTrainingFileDTO();
            dto.setAffairs((String) record[0]);
            dto.setAssistant((String) record[1]);
            dto.setComplex((String) record[2]);
            dto.setClassCode((String) record[3]);
            dto.setClassStatus((String) record[4]);
            dto.setCourseCode((String) record[5]);
            dto.setCourseTitle((String) record[6]);
            dto.setEmpNo((String) record[7]);
            dto.setEndDate((String) record[8]);
            dto.setRunType((String) record[9]);
            if (record[10] != null)
                dto.setDuration(Integer.parseInt(record[10].toString()));
            dto.setJobTitle((String) record[11]);
            dto.setFirstName((String) record[12]);
            dto.setLastName((String) record[13]);
            dto.setNationalCode((String) record[14]);
            if (record[15] != null)
                dto.setPostCode((String) record[16]);
            dto.setPostGradeTitle((String) record[17]);
            dto.setPostTitle((String) record[18]);
            if (record[19] != null)
                dto.setScore(Float.parseFloat(record[19].toString()));
            dto.setScoresState(record[20].toString());
            dto.setStartDate((String) record[21]);
            dto.setTeacher((String) record[22]);
            dto.setTermTitleFa((String) record[23]);
            dto.setCompanyName((String) record[24]);
            dto.setPersonnelCode((String) record[28]);
            dto.setPersonType((String) record[29]);
            dtoList.add(dto);
        }
        return dtoList;
    }
}
