/**
 * Author:    Mehran Golrokhi
 * Created:    1399.04.02
 * Description:  send sms with copper
 */
package com.nicico.training.service;

import com.nicico.copper.core.service.sms.magfa.MagfaSMSService;
import com.nicico.training.dto.MessageContactDTO;
import com.nicico.training.iservice.ISendMessageService;
import com.nicico.training.model.MessageContact;
import com.nicico.training.repository.MessageContactDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.util.*;


@RequiredArgsConstructor
@Service
public class SendMessageService implements ISendMessageService {

    private final MagfaSMSService magfaSMSService;
    //private static Long messageId = -1L;
    private static SecureRandom secureRandom = new SecureRandom();

    @Autowired
    protected MessageContactDAO messageContactDAO;

    @Autowired
    protected ModelMapper modelMapper;

    @Override
    public Long asyncEnqueue(List<String> recipientNos, String message) {

        Long messageId = Long.valueOf(secureRandom.nextInt(Integer.MAX_VALUE));

        magfaSMSService.asyncEnqueue(recipientNos, ++messageId, message);

        return messageId;
    }

    @Scheduled(cron = "0 0 9 * * ?", zone = "Asia/Tehran")
    @Override
    public void scheduling() {
        List<Object> list = messageContactDAO.findAllMessagesForSend(LocalDate.now().toString());
        List<MessageContactDTO.AllMessagesForSend> masterList = new ArrayList<>();

        Integer cnt = list.size();

        for (int i = 0; i < cnt; i++) {
            Object[] oList = (Object[]) list.get(i);
            masterList.add(new MessageContactDTO.AllMessagesForSend(Integer.parseInt(oList[0].toString()), Integer.parseInt(oList[1].toString()), oList[2].toString(), oList[3].toString(), oList[4].toString(), Long.parseLong(oList[5].toString())));
        }

        for (int i = 0; i < cnt; i++) {
            List<String> numbers = new ArrayList<>();
            numbers.add(masterList.get(i).getObjectMobile());

            Long messageId = Long.valueOf(secureRandom.nextInt(Integer.MAX_VALUE));

            magfaSMSService.asyncEnqueue(numbers, ++messageId,  masterList.get(i).getContextText());

            MessageContact messageContact = messageContactDAO.findById(masterList.get(i).getMessageContactId()).orElse(null);

            if (messageContact.getCountSent() + 1 >= masterList.get(i).getCountSend()) {
                messageContactDAO.delete(messageContact);
            } else {
                messageContact.setReturnMessageId(messageId);
                messageContact.setCountSent(messageContact.getCountSent() + 1);
                messageContact.setLastSentDate(new Date());

                messageContactDAO.save(messageContact);
            }
        }
    }
}
