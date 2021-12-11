package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.ClassStudentHistory;
import com.nicico.training.model.Student;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.AttendanceDAO;
import com.nicico.training.repository.ClassStudentDAO;
import com.nicico.training.repository.ClassStudentHistoryDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import request.exam.ElsExamScore;
import request.exam.ElsStudentScore;
import response.BaseResponse;
import response.PaginationDto;
import response.evaluation.dto.EvalAverageResult;
import response.tclass.dto.ElsClassDto;
import response.tclass.dto.ElsClassListDto;

import java.util.*;
import java.util.function.Function;

import static com.nicico.training.utility.persianDate.MyUtils.*;
import static com.nicico.training.utility.persianDate.PersianDate.getEpochDate;

@Service
@RequiredArgsConstructor
public class ClassStudentHistoryService {

    private final ClassStudentHistoryDAO classStudentHistoryDAO;

    @Transactional
    public void save(ClassStudent classStudent) {
        ClassStudentHistory classStudentHistory=new ClassStudentHistory();
        classStudentHistory.setStudentId(classStudent.getStudentId());
        classStudentHistory.setScore(classStudent.getScore());
        classStudentHistory.setDescriptiveScore(classStudent.getDescriptiveScore());
        classStudentHistory.setScoresStateId(classStudent.getScoresStateId());
        classStudentHistory.setFailureReasonId(classStudent.getFailureReasonId());
        classStudentHistory.setTestScore(classStudent.getTestScore());
        classStudentHistory.setTclassId(classStudent.getTclassId());
        classStudentHistoryDAO.save(classStudentHistory);

    }
    @Transactional
    public void saveList(List<ClassStudent> classStudentList) {

        for (ClassStudent classStudent : classStudentList){
            save(classStudent);
        }

    }


    public List<ClassStudentHistory> getAllHistoryWithClassId(Long classId) {
       return classStudentHistoryDAO.findAllByTclassId(classId);
    }
}
