package com.nicico.training.iservice;

import com.nicico.training.dto.unjustifiedAbsenceDTO;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface IunjustifiedAbsenceService {


    List<unjustifiedAbsenceDTO.printScoreInfo> print(String startDate, String endDate) throws Exception;
}
