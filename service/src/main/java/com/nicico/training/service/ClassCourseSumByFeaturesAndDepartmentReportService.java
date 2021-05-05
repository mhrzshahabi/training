package com.nicico.training.service;

import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.GroupBy;
import com.nicico.training.iservice.IClassCourseSumByFeaturesAndDepartmentReportService;
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

@Service
@RequiredArgsConstructor
public class ClassCourseSumByFeaturesAndDepartmentReportService implements IClassCourseSumByFeaturesAndDepartmentReportService {

    @Autowired
    private final EntityManager entityManager;


    @Transactional(readOnly = true)
    @Override
    public List<ClassCourseSumByFeaturesAndDepartmentReportDTO> getReport(String startDate,
                                                                          String endDate,
                                                                          String mojtameCode,
                                                                          String moavenatCode,
                                                                          String omorCode,
                                                                          GroupBy groupBy) {
        StringBuffer departmentFilterCode = new StringBuffer();
        StringBuffer script = new StringBuffer("SELECT ");
        script.append(" CASE WHEN AL.presence + AL.absence = 0 THEN NULL");
        script.append("     ELSE (100*AL.presence /(AL.presence + AL.absence)) END AS participationPercent,");
        script.append(" CASE WHEN AL.count_prs = 0 THEN NULL");
        script.append(" ELSE (NVL(AL.count_prs ,(AL.presence / AL.count_prs))) END AS presencePerPerson,");
        script.append("       AL.* FROM (SELECT");
        script.append("       SUM(COUNT_) COUNT_PRS,");
        script.append("       SUM(PRESENCE) PRESENCE,");
        script.append("       SUM(ABSENCE) ABSENCE,");
        script.append("       SUM(UNKNOWN) UNKNOWN,");
        script.append("       SUM(STUDENT_COUNT) STUDENT_COUNT,");
        addGroupByFeatureClause(groupBy, script);
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
        script.append("         DPRT.C_GHESMAT_TITLE,");
        script.append("         NVL(PRS.COUNT_,0) COUNT_");
        script.append("         FROM(SELECT * FROM (");
        script.append("SELECT ATT_STATE, F_CLASS_ID FROM (");
        script.append("                  SELECT CASE WHEN (ATT.C_STATE = 1 OR ATT.C_STATE = 2) THEN 'PRESENCE'");
        script.append("                          WHEN (ATT.C_STATE = 3 OR ATT.C_STATE = 4) THEN 'ABSENCE' ELSE 'UNKNOWN' END AS ATT_STATE , ATT.F_SESSION, ATT.F_STUDENT, SESS.F_CLASS_ID ");
        script.append("                          FROM TBL_ATTENDANCE ATT INNER JOIN (SELECT * FROM TBL_SESSION WHERE ");
        script.append("                          C_SESSION_DATE >= :FROM_DATE  ");
        script.append("                          AND C_SESSION_DATE <= :TO_DATE ");
        script.append("                          )SESS ON(ATT.F_SESSION = SESS.ID)                          ");
        script.append("      ) )PIVOT(COUNT(ATT_STATE) FOR ATT_STATE IN('PRESENCE' AS PRESENCE,'ABSENCE' AS ABSENCE,'UNKNOWN' AS UNKNOWN))) SUM_");
        script.append("                          INNER JOIN TBL_CLASS CLSS ON(CLSS.ID = SUM_.F_CLASS_ID)");
        script.append("                          LEFT JOIN (SELECT CLASS_ID , COUNT(DISTINCT(STUDENT_ID)) AS STUDENT_COUNT FROM TBL_CLASS_STUDENT GROUP BY CLASS_ID) ST_COUNT ON(ST_COUNT.CLASS_ID = CLSS.ID)");
        script.append("                          INNER JOIN TBL_COURSE CRS ON(CRS.ID = CLSS.F_COURSE)");
        script.append("                          INNER JOIN (");
        script.append("                          SELECT * FROM TBL_DEPARTMENT WHERE ");
        script.append(departmentFilterCode);
        script.append("                          )DPRT ON(DPRT.ID = CLSS.F_PLANNER)");
        script.append("                          LEFT JOIN (SELECT COUNT(*) COUNT_, F_DEPARTMENT_ID FROM TBL_PERSONNEL WHERE DELETED = 0 GROUP BY F_DEPARTMENT_ID) PRS ON DPRT.ID = PRS.F_DEPARTMENT_ID");
        script.append("              )GROUP BY ");
        addGroupByFeatureClause(groupBy, script);
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
        script.append(" ) AL");
        List<Object[]> records = (List<Object[]>) entityManager.createNativeQuery(script.toString())
                .setParameter("FROM_DATE", startDate)
                .setParameter("TO_DATE", endDate)
                .getResultList();
        List<ClassCourseSumByFeaturesAndDepartmentReportDTO> list = new ArrayList<>();

        for (Object[] record : records) {
            ClassCourseSumByFeaturesAndDepartmentReportDTO dto = new ClassCourseSumByFeaturesAndDepartmentReportDTO();
            dto
                    .setParticipationPercent(record[0] == null ? null : Double.parseDouble(record[0].toString()))
                    .setPresencePerPerson(record[1] == null ? null : Double.parseDouble(record[1].toString()))
                    .setPersonnelCount(Integer.parseInt(record[2].toString()))
                    .setPresenceManHour(Integer.parseInt(record[3].toString()))
                    .setAbsenceManHour(Integer.parseInt(record[4].toString()))
                    .setUnknownManHour(Integer.parseInt(record[5].toString()))
                    .setStudentCount(Integer.parseInt(record[6].toString()));

            int index = 1;
            if (groupBy.equals(GroupBy.CLASS_TEACHING_TYPE))
                dto.setClassTeachingType(record[7].toString());
            else if (groupBy.equals(GroupBy.CLASS_STATUS))
                dto.setClassStatus(record[7].toString());
            else if (groupBy.equals(GroupBy.COURSE_LEVEL_TYPE)) {
                if (record[7] != null)
                    dto.setCourseLevelType(Arrays.stream(ELevelType.values()).filter(eRunType -> eRunType.getId().equals(Integer.parseInt(record[7].toString()))).findAny().get().getTitleFa());
            } else if (groupBy.equals(GroupBy.COURSE_RUN_TYPE)) {
                if (record[7] != null)
                    dto.setCourseRunType(Arrays.stream(ERunType.values()).filter(eRunType -> eRunType.getId().equals(Integer.parseInt(record[7].toString()))).findAny().get().getTitleFa());
            } else if (groupBy.equals(GroupBy.COURSE_TECHNICAL_TYPE)) {
                if (record[7] != null)
                    dto.setCourseTechnicalType(Arrays.stream(ETechnicalType.values()).filter(eRunType -> eRunType.getId().equals(Integer.parseInt(record[7].toString()))).findAny().get().getTitleFa());
            } else if (groupBy.equals(GroupBy.COURSE_THEO_TYPE)) {
                if (record[7] != null)
                    dto.setCourseTheoType(Arrays.stream(ETheoType.values()).filter(eRunType -> eRunType.getId().equals(Integer.parseInt(record[7].toString()))).findAny().get().getTitleFa());
            } else
                index = 0;

            if (omorCode != null) {
                dto.setGhesmatCode(record[index + 7] == null ? null : record[index + 7].toString());
                dto.setGhesmatTitle(record[index + 8] == null ? null : record[index + 8].toString());
            } else if (moavenatCode != null) {
                dto.setOmorCode(record[index + 7] == null ? null : record[index + 7].toString());
                dto.setOmorTitle(record[index + 8] == null ? null : record[index + 8].toString());
            } else if (mojtameCode != null) {
                dto.setMoavenatCode(record[index + 7] == null ? null : record[index + 7].toString());
                dto.setMoavenatTitle(record[index + 8] == null ? null : record[index + 8].toString());
            } else {
                dto.setMojtameCode(record[index + 7] == null ? null : record[index + 7].toString());
                dto.setMojtameTitle(record[index + 8] == null ? null : record[index + 8].toString());
            }

            list.add(dto);
        }
        return list;
    }

    private void addGroupByFeatureClause(GroupBy groupBy, StringBuffer script) {
        if (groupBy.equals(GroupBy.CLASS_TEACHING_TYPE))
            script.append("       C_TEACHING_TYPE,");
        if (groupBy.equals(GroupBy.CLASS_STATUS))
            script.append("       C_STATUS,");
        if (groupBy.equals(GroupBy.COURSE_LEVEL_TYPE))
            script.append("       E_LEVEL_TYPE,");
        if (groupBy.equals(GroupBy.COURSE_RUN_TYPE))
            script.append("       E_RUN_TYPE,");
        if (groupBy.equals(GroupBy.COURSE_TECHNICAL_TYPE))
            script.append("       E_TECHNICAL_TYPE,");
        if (groupBy.equals(GroupBy.COURSE_THEO_TYPE))
            script.append("       E_THEO_TYPE,");
    }

}
