package com.nicico.training.iservice;

import com.nicico.training.model.ClassStudentHistory;

import java.util.List;

public interface IClassStudentHistoryService {
    List<ClassStudentHistory> getAllHistoryWithClassId(Long classId);
}
