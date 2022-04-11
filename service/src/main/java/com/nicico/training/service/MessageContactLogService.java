/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */


package com.nicico.training.service;

import com.nicico.training.iservice.IMessageContactLogService;
import com.nicico.training.iservice.IMessageParameterService;
import com.nicico.training.repository.MessageContactLogDAO;
import com.nicico.training.repository.MessageParameterDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class MessageContactLogService implements IMessageContactLogService {

    private final MessageContactLogDAO messageParameterDAO;

    @Transactional
    @Override
    public void delete(Long id) {
        messageParameterDAO.deleteById(id);
    }
}
