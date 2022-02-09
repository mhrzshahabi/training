package com.nicico.training.iservice;

import com.nicico.training.dto.ClassAlarmDTO;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface IClassAlarmService {

    List<String> hasAlarm(Long class_id, HttpServletResponse response) throws IOException;

    List<ClassAlarmDTO> list(Long class_id, HttpServletResponse response) throws IOException;

    String checkAlarmsForEndingClass(Long class_id, String endDate, HttpServletResponse response) throws IOException;

    Integer deleteAllAlarmsBySessionIds(List<Long> sessionIds);
}
