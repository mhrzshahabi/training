package com.nicico.training.service;

import com.nicico.training.dto.AttendancePerformanceReportDTO;
import com.nicico.training.iservice.IAttendancePerformanceReportService;
import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONObject;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AttendancePerformanceReportService implements IAttendancePerformanceReportService {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;


    @Override
    public List<AttendancePerformanceReportDTO> attendancePerformanceList(String reportParameter) {
        JSONObject jsonObject = new JSONObject(reportParameter);

        String firstStartDate = jsonObject.get("firstStartDate").toString().replace("^","/");
        String secondStartDate = jsonObject.get("secondStartDate").toString().replace("^","/");
        String firstFinishDate = jsonObject.get("firstFinishDate").toString().replace("^","/");
        String secondFinishDate = jsonObject.get("secondFinishDate").toString().replace("^","/");
        String institute = jsonObject.get("institute").toString();
        String category = jsonObject.get("category").toString();
        String subcategory = jsonObject.get("subcategory").toString();
        String term = jsonObject.get("term").toString();
        String course = jsonObject.get("course").toString();

        List<?> CPReportList = null;
        List<AttendancePerformanceReportDTO> attendancePerformanceReportDTO = null;

        String reportScript ="SELECT " +
                "    c_title_fa, " +
                "    CATEGORY_TITLE, " +
                "    f_institute_organizer, " +
                "    category_id, " +
                "    CASE WHEN unknown IS NOT NULL THEN unknown ELSE 0 END as unknown, " +
                "    CASE WHEN present IS NOT NULL THEN present ELSE 0 END as present, " +
                "    CASE WHEN overdue IS NOT NULL THEN overdue ELSE 0 END as overdue, " +
                "    CASE WHEN absence IS NOT NULL THEN absence ELSE 0 END as absence, " +
                "    CASE WHEN unjustified IS NOT NULL THEN unjustified ELSE 0 END as unjustified " +
                " FROM " +
                " (SELECT " +
                "    atp.f_institute_organizer, " +
                "    atp.category_id, " +
                "    atp.subcategory_id, " +
                "    atp.c_title_fa, " +
                "    atp.CATEGORY_TITLE, " +
                "    atp.c_state, " +
                "    SUM(round(to_number(TO_DATE((CASE WHEN SUBSTR(atp.c_session_end_hour,1,2) > 23 THEN '23:59' ELSE atp.c_session_end_hour END),'HH24:MI') - TO_DATE((CASE WHEN SUBSTR(atp.c_session_start_hour,1,2) > 23 THEN '23:59' ELSE atp.c_session_start_hour END),'HH24:MI') ) * 24 * 60)) AS session_time " +
                " FROM " +
                "    VIEW_ATTENDANCE_PERFORMANCE_V2 atp " +
                " WHERE " +
                "    (((CASE WHEN length(:firststartdate) = 10 AND atp.c_start_date >=:firststartdate THEN 1 WHEN length(:firststartdate) != 10 THEN 1 END) IS NOT NULL AND    " +
                "    (CASE WHEN length(:secondstartdate) = 10 AND atp.c_start_date <=:secondstartdate THEN 1 WHEN length(:secondstartdate) != 10 THEN 1 END) IS NOT NULL)  " +
                "    AND " +
                "    ((CASE WHEN length(:firstfinishdate) = 10 AND atp.c_end_date >=:firstfinishdate THEN 1 WHEN length(:firstfinishdate) != 10 THEN 1 END) IS NOT NULL AND " +
                "    (CASE WHEN length(:secondfinishdate) = 10 AND atp.c_end_date <=:secondfinishdate THEN 1 WHEN length(:secondfinishdate) != 10 THEN 1 END)IS NOT NULL)) " +
                "    AND " +
                "    (CASE WHEN :institute = 'همه' THEN 1 WHEN atp.f_institute_organizer =:institute THEN 1 END)IS NOT NULL AND " +
                "    (CASE WHEN :term = 'همه' THEN 1 WHEN atp.f_term =:term THEN 1 END)IS NOT NULL AND " +
                "    (CASE WHEN :course_id = 'همه' THEN 1 WHEN atp.course_id =:course_id THEN 1 END)IS NOT NULL AND " +
                "    (CASE WHEN :category_id = 'همه' THEN 1 WHEN atp.category_id =:category_id THEN 1 END) IS NOT NULL AND " +
                "    (CASE WHEN :subcategory_id = 'همه' THEN 1 WHEN atp.subcategory_id =:subcategory_id THEN 1 END) IS NOT NULL " +
                "    GROUP BY " +
                "    atp.f_institute_organizer, " +
                "    atp.category_id, " +
                "    atp.subcategory_id, " +
                "    atp.c_title_fa, " +
                "    atp.CATEGORY_TITLE, " +
                "    atp.c_state)     " +
                "    PIVOT( " +
                "    SUM(session_time) " +
                "    FOR c_state " +
                "    IN( " +
                "    '0' as unknown, " +
                "    '1' as present, " +
                "    '2' as overdue, " +
                "    '3' as absence, " +
                "    '4' as unjustified " +
                "    )) ORDER BY f_institute_organizer";

        CPReportList = (List<?>) entityManager.createNativeQuery(reportScript)
                .setParameter("firststartdate", firstStartDate)
                .setParameter("secondstartdate", secondStartDate)
                .setParameter("firstfinishdate", firstFinishDate)
                .setParameter("secondfinishdate", secondFinishDate)
                .setParameter("institute", institute)
                .setParameter("category_id", category)
                .setParameter("subcategory_id", subcategory)
                .setParameter("term", term)
                .setParameter("course_id", course)
                .getResultList();

        if (CPReportList != null) {
            attendancePerformanceReportDTO = new ArrayList<>(CPReportList.size());

            for (int i = 0; i < CPReportList.size(); i++) {
                Object[] cpReport = (Object[]) CPReportList.get(i);
                attendancePerformanceReportDTO.add(new AttendancePerformanceReportDTO(
                        cpReport[2] != null ? Long.parseLong(cpReport[2].toString()) : null,
                        cpReport[3] != null ? Long.parseLong(cpReport[3].toString()) : null,
                        cpReport[4] != null ? Long.parseLong(cpReport[4].toString()) : null,
                        cpReport[5] != null ? Long.parseLong(cpReport[5].toString()) : null,
                        cpReport[6] != null ? Long.parseLong(cpReport[6].toString()) : null,
                        cpReport[7] != null ? Long.parseLong(cpReport[7].toString()) : null,
                        cpReport[8] != null ? Long.parseLong(cpReport[8].toString()) : null));

            }
        }

        return (attendancePerformanceReportDTO != null ? modelMapper.map(attendancePerformanceReportDTO, new TypeToken<List<AttendancePerformanceReportDTO>>() {
        }.getType()) : null);
    }
}
