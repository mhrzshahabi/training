package com.nicico.training.iservice;

import com.nicico.training.dto.unjustifiedAbsenceReportDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IUnjustifiedAbsenceReportService {
    @Transactional
    List<unjustifiedAbsenceReportDTO> print(String startDate, String endDate) throws Exception;
}
