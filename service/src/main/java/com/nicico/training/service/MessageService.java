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
import com.nicico.training.iservice.IMessageService;
import com.nicico.training.model.Message;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.repository.MessageDAO;
import com.nicico.training.service.sms.SmsFeignClient;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MessageService implements IMessageService {

    private final MessageDAO messageDAO;
    private final MessageContactService messageContactService;
    private final ParameterService parameterService;
    private final ParameterValueService parameterValueService;
    private final ModelMapper modelMapper;

    @Override
    public MessageDTO.Info create(MessageDTO.Create model) {


        Message message = new Message();
        message.setTclassId(model.getTclassId());
        message.setUserTypeId(model.getUserTypeId());
        message.setCountSend(model.getCountSend());
        message.setInterval(model.getInterval());
        message.setContextHtml(model.getContextHtml());
        message.setContextText(model.getContextText());
        message.setOrginalMessageId(model.getOrginalMessageId());
        message.setPId(model.getPId());

        List<ParameterValue> sentWays = new ArrayList<>();

        TotalResponse<ParameterValueDTO.Info> parameter = parameterService.getByCode("MessageSendWays");

        ParameterValueDTO.Info parameterValue = modelMapper.map(((TotalResponse) parameter).getResponse().getData().stream().filter(p -> ((ParameterValueDTO.Info) p).getCode().equals("sms")).toArray()[0], ParameterValueDTO.Info.class);

        sentWays.add(parameterValueService.getEntityId(parameterValue.getCode()));

        message.setSendWays(sentWays);

        MessageDTO.Info result = modelMapper.map(messageDAO.save(message), MessageDTO.Info.class);
        result.setMessageContactList(new ArrayList<>());

        for (MessageContactDTO.Create messageContact : model.getMessageContactList()) {
            messageContact.setMessageId(message.getId());
            if (model.getOrginalMessageId() != null) {
                messageContact.setLastSentDate(new Date());
            } else {
                messageContact.setLastSentDate(null);
            }
            result.getMessageContactList().add(messageContactService.create(messageContact));
        }

        return result;
    }

    @Override
    @Transactional
    public void delete(Long id) {
        messageDAO.deleteById(id);
    }

    @Override
    public Optional<Message> get(Long id) {
        return messageDAO.findById(id);
    }

    @Override
    public Message save(Message message) {
       return messageDAO.save(message);
    }



}
