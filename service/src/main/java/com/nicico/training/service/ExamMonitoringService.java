package com.nicico.training.service;

import com.nicico.training.dto.StudentDTO;
import com.nicico.training.iservice.IExamMonitoringService;
import com.nicico.training.iservice.IStudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import response.exam.ElsExamStudentsStateDto;
import java.util.List;

@RequiredArgsConstructor
@Service
public class ExamMonitoringService implements IExamMonitoringService {

    private final IStudentService studentService;

    @Override
    public List<ElsExamStudentsStateDto> getExamMonitoringData(List<ElsExamStudentsStateDto> studentsList) {
        studentsList.forEach(student -> {
            StudentDTO.PreparationInfo studentPreparationInfo = studentService.getStudentPreparationInfoByNationalCode(student.getNationalCode());
            if(studentPreparationInfo != null)
                student.setHasPreparationTest(true);
        });
        return studentsList;
    }
}
