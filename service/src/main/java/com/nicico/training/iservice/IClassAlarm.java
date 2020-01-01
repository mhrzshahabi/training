package com.nicico.training.iservice;

import com.nicico.training.dto.ClassAlarmDTO;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface IClassAlarm {

    List<ClassAlarmDTO> list(Long class_id, HttpServletResponse response) throws IOException;
}
