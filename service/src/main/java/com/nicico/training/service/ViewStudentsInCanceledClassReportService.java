/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/13
 * Last Modified: 2020/09/13
 */


package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewStudentsInCanceledClassReportDTO;
import com.nicico.training.iservice.IViewStudentsInCanceledClassReportService;
import com.nicico.training.model.ViewStudentsInCanceledClassReport;
import com.nicico.training.model.compositeKey.ViewStudentsInCanceledClassReportKey;
import com.nicico.training.repository.ViewStudentsInCanceledClassReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.function.Function;

@RequiredArgsConstructor
@Service
public class ViewStudentsInCanceledClassReportService  implements IViewStudentsInCanceledClassReportService {

        private final ViewStudentsInCanceledClassReportDAO viewStudentsInCanceledClassReportDAO;

        @Transactional(readOnly = true)
        @Override
        public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
                return SearchUtil.search(viewStudentsInCanceledClassReportDAO, request, converter);
        }
}
