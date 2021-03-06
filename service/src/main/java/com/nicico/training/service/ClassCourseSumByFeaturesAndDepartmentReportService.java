package com.nicico.training.service;

import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.GroupBy;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ReportFor;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassSumByStatus;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassFeatures;
import com.nicico.training.iservice.IClassCourseSumByFeaturesAndDepartmentReportService;
import com.nicico.training.iservice.IDepartmentService;
import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ClassCourseSumByFeaturesAndDepartmentReportService implements IClassCourseSumByFeaturesAndDepartmentReportService {

    @Autowired
    private final EntityManager entityManager;
    private final IDepartmentService departmentService;

    @Transactional(readOnly = true)
    @Override
    public List<ClassCourseSumByFeaturesAndDepartmentReportDTO> getReportGroupByPlannerDepartment(String startDate,
                                                                                                  String endDate,
                                                                                                  String mojtameCode,
                                                                                                  String moavenatCode,
                                                                                                  String omorCode,
                                                                                                  List<String> classStatusList) {
        StringBuffer departmentFilterCode = new StringBuffer();
        StringBuffer script = new StringBuffer("SELECT ");
        script.append(" CASE WHEN AL.presence + AL.absence = 0 THEN NULL");
        script.append("     ELSE ROUND(100*AL.presence /(AL.presence + AL.absence) ,2) END AS participationPercent,");
        script.append(" CASE WHEN prs.count_prs = 0 THEN NULL");
        script.append(" ELSE ROUND(AL.presence / prs.count_prs , 2) END AS presencePerPerson,");
        script.append("       prs.COUNT_PRS,AL.* FROM (SELECT");
        script.append("       SUM(PRESENCE) PRESENCE,");
        script.append("       SUM(ABSENCE) ABSENCE,");
        script.append("       SUM(UNKNOWN) UNKNOWN,");
        script.append("       SUM(STUDENT_COUNT) STUDENT_COUNT,");
        if (omorCode != null) {
            script.append("       C_GHESMAT_CODE,");
            script.append("       C_GHESMAT_TITLE");
            departmentFilterCode.append(" C_OMOR_CODE='").append(omorCode).append("'");
        } else if (moavenatCode != null) {
            script.append("       C_OMOR_CODE,");
            script.append("       C_OMOR_TITLE");
            departmentFilterCode.append(" C_MOAVENAT_CODE='").append(moavenatCode).append("'");
        } else if (mojtameCode != null) {
            script.append("       C_MOAVENAT_CODE,");
            script.append("       C_MOAVENAT_TITLE");
            departmentFilterCode.append(" C_MOJTAME_CODE='").append(mojtameCode).append("'");
        } else {
            script.append("       C_MOJTAME_CODE,");
            script.append("       C_MOJTAME_TITLE");
            departmentFilterCode.append(" 1=1");
        }
        script.append("       FROM (");
        script.append("SELECT   PRESENCE,");
        script.append("         ABSENCE,");
        script.append("         UNKNOWN,");
        script.append("         STUDENT_COUNT,");
        script.append("         CLSS.C_CODE,");
        script.append("         CLSS.C_END_DATE,");
        script.append("         CLSS.C_START_DATE,");
        script.append("         CLSS.C_STATUS,");
        script.append("         CLSS.C_TEACHING_TYPE,");
        script.append("         CRS.C_CODE,");
        script.append("         CRS.C_TITLE_FA,");
        script.append("         CRS.E_TECHNICAL_TYPE,");
        script.append("         CRS.E_RUN_TYPE,");
        script.append("         CRS.E_THEO_TYPE,");
        script.append("         CRS.E_LEVEL_TYPE,");
        script.append("         DPRT.C_TITLE,");
        script.append("         DPRT.C_MOJTAME_CODE,");
        script.append("         DPRT.C_MOJTAME_TITLE,");
        script.append("         DPRT.C_OMOR_CODE,");
        script.append("         DPRT.C_OMOR_TITLE,");
        script.append("         DPRT.C_MOAVENAT_CODE,");
        script.append("         DPRT.C_MOAVENAT_TITLE,");
        script.append("         DPRT.C_GHESMAT_CODE,");
        script.append("         DPRT.C_GHESMAT_TITLE");
        script.append("         FROM(SELECT * FROM (");
        script.append("SELECT ATT_STATE, F_CLASS_ID,S_HOUR FROM (");
        script.append("                  SELECT CASE WHEN (ATT.C_STATE = 1 OR ATT.C_STATE = 2) THEN 'PRESENCE'");
        script.append("                          WHEN (ATT.C_STATE = 3 OR ATT.C_STATE = 4) THEN 'ABSENCE' ELSE 'UNKNOWN' END AS ATT_STATE , ATT.F_SESSION, ATT.F_STUDENT, SESS.F_CLASS_ID, SESS.S_HOUR ");
        script.append("                          FROM TBL_ATTENDANCE ATT INNER JOIN (");
        script.append("SELECT ");
        script.append("(TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR ,'[^:]+',3,1))+60*TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR ,'[^:]+',1,1))");
        script.append("-");
        script.append("(TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR ,'[^:]+',3,1))+60*TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR ,'[^:]+',1,1))))/60 AS S_HOUR,");
        script.append("ID ,F_CLASS_ID  FROM TBL_SESSION WHERE ");
        script.append("                          C_SESSION_DATE >= :FROM_DATE  ");
        script.append("                          AND C_SESSION_DATE <= :TO_DATE ");
        script.append("                          )SESS ON(ATT.F_SESSION = SESS.ID)");
        script.append("      ) )PIVOT(SUM (S_HOUR) FOR ATT_STATE IN('PRESENCE' AS PRESENCE,'ABSENCE' AS ABSENCE,'UNKNOWN' AS UNKNOWN))) SUM_");
        script.append("                          INNER JOIN (SELECT PV.C_TITLE AS C_TEACHING_TYPE, CLSS.ID, CLSS.C_CODE, CLSS.C_END_DATE, CLSS.C_START_DATE, CLSS.C_STATUS, CLSS.F_PLANNER, CLSS.F_COURSE FROM TBL_CLASS CLSS LEFT JOIN TBL_PARAMETER_VALUE PV ON CLSS.F_TEACHING_METHOD_ID = PV.ID) CLSS ON (CLSS.ID = SUM_.F_CLASS_ID AND ");
        if (classStatusList.size() > 0) {
            script.append("  CLSS.C_STATUS IN (").append(classStatusList.stream().collect(Collectors.joining(","))).append("))");
        } else {
            script.append(" 1=1)");
        }
        script.append("                          LEFT JOIN (SELECT CLASS_ID , COUNT(DISTINCT(STUDENT_ID)) AS STUDENT_COUNT FROM TBL_CLASS_STUDENT GROUP BY CLASS_ID) ST_COUNT ON(ST_COUNT.CLASS_ID = CLSS.ID)");
        script.append("                          INNER JOIN TBL_COURSE CRS ON(CRS.ID = CLSS.F_COURSE)");
        script.append("                          LEFT JOIN TBL_PERSONNEL personnel on (personnel.ID = CLSS.F_PLANNER) ");
        script.append("                          INNER JOIN (");
        script.append("                          SELECT * FROM TBL_DEPARTMENT WHERE ");
        script.append(departmentFilterCode);
        script.append("                          )DPRT ON(DPRT.ID = personnel.F_DEPARTMENT_ID) ");
        script.append("              )GROUP BY ");
        if (omorCode != null) {
            script.append("       C_GHESMAT_CODE,");
            script.append("       C_GHESMAT_TITLE");
        } else if (moavenatCode != null) {
            script.append("       C_OMOR_CODE,");
            script.append("       C_OMOR_TITLE");
        } else if (mojtameCode != null) {
            script.append("       C_MOAVENAT_CODE,");
            script.append("       C_MOAVENAT_TITLE");
        } else {
            script.append("       C_MOJTAME_CODE,");
            script.append("       C_MOJTAME_TITLE");
        }
        script.append(" ) AL LEFT JOIN (select count(*) as COUNT_PRS,");
        if (moavenatCode != null) {
            script.append(" C_OMOR_CODE");
        } else if (mojtameCode != null) {
            script.append(" C_MOAVENAT_CODE");
        } else {
            script.append(" C_MOJTAME_CODE");
        }
        script.append(" FROM (SELECT DEP.* FROM (SELECT * FROM TBL_PERSONNEL PRS WHERE DELETED = 0) PRS INNER JOIN TBL_DEPARTMENT DEP ON DEP.ID = PRS.F_DEPARTMENT_ID)");
        if (moavenatCode != null) {
            script.append(" GROUP BY C_OMOR_CODE) PRS ON PRS.C_OMOR_CODE = AL.C_OMOR_CODE");
        } else if (mojtameCode != null) {
            script.append(" GROUP BY C_MOAVENAT_CODE) PRS ON PRS.C_MOAVENAT_CODE = AL.C_MOAVENAT_CODE");
        } else {
            script.append(" GROUP BY C_MOJTAME_CODE) PRS ON PRS.C_MOJTAME_CODE = AL.C_MOJTAME_CODE");
        }
        List<Object[]> records = (List<Object[]>) entityManager.createNativeQuery(script.toString())
                .setParameter("FROM_DATE", startDate)
                .setParameter("TO_DATE", endDate)
                .getResultList();
        List<ClassCourseSumByFeaturesAndDepartmentReportDTO> list = new ArrayList<>();

        for (Object[] record : records) {
            ClassFeatures dto = new ClassFeatures();
            dto
                    .setParticipationPercent(record[0] == null ? null : Double.parseDouble(record[0].toString()))
                    .setPresencePerPerson(record[1] == null ? null : Double.parseDouble(record[1].toString()))
                    .setPersonnelCount(record[2] == null ? null : Integer.parseInt(record[2].toString()))
                    .setPresenceManHour(record[3] == null ? null : Double.parseDouble(record[3].toString()))
                    .setAbsenceManHour(record[4] == null ? null : Double.parseDouble(record[4].toString()))
                    .setUnknownManHour(record[5] == null ? null : Double.parseDouble(record[5].toString()))
                    .setStudentCount(record[6] == null ? null : Integer.parseInt(record[6].toString()));

            if (omorCode != null) {
                dto.setGhesmatCode(record[7] == null ? null : record[7].toString());
                dto.setGhesmatTitle(record[8] == null ? null : record[8].toString());
            } else if (moavenatCode != null) {
                dto.setOmorCode(record[7] == null ? null : record[7].toString());
                dto.setOmorTitle(record[8] == null ? null : record[8].toString());
            } else if (mojtameCode != null) {
                dto.setMoavenatCode(record[7] == null ? null : record[7].toString());
                dto.setMoavenatTitle(record[8] == null ? null : record[8].toString());
            } else {
                dto.setMojtameCode(record[7] == null ? null : record[7].toString());
                dto.setMojtameTitle(record[8] == null ? null : record[8].toString());
            }

            list.add(dto);
        }
        return list;
    }

    @Transactional(readOnly = true)
    @Override
    public List<ClassCourseSumByFeaturesAndDepartmentReportDTO> getReportGroupByStudentDepartment(String startDate,
                                                                                                  String endDate,
                                                                                                  String mojtameCode,
                                                                                                  String moavenatCode,
                                                                                                  String omorCode,
                                                                                                  List<String> classStatusList) {
        StringBuffer departmentFilterCode = new StringBuffer();
        if (omorCode != null) {
            departmentFilterCode.append(" C_OMOR_CODE='").append(omorCode).append("'");
        } else if (moavenatCode != null) {
            departmentFilterCode.append(" C_MOAVENAT_CODE='").append(moavenatCode).append("'");
        } else if (mojtameCode != null) {
            departmentFilterCode.append(" C_MOJTAME_CODE='").append(mojtameCode).append("'");
        } else {
            departmentFilterCode.append(" 1=1");
        }
        StringBuffer script = new StringBuffer("SELECT ");
        script.append(" CASE WHEN AL.presence + AL.absence = 0 THEN NULL");
        script.append("     ELSE ROUND(100*AL.presence /(AL.presence + AL.absence) ,2) END AS participationPercent,");
        script.append(" CASE WHEN PRS.count_prs = 0 THEN NULL");
        script.append(" ELSE ROUND(AL.presence / PRS.count_prs , 2) END AS presencePerPerson,");
        script.append(" AL.STUDENT_COUNT,ROUND(AL.ABSENCE, 2) AS ABSENCE,ROUND(AL.PRESENCE, 2) AS PRESENCE,ROUND(AL.UNKNOWN, 2) AS UNKNOWN,PRS.COUNT_PRS, ");
        appendGroupQuery(script, mojtameCode, moavenatCode, omorCode, "AL.");
        script.append(" FROM (SELECT");
        script.append("       SUM(PRESENCE) PRESENCE,");
        script.append("       SUM(ABSENCE) ABSENCE,");
        script.append("       SUM(UNKNOWN) UNKNOWN,");
        script.append("       SUM(STUDENT_COUNT) STUDENT_COUNT,");
        appendGroupQuery(script, mojtameCode, moavenatCode, omorCode, "");
        script.append(" FROM (SELECT SUM_.*, ");
        appendGroupQuery(script, mojtameCode, moavenatCode, omorCode, "");
        script.append(" FROM (SELECT COUNT(*)       AS STUDENT_COUNT,");
        script.append("       F_DEPARTMENT_ID,");
        script.append("       SUM(NVL(ABSENCE, 0))  AS ABSENCE,");
        script.append("       SUM(NVL(PRESENCE, 0)) AS PRESENCE,");
        script.append("       SUM(NVL(UNKNOWN, 0))  AS UNKNOWN");
        script.append("         FROM (");
        script.append("                SELECT ATT.F_STUDENT, ATT.F_CLASS_ID, ATT.ABSENCE, ATT.PRESENCE, ATT.UNKNOWN, PRSN.F_DEPARTMENT_ID");
        script.append(" FROM (");
        script.append(" SELECT * FROM (");
        script.append(" SELECT F_STUDENT, ATT_STATE, F_CLASS_ID, S_HOUR FROM (");
        script.append("SELECT CASE ");
        script.append("                                                       WHEN (ATT.C_STATE = 1 OR ATT.C_STATE = 2)");
        script.append("                                                           THEN 'PRESENCE'");
        script.append("                                                       WHEN (ATT.C_STATE = 3 OR ATT.C_STATE = 4) THEN 'ABSENCE'");
        script.append("                                                       ELSE 'UNKNOWN' END AS ATT_STATE,");
        script.append("                                                   ATT.F_SESSION,");
        script.append("                                                   ATT.F_STUDENT,");
        script.append("                                                   SESS.F_CLASS_ID,");
        script.append("                                                   SESS.S_HOUR");
        script.append("                                            FROM TBL_ATTENDANCE ATT");
        script.append("                                                     INNER JOIN (SELECT (TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR, '[^:]+', 3, 1)) +");
        script.append("                                                                         60 * TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR, '[^:]+', 1, 1)) -");
        script.append("                                                                         (TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR, '[^:]+', 3, 1)) +");
        script.append("                                                                          60 * TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR, '[^:]+', 1, 1)))) /");
        script.append("                                                                        60 AS S_HOUR,");
        script.append("                                                                        ID,");
        script.append("                                                                        F_CLASS_ID");
        script.append("                                                                 FROM TBL_SESSION");
        script.append("                                                                 WHERE C_SESSION_DATE >= :FROM_DATE");
        script.append("                                                                   AND C_SESSION_DATE <= :TO_DATE) SESS");
        script.append("                                                                ON (ATT.F_SESSION = SESS.ID))");
        script.append("                               ) PIVOT (SUM(S_HOUR) FOR ATT_STATE IN ('PRESENCE' AS PRESENCE,'ABSENCE' AS ABSENCE,'UNKNOWN' AS UNKNOWN))");
        script.append("                           ) ATT");
        script.append("                               INNER JOIN TBL_STUDENT STD ON STD.ID = ATT.F_STUDENT");
        script.append("                               INNER JOIN (SELECT F_DEPARTMENT_ID, PERSONNEL_NO");
        script.append("                                           FROM (SELECT PR.F_DEPARTMENT_ID,");
        script.append("                                                        PR.PERSONNEL_NO,");
        script.append("                                                        ROW_NUMBER() OVER (PARTITION BY PERSONNEL_NO ORDER BY DELETED ASC) RW");
        script.append("                                                 FROM TBL_PERSONNEL PR");
        script.append("                                                 WHERE F_DEPARTMENT_ID IS NOT NULL)");
        script.append("                                           WHERE RW = 1) PRSN ON PRSN.PERSONNEL_NO = STD.PERSONNEL_NO");
        script.append("                               INNER JOIN (SELECT ID,");
        script.append("                                                  C_STATUS");
        script.append("                                           FROM TBL_CLASS");
        script.append("                                           WHERE ");
        if (classStatusList.size() > 0) {
            script.append("  C_STATUS IN (").append(classStatusList.stream().collect(Collectors.joining(","))).append("))");
        } else {
            script.append(" 1=1)");
        }
        script.append("                   CLSS ON CLSS.ID = ATT.F_CLASS_ID)");
        script.append("             GROUP BY F_DEPARTMENT_ID) SUM_");
        script.append("               INNER JOIN (SELECT ID,C_MOAVENAT_CODE,C_MOJTAME_CODE,C_OMOR_CODE,C_GHESMAT_CODE,C_MOJTAME_TITLE,C_MOAVENAT_TITLE,C_OMOR_TITLE,C_GHESMAT_TITLE  FROM TBL_DEPARTMENT WHERE ");
        script.append(departmentFilterCode);
        script.append(" )DEP ON DEP.ID = SUM_.F_DEPARTMENT_ID )");
        script.append("GROUP BY ");
        appendGroupQuery(script, mojtameCode, moavenatCode, omorCode, "");
        script.append(") AL LEFT JOIN ( select count(*) as COUNT_PRS,");
        appendGroupQueryCode(script, mojtameCode, moavenatCode, omorCode);
        script.append(" FROM (SELECT DEP.* FROM ( SELECT * FROM TBL_PERSONNEL PRS WHERE DELETED = 0) PRS INNER JOIN TBL_DEPARTMENT DEP ON DEP.ID = PRS.F_DEPARTMENT_ID ) GROUP BY ");
        appendGroupQueryCode(script, mojtameCode, moavenatCode, omorCode);
        script.append(") PRS ON PRS.");
        if (omorCode != null) {
            script.append("C_GHESMAT_CODE = AL.C_GHESMAT_CODE ");
        } else if (moavenatCode != null) {
            script.append("C_OMOR_CODE = AL.C_OMOR_CODE ");
        } else if (mojtameCode != null) {
            script.append("C_MOAVENAT_CODE = AL.C_MOAVENAT_CODE ");
        } else {
            script.append("C_MOJTAME_CODE = AL.C_MOJTAME_CODE ");
        }
        List<Object[]> records = (List<Object[]>) entityManager.createNativeQuery(script.toString())
                .setParameter("FROM_DATE", startDate)
                .setParameter("TO_DATE", endDate)
                .getResultList();
        List<ClassCourseSumByFeaturesAndDepartmentReportDTO> list = new ArrayList<>();

        for (Object[] record : records) {
            ClassFeatures dto = new ClassFeatures();
            dto
                    .setParticipationPercent(record[0] == null ? null : Double.parseDouble(record[0].toString()))
                    .setPresencePerPerson(record[1] == null ? null : Double.parseDouble(record[1].toString()))
                    .setStudentCount(record[2] == null ? null : Integer.parseInt(record[2].toString()))
                    .setAbsenceManHour(record[3] == null ? null : Double.parseDouble(record[3].toString()))
                    .setPresenceManHour(record[4] == null ? null : Double.parseDouble(record[4].toString()))
                    .setUnknownManHour(record[5] == null ? null : Double.parseDouble(record[5].toString()))
                    .setPersonnelCount(record[6] == null ? null : Integer.parseInt(record[6].toString()));

            if (omorCode != null) {
                dto.setGhesmatCode(record[7] == null ? null : record[7].toString());
                dto.setGhesmatTitle(record[8] == null ? null : record[8].toString());
            } else if (moavenatCode != null) {
                dto.setOmorCode(record[7] == null ? null : record[7].toString());
                dto.setOmorTitle(record[8] == null ? null : record[8].toString());
            } else if (mojtameCode != null) {
                dto.setMoavenatCode(record[7] == null ? null : record[7].toString());
                dto.setMoavenatTitle(record[8] == null ? null : record[8].toString());
            } else {
                dto.setMojtameCode(record[7] == null ? null : record[7].toString());
                dto.setMojtameTitle(record[8] == null ? null : record[8].toString());
            }

            list.add(dto);
        }
        return list;
    }


    @Transactional(readOnly = true)
    @Override
    public List<ClassCourseSumByFeaturesAndDepartmentReportDTO> getReportGroupByClassDepartment(String startDate,
                                                                                                String endDate,
                                                                                                String mojtameCode,
                                                                                                String moavenatCode,
                                                                                                String omorCode,
                                                                                                List<String> classStatusList) {
        Long departmentId = null;
        StringBuffer script = new StringBuffer("SELECT CASE ");
        script.append("           WHEN AL.presence + AL.absence = 0 THEN NULL");
        script.append("           ELSE ROUND(100 * AL.presence / (AL.presence + AL.absence), 2) END                AS participationPercent,");
        script.append("       CASE WHEN PRS.count_prs = 0 THEN NULL ELSE ROUND(AL.presence / PRS.count_prs, 2) END AS presencePerPerson,");
        script.append("       AL.STUDENT_COUNT,");
        script.append("       ROUND(AL.ABSENCE, 2)                                                                 AS ABSENCE,");
        script.append("       ROUND(AL.PRESENCE, 2)                                                                AS PRESENCE,");
        script.append("       ROUND(AL.UNKNOWN, 2)                                                                 AS UNKNOWN,");
        script.append("       PRS.COUNT_PRS,");
        script.append("       DP.C_CODE,");
        script.append("       DP.C_TITLE");
        script.append(" FROM (SELECT COUNT(*)              AS STUDENT_COUNT,");
        if (moavenatCode != null) {
            script.append(" AFFAIRS_ID,");
            departmentId = departmentService.getByCode(moavenatCode).getId();
        } else if (mojtameCode != null) {
            script.append(" ASSISTANT_ID,");
            departmentId = departmentService.getByCode(mojtameCode).getId();
        } else {
            script.append(" COMPLEX_ID,");
        }
        script.append("             SUM(NVL(ABSENCE, 0))  AS ABSENCE,");
        script.append("             SUM(NVL(PRESENCE, 0)) AS PRESENCE,");
        script.append("             SUM(NVL(UNKNOWN, 0))  AS UNKNOWN");
        script.append("      FROM (SELECT ATT.F_STUDENT,");
        script.append("                   ATT.F_CLASS_ID,");
        script.append("                   ATT.ABSENCE,");
        script.append("                   ATT.PRESENCE,");
        script.append("                   ATT.UNKNOWN,");
        script.append("                   CLSS.AFFAIRS_ID,");
        script.append("                   CLSS.ASSISTANT_ID,");
        script.append("                   CLSS.COMPLEX_ID");
        script.append("            FROM (SELECT *");
        script.append("                  FROM (SELECT F_STUDENT, ATT_STATE, F_CLASS_ID, S_HOUR");
        script.append("                        FROM (SELECT CASE");
        script.append("                                         WHEN (ATT.C_STATE = 1 OR ATT.C_STATE = 2) THEN 'PRESENCE'");
        script.append("                                         WHEN (ATT.C_STATE = 3 OR ATT.C_STATE = 4) THEN 'ABSENCE'");
        script.append("                                         ELSE 'UNKNOWN' END AS ATT_STATE,");
        script.append("                                     ATT.F_SESSION,");
        script.append("                                     ATT.F_STUDENT,");
        script.append("                                     SESS.F_CLASS_ID,");
        script.append("                                     SESS.S_HOUR");
        script.append("                              FROM TBL_ATTENDANCE ATT");
        script.append("                                       INNER JOIN (SELECT (TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR, '[^:]+', 3, 1)) +");
        script.append("                                                           60 * TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR, '[^:]+', 1, 1)) -");
        script.append("                                                           (TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR, '[^:]+', 3, 1)) +");
        script.append("                                                            60 * TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR, '[^:]+', 1, 1)))) /");
        script.append("                                                          60 AS S_HOUR,ID ,F_CLASS_ID");
        script.append("                                                   FROM TBL_SESSION");
        script.append("                                                   WHERE C_SESSION_DATE >= :FROM_DATE ");
        script.append("                                                     AND C_SESSION_DATE <= :TO_DATE ) SESS");
        script.append("                                                  ON (ATT.F_SESSION = SESS.ID))) PIVOT (SUM(S_HOUR) FOR ATT_STATE IN ('PRESENCE' AS PRESENCE,'ABSENCE' AS ABSENCE,'UNKNOWN' AS UNKNOWN))) ATT");
        script.append("                     INNER JOIN TBL_STUDENT STD ON STD.ID = ATT.F_STUDENT");
        script.append("                     INNER JOIN (SELECT ID, C_STATUS, AFFAIRS_ID, ASSISTANT_ID, COMPLEX_ID");
        script.append("                                 FROM TBL_CLASS");
        script.append("                                 WHERE C_STATUS IN (1, 2, 3, 4, 5)");
        if (moavenatCode != null) {
            script.append(" AND ASSISTANT_ID = ").append(departmentId);
        } else if (mojtameCode != null) {
            script.append(" AND COMPLEX_ID = ").append(departmentId);
        }
        script.append("    ) CLSS ON CLSS.ID = ATT.F_CLASS_ID) GROUP BY ");
        if (moavenatCode != null) {
            script.append(" AFFAIRS_ID ");
        } else if (mojtameCode != null) {
            script.append(" ASSISTANT_ID ");
        } else {
            script.append(" COMPLEX_ID ");
        }
        script.append("      ) AL LEFT JOIN TBL_DEPARTMENT DP");
        if (moavenatCode != null) {
            script.append("                   on DP.ID = AL.AFFAIRS_ID");
            script.append("         LEFT JOIN (select count(*) as COUNT_PRS, C_OMOR_CODE");
        } else if (mojtameCode != null) {
            script.append("                   on DP.ID = AL.ASSISTANT_ID");
            script.append("         LEFT JOIN (select count(*) as COUNT_PRS, C_MOAVENAT_CODE");
        } else {
            script.append("                   on DP.ID = AL.COMPLEX_ID");
            script.append("         LEFT JOIN (select count(*) as COUNT_PRS, C_MOJTAME_CODE");
        }
        script.append("                    FROM (SELECT DEP.*");
        script.append("                          FROM (SELECT * FROM TBL_PERSONNEL PRS WHERE DELETED = 0) PRS");
        script.append("                                   INNER JOIN TBL_DEPARTMENT DEP ON DEP.ID = PRS.F_DEPARTMENT_ID)");
        if (moavenatCode != null) {
            script.append("                    GROUP BY C_OMOR_CODE) PRS");
            script.append("                   ON PRS.C_OMOR_CODE = DP.C_CODE");
        } else if (mojtameCode != null) {
            script.append("                    GROUP BY C_MOAVENAT_CODE) PRS");
            script.append("                   ON PRS.C_MOAVENAT_CODE = DP.C_CODE");
        } else {
            script.append("                    GROUP BY C_MOJTAME_CODE) PRS");
            script.append("                   ON PRS.C_MOJTAME_CODE = DP.C_CODE");
        }

        List<Object[]> records = (List<Object[]>) entityManager.createNativeQuery(script.toString())
                .setParameter("FROM_DATE", startDate)
                .setParameter("TO_DATE", endDate)
                .getResultList();
        List<ClassCourseSumByFeaturesAndDepartmentReportDTO> list = new ArrayList<>();

        for (Object[] record : records) {
            ClassFeatures dto = new ClassFeatures();
            dto
                    .setParticipationPercent(record[0] == null ? null : Double.parseDouble(record[0].toString()))
                    .setPresencePerPerson(record[1] == null ? null : Double.parseDouble(record[1].toString()))
                    .setStudentCount(record[2] == null ? null : Integer.parseInt(record[2].toString()))
                    .setAbsenceManHour(record[3] == null ? null : Double.parseDouble(record[3].toString()))
                    .setPresenceManHour(record[4] == null ? null : Double.parseDouble(record[4].toString()))
                    .setUnknownManHour(record[5] == null ? null : Double.parseDouble(record[5].toString()))
                    .setPersonnelCount(record[6] == null ? null : Integer.parseInt(record[6].toString()));

            if (omorCode != null) {
                dto.setGhesmatCode(record[7] == null ? null : record[7].toString());
                dto.setGhesmatTitle(record[8] == null ? null : record[8].toString());
            } else if (moavenatCode != null) {
                dto.setOmorCode(record[7] == null ? null : record[7].toString());
                dto.setOmorTitle(record[8] == null ? null : record[8].toString());
            } else if (mojtameCode != null) {
                dto.setMoavenatCode(record[7] == null ? null : record[7].toString());
                dto.setMoavenatTitle(record[8] == null ? null : record[8].toString());
            } else {
                dto.setMojtameCode(record[7] == null ? null : record[7].toString());
                dto.setMojtameTitle(record[8] == null ? null : record[8].toString());
            }

            list.add(dto);
        }
        return list;
    }

    private void appendGroupQuery(StringBuffer script, String mojtameCode, String moavenatCode, String omorCode, String prfx) {
        if (omorCode != null) {
            script.append(" ").append(prfx).append("C_GHESMAT_CODE,").append(prfx).append("C_GHESMAT_TITLE ");
        } else if (moavenatCode != null) {
            script.append(" ").append(prfx).append("C_OMOR_CODE,").append(prfx).append("C_OMOR_TITLE ");
        } else if (mojtameCode != null) {
            script.append(" ").append(prfx).append("C_MOAVENAT_CODE,").append(prfx).append("C_MOAVENAT_TITLE ");
        } else {
            script.append(" ").append(prfx).append("C_MOJTAME_CODE,").append(prfx).append("C_MOJTAME_TITLE ");
        }
    }

    private void appendGroupQueryCode(StringBuffer script, String mojtameCode, String moavenatCode, String omorCode) {
        if (omorCode != null) {
            script.append(" C_GHESMAT_CODE ");
        } else if (moavenatCode != null) {
            script.append(" C_OMOR_CODE ");
        } else if (mojtameCode != null) {
            script.append(" C_MOAVENAT_CODE");
        } else {
            script.append(" C_MOJTAME_CODE");
        }
    }

    @Override
    public List<ClassFeatures> getReportForMultipleDepartment(String startDate, String endDate, ReportFor reportFor, Long depId, GroupBy groupBy) {
        StringBuffer script = new StringBuffer("SELECT CASE ");
        script.append("WHEN AL.PRESENCE + AL.ABSENCE = 0 THEN NULL" +
                "           ELSE ROUND(100 * AL.PRESENCE / (AL.PRESENCE + AL.ABSENCE), 2) END AS PARTICIPATIONPERCENT," +
                "       CASE" +
                "           WHEN AL.CNT = 0 THEN NULL" +
                "           ELSE ROUND(AL.PRESENCE / AL.CNT , 2) END AS PRESENCEPERPERSON," +
                "       AL.* " +
                "FROM (SELECT SS.*, PRS_COUNT.CNT,dep.c_title as DEP_TITLE");
        script.append("  FROM  (   SELECT SUM(PRESENCE)      PRESENCE," +
                "                         SUM(ABSENCE)       ABSENCE," +
                "                         SUM(UNKNOWN)       UNKNOWN," +
                "                         SUM(STUDENT_COUNT) STUDENT_COUNT,");
        addGroupByFeatureClause(groupBy, script);
        script.append(",");
        addReportForClause(reportFor, script, 1, null);
        script.append("                  FROM (SELECT PRESENCE,ABSENCE,UNKNOWN,STUDENT_COUNT,CLSS.C_CODE,CLSS.C_END_DATE,CLSS.C_START_DATE,CLSS.C_STATUS," +
                "                               CLSS.C_TEACHING_TYPE,CRS.C_CODE,CRS.C_TITLE_FA,CRS.E_TECHNICAL_TYPE,CRS.E_RUN_TYPE,CRS.E_THEO_TYPE," +
                "                               CRS.E_LEVEL_TYPE,CLSS.COMPLEX_ID,CLSS.ASSISTANT_ID,CLSS.AFFAIRS_ID" +
                "                        FROM (SELECT *" +
                "                              FROM (SELECT ATT_STATE, F_CLASS_ID, S_HOUR" +
                "                                    FROM (SELECT CASE" +
                "                                                     WHEN (ATT.C_STATE = 1 OR ATT.C_STATE = 2) THEN 'PRESENCE'" +
                "                                                     WHEN (ATT.C_STATE = 3 OR ATT.C_STATE = 4) THEN 'ABSENCE'" +
                "                                                     ELSE 'UNKNOWN' END AS ATT_STATE," +
                "                                                 ATT.F_SESSION," +
                "                                                 ATT.F_STUDENT," +
                "                                                 SESS.F_CLASS_ID," +
                "                                                 SESS.S_HOUR" +
                "                                          FROM TBL_ATTENDANCE ATT" +
                "                                                   INNER JOIN (SELECT (TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR, '[^:]+', 3, 1)) +" +
                "                                                                       60 * TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR, '[^:]+', 1, 1)) -" +
                "                                                                       (TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR, '[^:]+', 3, 1)) +" +
                "                                                                        60 * TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR, '[^:]+', 1, 1)))) /" +
                "                                                                      60 AS S_HOUR,ID,F_CLASS_ID FROM TBL_SESSION " +
                "                                                               WHERE C_SESSION_DATE >= :FROM_DATE" +
                "                                                                 AND C_SESSION_DATE <= :TO_DATE) SESS" +
                "                                                              ON (ATT.F_SESSION = SESS.ID))) PIVOT (SUM(S_HOUR) FOR ATT_STATE IN ('PRESENCE' AS PRESENCE,'ABSENCE' AS ABSENCE,'UNKNOWN' AS UNKNOWN))) SUM_" +
                "                                 INNER JOIN (SELECT PV.C_TITLE AS C_TEACHING_TYPE,CLSS.ID,CLSS.C_CODE,CLSS.C_END_DATE,CLSS.C_START_DATE,CLSS.C_STATUS,CLSS.COMPLEX_ID,CLSS.ASSISTANT_ID,CLSS.AFFAIRS_ID,CLSS.F_COURSE ");
        addReportForClause(reportFor, script, 2, depId);
        script.append(" LEFT JOIN TBL_PARAMETER_VALUE PV ON CLSS.F_TEACHING_METHOD_ID = PV.ID) CLSS" +
                "                                            ON (CLSS.ID = SUM_.F_CLASS_ID)" +
                "                                 LEFT JOIN (SELECT CLASS_ID, COUNT(DISTINCT (STUDENT_ID)) AS STUDENT_COUNT" +
                "                                            FROM TBL_CLASS_STUDENT GROUP BY CLASS_ID) ST_COUNT ON (ST_COUNT.CLASS_ID = CLSS.ID)" +
                "                                 INNER JOIN TBL_COURSE CRS ON (CRS.ID = CLSS.F_COURSE)) GROUP BY ");
        addGroupByFeatureClause(groupBy, script);
        script.append(",");
        addReportForClause(reportFor, script, 3, null);
        script.append(" )SS LEFT JOIN TBL_DEPARTMENT DEP ON DEP.ID = SS.DEP_ID LEFT JOIN (SELECT COUNT(*) AS CNT,");
        addReportForClause(reportFor, script, 4, null);
        script.append("   FROM TBL_PERSONNEL PRS LEFT JOIN TBL_DEPARTMENT DEP ON DEP.ID = PRS.F_DEPARTMENT_ID WHERE PRS.DELETED = 0 GROUP BY ");
        addReportForClause(reportFor, script, 4, null);
        script.append(" ) PRS_COUNT ON DEP.C_CODE = ");
        addReportForClause(reportFor, script, 5, null);

        List<Object[]> records = (List<Object[]>) entityManager.createNativeQuery(script.toString())
                .setParameter("FROM_DATE", startDate)
                .setParameter("TO_DATE", endDate)
                .getResultList();
        List<ClassFeatures> list = new ArrayList<>();

        for (Object[] record : records) {
            ClassFeatures dto = new ClassFeatures();
            dto
                    .setParticipationPercent(record[0] == null ? null : Double.parseDouble(record[0].toString()))
                    .setPresencePerPerson(record[1] == null ? null : Double.parseDouble(record[1].toString()))
                    .setPresenceManHour(record[2] == null ? null : Double.parseDouble(record[2].toString()))
                    .setAbsenceManHour(record[3] == null ? null : Double.parseDouble(record[3].toString()))
                    .setUnknownManHour(record[4] == null ? null : Double.parseDouble(record[4].toString()))
                    .setStudentCount(record[5] == null ? null : Integer.parseInt(record[5].toString()))
                    .setDepId(record[7] == null ? null : Long.parseLong(record[7].toString()))
                    .setPersonnelCount(record[8] == null ? null : Integer.parseInt(record[8].toString()));

            String r7 = (record[6] == null ? null : record[6].toString());
            if (groupBy.equals(GroupBy.CLASS_TEACHING_TYPE))
                dto.setClassTeachingType(r7);
            else if (groupBy.equals(GroupBy.CLASS_STATUS))
                dto.setClassStatus(r7);
            else if (groupBy.equals(GroupBy.COURSE_LEVEL_TYPE)) {
                if (r7 != null)
                    dto.setCourseLevelType(Arrays.stream(ELevelType.values()).filter(eRunType -> eRunType.getId().equals(Integer.parseInt(r7))).findAny().get().getTitleFa());
            } else if (groupBy.equals(GroupBy.COURSE_RUN_TYPE)) {
                if (r7 != null)
                    dto.setCourseRunType(Arrays.stream(ERunType.values()).filter(eRunType -> eRunType.getId().equals(Integer.parseInt(r7))).findAny().get().getTitleFa());
            } else if (groupBy.equals(GroupBy.COURSE_TECHNICAL_TYPE)) {
                if (r7 != null)
                    dto.setCourseTechnicalType(Arrays.stream(ETechnicalType.values()).filter(eRunType -> eRunType.getId().equals(Integer.parseInt(r7))).findAny().get().getTitleFa());
            } else if (groupBy.equals(GroupBy.COURSE_THEO_TYPE)) {
                if (r7 != null)
                    dto.setCourseTheoType(Arrays.stream(ETheoType.values()).filter(eRunType -> eRunType.getId().equals(Integer.parseInt(r7))).findAny().get().getTitleFa());
            }
            if (record[9] != null) {
                if (reportFor.equals(ReportFor.COMPLEX))
                    dto.setMojtameTitle(record[9].toString());
                else if (reportFor.equals(ReportFor.ASSISTANT))
                    dto.setMoavenatTitle(record[9].toString());
                else if (reportFor.equals(ReportFor.AFFAIR))
                    dto.setOmorTitle(record[9].toString());
            }
            list.add(dto);
        }
        return list;
    }

    @Override
    public List<ClassSumByStatus> getSumReportByClassStatus(String startDate, String endDate, List<String> mojtameCodes, List<String> moavenatCodes, List<String> omorCodes) {
        StringBuffer script = new StringBuffer("SELECT ");
        script.append(" CASE WHEN AL.presence + AL.absence = 0 THEN NULL");
        script.append("     ELSE ROUND((100*AL.presence /(AL.presence + AL.absence)) ,2)END AS participationPercent,");
        script.append(" CASE WHEN AL.count_prs = 0 THEN NULL");
        script.append(" WHEN AL.count_prs is null THEN NULL");
        script.append(" ELSE ROUND(AL.presence / AL.count_prs, 2) END AS presencePerPerson");
        script.append(",AL.*,CAT.C_TITLE_FA,");
        script.append(" ROUND((RATIO_TO_REPORT(AL.PRESENCE) OVER())*100,2) AS RATIO_");
        script.append("       FROM (SELECT");
        script.append("       SUM(COUNT_) COUNT_PRS,");
        script.append("       SUM(PRESENCE) PRESENCE,");
        script.append("       SUM(ABSENCE) ABSENCE,");
        script.append("       SUM(UNKNOWN) UNKNOWN,");
        script.append("       SUM(STUDENT_COUNT) STUDENT_COUNT,");
        script.append("       SUM(PLANNING) PLANNING,");
        script.append("       SUM(IN_PROGRESS) IN_PROGRESS,");
        script.append("       SUM(FINISHED) FINISHED,");
        script.append("       SUM(CANCELED) CANCELED,");
        script.append("       SUM(LOCKED_) LOCKED_,");
        script.append("       CATEGORY_ID");
        script.append("       FROM (");
        script.append("SELECT   PRESENCE,");
        script.append("         ABSENCE,");
        script.append("         UNKNOWN,");
        script.append("         STUDENT_COUNT,");
        script.append("         CLSS.C_CODE,");
        script.append("         CLSS.C_END_DATE,");
        script.append("         CLSS.C_START_DATE,");
        script.append("         CLSS.C_TEACHING_TYPE,");
        script.append("         CRS.CATEGORY_ID,");
        script.append("         DPRT.C_TITLE,");
        script.append("         DPRT.C_MOJTAME_CODE,");
        script.append("         DPRT.C_MOJTAME_TITLE,");
        script.append("         DPRT.C_OMOR_CODE,");
        script.append("         DPRT.C_OMOR_TITLE,");
        script.append("         DPRT.C_MOAVENAT_CODE,");
        script.append("         DPRT.C_MOAVENAT_TITLE,");
        script.append("         DPRT.C_GHESMAT_CODE,");
        script.append("         DPRT.C_GHESMAT_TITLE,");
        script.append("         NVL(PRS.COUNT_,0) COUNT_, PLANNING,IN_PROGRESS, FINISHED,CANCELED,LOCKED_");
        script.append("         FROM(SELECT * FROM (");
        script.append("SELECT ATT_STATE, F_CLASS_ID,S_HOUR FROM (");
        script.append("                  SELECT CASE WHEN (ATT.C_STATE = 1 OR ATT.C_STATE = 2) THEN 'PRESENCE'");
        script.append("                          WHEN (ATT.C_STATE = 3 OR ATT.C_STATE = 4) THEN 'ABSENCE' ELSE 'UNKNOWN' END AS ATT_STATE , ATT.F_SESSION, ATT.F_STUDENT, SESS.F_CLASS_ID, SESS.S_HOUR ");
        script.append("                          FROM TBL_ATTENDANCE ATT INNER JOIN (");
        script.append("SELECT ");
        script.append("(TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR ,'[^:]+',3,1))+60*TO_NUMBER(REGEXP_SUBSTR(C_SESSION_END_HOUR ,'[^:]+',1,1))");
        script.append("-");
        script.append("(TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR ,'[^:]+',3,1))+60*TO_NUMBER(REGEXP_SUBSTR(C_SESSION_START_HOUR ,'[^:]+',1,1))))/60 AS S_HOUR,");
        script.append("ID ,F_CLASS_ID  FROM TBL_SESSION WHERE ");
        script.append("                          C_SESSION_DATE >= :FROM_DATE  ");
        script.append("                          AND C_SESSION_DATE <= :TO_DATE ");
        script.append("                          )SESS ON(ATT.F_SESSION = SESS.ID)                          ");
        script.append("      ) )PIVOT(SUM (S_HOUR) FOR ATT_STATE IN('PRESENCE' AS PRESENCE,'ABSENCE' AS ABSENCE,'UNKNOWN' AS UNKNOWN))) SUM_");
        script.append("       INNER JOIN (SELECT * FROM (SELECT PV.C_TITLE AS C_TEACHING_TYPE, CLSS.ID, CLSS.C_CODE, CLSS.C_END_DATE, CLSS.C_START_DATE, CLSS.C_STATUS, CLSS.F_PLANNER, CLSS.F_COURSE FROM TBL_CLASS CLSS LEFT JOIN TBL_PARAMETER_VALUE PV ON CLSS.F_TEACHING_METHOD_ID = PV.ID) PIVOT(COUNT(C_STATUS) FOR C_STATUS IN ( 1 AS PLANNING, 2 AS IN_PROGRESS, 3 AS FINISHED,4 AS CANCELED ,5 AS LOCKED_)))CLSS ON (CLSS.ID = SUM_.F_CLASS_ID)");
        script.append("                          LEFT JOIN (SELECT CLASS_ID , COUNT(DISTINCT(STUDENT_ID)) AS STUDENT_COUNT FROM TBL_CLASS_STUDENT GROUP BY CLASS_ID) ST_COUNT ON(ST_COUNT.CLASS_ID = CLSS.ID)");
        script.append("                          INNER JOIN TBL_COURSE CRS ON(CRS.ID = CLSS.F_COURSE)");
        script.append("                          LEFT JOIN TBL_PERSONNEL personnel ON (personnel.ID = CLSS.F_PLANNER) ");
        script.append("                          INNER JOIN (");
        script.append("                          SELECT * FROM TBL_DEPARTMENT WHERE ");
        if (omorCodes != null) {
            script.append(" C_OMOR_CODE IN (").append(omorCodes.stream().collect(Collectors.joining(","))).append(")");
        } else if (moavenatCodes != null) {
            script.append(" C_MOAVENAT_CODE IN (").append(moavenatCodes.stream().collect(Collectors.joining(","))).append(")");
        } else if (mojtameCodes != null) {
            script.append(" C_MOJTAME_CODE IN (").append(mojtameCodes.stream().collect(Collectors.joining(","))).append(")");
        } else {
            script.append(" 1=1");
        }
        script.append("                          )DPRT ON (DPRT.ID = personnel.F_DEPARTMENT_ID) ");
        script.append("                          LEFT JOIN (SELECT COUNT(*) COUNT_, F_DEPARTMENT_ID FROM TBL_PERSONNEL WHERE DELETED = 0 GROUP BY F_DEPARTMENT_ID) PRS ON DPRT.ID = PRS.F_DEPARTMENT_ID");
        script.append("              )GROUP BY CATEGORY_ID");
        script.append(" ) AL LEFT JOIN TBL_CATEGORY CAT ON (CAT.ID = AL.CATEGORY_ID)");
        List<Object[]> records = (List<Object[]>) entityManager.createNativeQuery(script.toString())
                .setParameter("FROM_DATE", startDate)
                .setParameter("TO_DATE", endDate)
                .getResultList();
        List<ClassSumByStatus> list = new ArrayList<>();

        for (Object[] record : records) {
            ClassSumByStatus dto = new ClassSumByStatus();
            dto
                    .setParticipationPercent(record[0] == null ? null : Double.parseDouble(record[0].toString()))
                    .setPresencePerPerson(record[1] == null ? null : Double.parseDouble(record[1].toString()))
                    .setPersonnelCount(record[2] == null ? null : Integer.parseInt(record[2].toString()))
                    .setPresenceManHour(record[3] == null ? null : Double.parseDouble(record[3].toString()))
                    .setAbsenceManHour(record[4] == null ? null : Double.parseDouble(record[4].toString()))
                    .setUnknownManHour(record[5] == null ? null : Double.parseDouble(record[5].toString()))
                    .setStudentCount(record[6] == null ? null : Integer.parseInt(record[6].toString()));
            dto.setPlanningCount(record[7] == null ? null : Integer.parseInt(record[7].toString()));
            dto.setInProgressCount(record[8] == null ? null : Integer.parseInt(record[8].toString()));
            dto.setFinishedCount(record[9] == null ? null : Integer.parseInt(record[9].toString()));
            dto.setCanceledCount(record[10] == null ? null : Integer.parseInt(record[10].toString()));
            dto.setLockedCount(record[11] == null ? null : Integer.parseInt(record[11].toString()));
            dto.setCategoryId(record[12] == null ? null : Long.parseLong(record[12].toString()));
            dto.setCategory(record[13].toString());
            dto.setProvidedTaughtPercent(Double.parseDouble(record[14].toString()));
            list.add(dto);
        }
        return list;
    }

    @Override
    public List<ClassSumByStatus> getSummeryGroupByCategory(String startDate, String endDate, List<String> mojtameCodes, List<String> moavenatCodes, List<String> omorCodes) {
        StringBuffer script = new StringBuffer();
        script.append("SELECT C_TITLE_FA AS CATEGORY, SUM(PLANNING) AS PLANNING, SUM(IN_PROGRESS) AS IN_PROGRESS, SUM(FINISHED) AS FINISHED, SUM(CANCELED) AS CANCELED, SUM(LOCKED_) AS LOCKED");
        script.append(" FROM(SELECT CAT.C_TITLE_FA, CLASS_.PLANNING, CLASS_.IN_PROGRESS, CLASS_.FINISHED, CLASS_.CANCELED, CLASS_.LOCKED_");
        script.append(" FROM(SELECT * FROM (");
        script.append(" SELECT C_STATUS, F_COURSE, C_START_DATE, C_END_DATE FROM (");
        script.append(" SELECT CLZZ.C_STATUS, CLZZ.F_COURSE, CLZZ.C_START_DATE, CLZZ.C_END_DATE");
        script.append(" FROM TBL_CLASS CLZZ ");
        script.append(" LEFT JOIN TBL_PERSONNEL personnel on (personnel.ID = CLZZ.F_PLANNER)  ");
        script.append(" LEFT JOIN TBL_DEPARTMENT DPRT ON (DPRT.ID = personnel.F_DEPARTMENT_ID) WHERE ");
        if (omorCodes != null) {
            script.append(" C_OMOR_CODE IN (").append(omorCodes.stream().collect(Collectors.joining(","))).append(")");
        } else if (moavenatCodes != null) {
            script.append(" C_MOAVENAT_CODE IN (").append(moavenatCodes.stream().collect(Collectors.joining(","))).append(")");
        } else if (mojtameCodes != null) {
            script.append(" C_MOJTAME_CODE IN (").append(mojtameCodes.stream().collect(Collectors.joining(","))).append(")");
        } else {
            script.append(" 1=1");
        }
        script.append(") WHERE C_START_DATE <= :TO_DATE AND C_END_DATE <= :TO_DATE AND C_END_DATE >= :FROM_DATE AND C_START_DATE >= :FROM_DATE) PIVOT (COUNT (C_STATUS) FOR C_STATUS IN (1 AS PLANNING, 2 AS IN_PROGRESS, 3 AS FINISHED, 4 AS CANCELED, 5 AS LOCKED_))) CLASS_");
        script.append(" LEFT JOIN TBL_COURSE COURSE ON COURSE.ID = CLASS_.F_COURSE");
        script.append(" LEFT JOIN TBL_CATEGORY CAT ON CAT.ID = COURSE.CATEGORY_ID)GROUP BY C_TITLE_FA");
        List<Object[]> records = (List<Object[]>) entityManager.createNativeQuery(script.toString())
                .setParameter("FROM_DATE", startDate)
                .setParameter("TO_DATE", endDate)
                .getResultList();
        List<ClassSumByStatus> list = new ArrayList<>();

        for (Object[] record : records) {
            ClassSumByStatus dto = new ClassSumByStatus();
            dto.setCategory(record[0].toString());
            dto.setPlanningCount(record[1] == null ? null : Integer.parseInt(record[1].toString()));
            dto.setInProgressCount(record[2] == null ? null : Integer.parseInt(record[2].toString()));
            dto.setFinishedCount(record[3] == null ? null : Integer.parseInt(record[3].toString()));
            dto.setCanceledCount(record[4] == null ? null : Integer.parseInt(record[4].toString()));
            dto.setLockedCount(record[5] == null ? null : Integer.parseInt(record[5].toString()));
            list.add(dto);
        }
        return list;
    }

    private void addReportForClause(ReportFor reportFor, StringBuffer script, int index, Long dep_Id) {
        if (reportFor.equals(ReportFor.COMPLEX)) {

            if (index == 1)
                script.append("COMPLEX_ID AS DEP_ID");
            else if (index == 2)
                script.append(" FROM TBL_CLASS CLSS ");
            else if (index == 3)
                script.append(" COMPLEX_ID ");
            else if (index == 4)
                script.append("DEP.C_MOJTAME_CODE, DEP.C_MOJTAME_TITLE");
            else
                script.append("PRS_COUNT.C_MOJTAME_CODE) AL");

        } else if (reportFor.equals(ReportFor.ASSISTANT)) {

            if (index == 1)
                script.append("ASSISTANT_ID AS DEP_ID");
            else if (index == 2) {
                if (dep_Id == null)
                    script.append(" FROM (SELECT * FROM TBL_CLASS WHERE COMPLEX_ID IS NULL )CLSS'");
                else
                    script.append(" FROM (SELECT * FROM TBL_CLASS WHERE COMPLEX_ID = '").append(dep_Id).append("')CLSS ");
            } else if (index == 3)
                script.append(" ASSISTANT_ID ");
            else if (index == 4)
                script.append("DEP.C_MOAVENAT_CODE, DEP.C_MOAVENAT_TITLE");
            else
                script.append("PRS_COUNT.C_MOAVENAT_CODE) AL");
        } else if (reportFor.equals(ReportFor.AFFAIR)) {

            if (index == 1)
                script.append("AFFAIRS_ID AS DEP_ID");
            else if (index == 2){
                if (dep_Id == null)
                    script.append(" FROM (SELECT * FROM TBL_CLASS WHERE ASSISTANT_ID IS NULL)CLSS");
                else
                    script.append(" FROM (SELECT * FROM TBL_CLASS WHERE ASSISTANT_ID = '").append(dep_Id).append("')CLSS ");
            }
            else if (index == 3)
                script.append(" AFFAIRS_ID ");
            else if (index == 4)
                script.append("DEP.C_OMOR_CODE, DEP.C_OMOR_TITLE");
            else
                script.append("PRS_COUNT.C_OMOR_CODE) AL");

        } else throw new RuntimeException();
    }

    private void addGroupByFeatureClause(GroupBy groupBy, StringBuffer script) {
        if (groupBy.equals(GroupBy.CLASS_TEACHING_TYPE))
            script.append(" C_TEACHING_TYPE ");
        if (groupBy.equals(GroupBy.CLASS_STATUS))
            script.append(" C_STATUS ");
        if (groupBy.equals(GroupBy.COURSE_LEVEL_TYPE))
            script.append(" E_LEVEL_TYPE ");
        if (groupBy.equals(GroupBy.COURSE_RUN_TYPE))
            script.append(" E_RUN_TYPE ");
        if (groupBy.equals(GroupBy.COURSE_TECHNICAL_TYPE))
            script.append(" E_TECHNICAL_TYPE ");
        if (groupBy.equals(GroupBy.COURSE_THEO_TYPE))
            script.append(" E_THEO_TYPE ");
    }

}
