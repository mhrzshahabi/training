package com.nicico.training.service;

import com.nicico.training.dto.UnfinishedClassesReportDTO;
import com.nicico.training.iservice.IUnfinishedClassesReportService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UnfinishedClassesReportService implements IUnfinishedClassesReportService {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;

    @Override
    @Transactional
    public List<UnfinishedClassesReportDTO> UnfinishedClassesList() {

        String nationalCode ="";

        List<?> unfinishedClasses = null;
        List<UnfinishedClassesReportDTO> unfinishedClassesList = null;

        String reportScript = " SELECT " +
                "    c.id, c.c_code AS class_code, c.f_course, co.c_code AS course_code, co.c_title_fa, c.n_h_duration AS duration, c.c_start_date, c.c_end_date, " +
                "    MIN(s.c_session_date || ' - از ' || s.c_session_start_hour || ' تا ' || s.c_session_end_hour || ' (' || s.c_day_name || ')') AS first_session, " +
                "    tbl_institute.c_title_fa AS instituteName, " +
                "    COUNT(s.id) session_count, ( " +
                "        CASE " +
                "            WHEN hs.held_sessions IS NOT NULL THEN hs.held_sessions " +
                "            ELSE 0 " +
                "        END " +
                "    ) AS held_sessions, " +
                "    p.c_first_name_fa || ' ' || p.c_last_name_fa AS teacher, cs.student_id, st.national_code, st.first_name, st.last_name " +
                " FROM " +
                "    tbl_class c " +
                "    INNER JOIN tbl_course co ON co.id = c.f_course " +
                "    INNER JOIN tbl_session s ON c.id = s.f_class_id " +
                "    INNER JOIN tbl_institute ON tbl_institute.id = c.f_institute " +
                "    LEFT JOIN ( " +
                "        SELECT " +
                "            se.f_class_id, " +
                "            COUNT(DISTINCT a.f_session) AS held_sessions " +
                "        FROM " +
                "            tbl_attendance a " +
                "            INNER JOIN tbl_session se ON se.id = a.f_session " +
                "        WHERE " +
                "            a.c_state <> 0 " +
                "        GROUP BY " +
                "            se.f_class_id " +
                "    ) hs ON c.id = hs.f_class_id " +
                "    INNER JOIN tbl_teacher t ON t.id = c.f_teacher " +
                "    INNER JOIN tbl_personal_info p ON p.id = t.f_personality " +
                "    INNER JOIN tbl_class_student cs ON c.id = cs.class_id " +
                "    INNER JOIN tbl_student st ON st.id = cs.student_id " +
                " WHERE st.national_code = :national_code AND c.c_status <> 3   " +
                " GROUP BY " +
                "    c.id, c.c_code, c.f_course, co.c_code, co.c_title_fa, c.n_h_duration, c.c_start_date, c.c_end_date, tbl_institute.c_title_fa, " +
                "    cs.student_id, hs.held_sessions, p.c_first_name_fa, p.c_last_name_fa, st.national_code, st.first_name, st.last_name ";

        unfinishedClasses = (List<?>) entityManager.createNativeQuery(reportScript).setParameter("national_code", "555").getResultList();

        if (unfinishedClasses != null) {

            unfinishedClassesList = new ArrayList<>(unfinishedClasses.size());

            for (int i = 0; i < unfinishedClasses.size(); i++) {
                unfinishedClassesList.add(new UnfinishedClassesReportDTO());
            }
        }

        return null;
    }
}
