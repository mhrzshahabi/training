/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/13
 * Last Modified: 2020/09/13
 */


package com.nicico.training.service;

import com.nicico.training.dto.ViewStudentsInCanceledClassDTO;
import com.nicico.training.model.ViewStudentsInCanceledReportClass;
import com.nicico.training.repository.ViewStudentsInCanceledClassDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewStudentsInCanceledClassReportService extends BaseService<
        ViewStudentsInCanceledReportClass,
        Long,
        ViewStudentsInCanceledClassDTO.Info,
        ViewStudentsInCanceledClassDTO.Info,
        ViewStudentsInCanceledClassDTO.Info,
        ViewStudentsInCanceledClassDTO.Info,
        ViewStudentsInCanceledClassDAO> {

        @Autowired
        ViewStudentsInCanceledClassReportService(ViewStudentsInCanceledClassDAO viewStudentsInCanceledClassDAO) {
                super(new ViewStudentsInCanceledReportClass(), viewStudentsInCanceledClassDAO);
        }
}
