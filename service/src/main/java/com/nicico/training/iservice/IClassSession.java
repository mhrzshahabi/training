package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ClassSessionDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.ClassSession;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Set;

public interface IClassSession {

    ClassSessionDTO.Info get(Long id);

    ClassSession getClassSession(Long id);

    List<ClassSessionDTO.Info> list();

    ClassSessionDTO.Info create(ClassSessionDTO.ManualSession request, HttpServletResponse response);

    ClassSessionDTO.Info update(Long id, ClassSessionDTO.Update request, HttpServletResponse response);

    void delete(Long id, HttpServletResponse response);

    void delete(ClassSessionDTO.Delete request);

    SearchDTO.SearchRs<ClassSessionDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<ClassSessionDTO.Info> searchWithCriteria(SearchDTO.SearchRq request, Long classId);

    @Transactional
    List<ClassSessionDTO.Info> getSessionsForDate(Long classId, String date);

    @Transactional
    List<ClassSessionDTO.ClassSessionsDateForOneClass> getDateForOneClass(Long classId);

    void generateSessions(Long classId, TclassDTO.Create autoSessionsRequirement, HttpServletResponse response);

    List<ClassSessionDTO.Info> loadSessions(Long classId);

    @Transactional
    SearchDTO.SearchRs<ClassSessionDTO.WeeklySchedule> searchWeeklyTrainingSchedule(SearchDTO.SearchRq request, String userNationalCode);

    ClassSessionDTO.DeleteStatus deleteSessions(Long classId, @RequestBody List<Long> studentIds);
}
