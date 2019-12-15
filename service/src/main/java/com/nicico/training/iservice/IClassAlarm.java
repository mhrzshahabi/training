package com.nicico.training.iservice;

import com.nicico.training.dto.ClassAlarmDTO;

import java.util.List;

public interface IClassAlarm {

    List<ClassAlarmDTO> list(Long class_id);
}
