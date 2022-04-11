/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */


package com.nicico.training.service;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.MessageContactDTO;
import com.nicico.training.dto.MessageDTO;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.iservice.IMessageParameterService;
import com.nicico.training.iservice.IMessageService;
import com.nicico.training.model.Message;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.repository.MessageDAO;
import com.nicico.training.repository.MessageParameterDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MessageParameterService implements IMessageParameterService {

    private final MessageParameterDAO messageParameterDAO;

    @Transactional
    @Override
    public void delete(Long id) {
        messageParameterDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void deleteParamValueMessage(Long id) {
        messageParameterDAO.deleteParamValueMessage(id);

    }
}
