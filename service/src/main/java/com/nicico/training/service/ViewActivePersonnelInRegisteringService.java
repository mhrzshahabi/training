package com.nicico.training.service;

import com.nicico.training.dto.ViewActivePersonnelInRegisteringDTO;
import com.nicico.training.model.ViewActivePersonnelInRegistering;
import com.nicico.training.repository.ViewActivePersonnelInRegisteringDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewActivePersonnelInRegisteringService extends BaseService<
        ViewActivePersonnelInRegistering,
        Long,
        ViewActivePersonnelInRegisteringDTO.Info,
        ViewActivePersonnelInRegisteringDTO.Info,
        ViewActivePersonnelInRegisteringDTO.Info,
        ViewActivePersonnelInRegisteringDTO.Info,
        ViewActivePersonnelInRegisteringDAO> {

        @Autowired
        ViewActivePersonnelInRegisteringService(ViewActivePersonnelInRegisteringDAO ViewActivePersonnelInRegisteringDAO) {
                super(new ViewActivePersonnelInRegistering(), ViewActivePersonnelInRegisteringDAO);
        }
}