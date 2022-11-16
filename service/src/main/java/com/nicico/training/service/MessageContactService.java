/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */

package com.nicico.training.service;

import com.nicico.training.dto.MessageContactDTO;
import com.nicico.training.dto.MessageParameterDTO;
import com.nicico.training.iservice.IMessageContactService;
import com.nicico.training.model.MessageContact;
import com.nicico.training.model.MessageParameter;
import com.nicico.training.repository.MessageContactDAO;
import com.nicico.training.repository.MessageParameterDAO;
import com.nicico.training.service.sms.SmsFeignClient;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.SmsDeliveryResponse;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MessageContactService implements IMessageContactService {

    private final MessageContactDAO messageContactDAO;
    private final MessageParameterDAO messageParameterDAO;
    private final ModelMapper modelMapper;
    private final SmsFeignClient smsFeignClient;

    @Override
    public List<MessageContactDTO.AllMessagesForSend> getAllMessageContactForSend() {
        List<Object> list = messageContactDAO.findAllMessagesForSend(LocalDate.now().toString());
        List<MessageContactDTO.AllMessagesForSend> masterList = new ArrayList<>();

        Integer cnt = list.size();

        for (int i = 0; i < cnt; i++) {
            Object[] oList = (Object[]) list.get(i);
            masterList.add(new MessageContactDTO.AllMessagesForSend(Integer.parseInt(oList[0].toString()), Integer.parseInt(oList[1].toString()), oList[2].toString(), Long.parseLong(oList[3].toString()), Long.parseLong(oList[4].toString()), oList[5].toString(), Long.parseLong(oList[6].toString()), oList[7].toString()));
        }

        return masterList;
    }

    @Override
    public List<MessageContact> getAllMessage(Long id) {
        return messageContactDAO.findAllByMessageId(id);
    }

    @Override
    public MessageContactDTO.Info create(MessageContactDTO.Create model) {

        MessageContact messageContact = modelMapper.map(model, MessageContact.class);

        messageContact.setCountSent(0);
        messageContact.setLastSentDate(model.getLastSentDate());
        messageContact.setStatusId((long) 588);
        messageContact.setMessageParameterList(null);

        messageContactDAO.save(messageContact);

        for (MessageParameterDTO.Create messageParameter : model.getMessageParameterList()) {
            MessageParameter oMessageParameter = modelMapper.map(messageParameter, MessageParameter.class);
            oMessageParameter.setMessageContactId(messageContact.getId());

            messageParameterDAO.save(oMessageParameter);
        }

        MessageContactDTO.Info result = modelMapper.map(messageContact, MessageContactDTO.Info.class);
        result.setId(messageContact.getId());

        return result;
    }

    @Override
    @Transactional
    public void delete(Long id) {
        messageContactDAO.deleteByOneId(id);

    }

        @Override
    public List<MessageContactDTO.InfoForSms> getClassSmsHistory(Long classId) {
        List<MessageContact> messages = messageContactDAO.getClassSmsHistory(classId);
            return modelMapper.map(messages, new TypeToken<List<MessageContactDTO.InfoForSms>>() {
            }.getType());
    }

        @Override
    public String getSmsDetail(Long id) {
        Optional<MessageContact> optionalMessage =messageContactDAO.findById(id);

        if (optionalMessage.isPresent()){
            String track=optionalMessage.get().getTrackingNumber();
            SmsDeliveryResponse s=smsFeignClient.delivery(track);
            if (s.getState().equals("delivered")){
                return "پیامک به کاربر تحویل داده شد";
            }else return "پیامک به کاربر تحویل داده نشد";
        }

        return "پیامک به کاربر تحویل داده نشد";

    }

}
