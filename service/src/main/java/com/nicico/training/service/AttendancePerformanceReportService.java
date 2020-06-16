package com.nicico.training.service;

import com.nicico.training.dto.AttendancePerformanceReportDTO;
import com.nicico.training.iservice.IAttendancePerformanceReportService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AttendancePerformanceReportService implements IAttendancePerformanceReportService {

    @Autowired
    protected EntityManager entityManager;
    private final ModelMapper modelMapper;


    @Override
    public List<AttendancePerformanceReportDTO> classPerformanceList(String reportParameter) {
        return null;
    }
}
