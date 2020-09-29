/**
 * Author:    Mehran Golrokhi
 * Created:    1399.04.02
 * Description:  send sms with copper
 */
package com.nicico.training.service;

import com.nicico.copper.core.service.sms.magfa.MagfaSMSService;
import com.nicico.copper.core.service.sms.nimad.NimadSMSService;
import com.nicico.training.dto.MessageContactDTO;
import com.nicico.training.iservice.ISendMessageService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.util.*;


@RequiredArgsConstructor
@Service
public class SendMessageService implements ISendMessageService {

    //private final MagfaSMSService magfaSMSService;
    private final NimadSMSService nimadSMSService;
    //private static Long messageId = -1L;
    private static SecureRandom secureRandom = new SecureRandom();

    @Autowired
    protected MessageContactDAO messageContactDAO;

    @Autowired
    protected MessageDAO messageDAO;

    @Autowired
    protected MessageParameterDAO messageParameterDAO;

    @Autowired
    protected ClassStudentDAO classStudentDAO;

    @Autowired
    protected TclassDAO tclassDAO;

    @Autowired
    protected ModelMapper modelMapper;

    @Override
    public List<String> asyncEnqueue(String pid, Map<String, String> paramValMap, List<String> recipients) {

        return nimadSMSService.syncEnqueue(pid, paramValMap, recipients);
    }

    @Scheduled(cron = "0 0 9 * * ?", zone = "Asia/Tehran")
    @Transactional
    @Override
    public void scheduling() {

        List<Message> messages = messageDAO.findAll();
        Integer cnt = messages.size();

        try {
            for (int i = 0; i < cnt; i++) {
                if (messages.get(i).getMessageContactList().size() == 0) {
                    messages.get(i).setSendWays(null);
                    messageDAO.save(messages.get(i));

                    messageDAO.deleteById(messages.get(i).getId());
                }
            }
        } catch (Exception ex) {

        }


        List<Object> list = messageContactDAO.findAllMessagesForSend(LocalDate.now().toString());
        List<MessageContactDTO.AllMessagesForSend> masterList = new ArrayList<>();

        cnt = list.size();

        for (int i = 0; i < cnt; i++) {
            Object[] oList = (Object[]) list.get(i);
            masterList.add(new MessageContactDTO.AllMessagesForSend(Integer.parseInt(oList[0].toString()), Integer.parseInt(oList[1].toString()), oList[2].toString(), oList[3].toString(), oList[4].toString(), Long.parseLong(oList[5].toString()), Long.parseLong(oList[6].toString()), oList[7].toString(), Long.parseLong(oList[8].toString())));
        }

        for (int i = 0; i < cnt; i++) {

            String pid = "";

            if (masterList.get(i).getObjectType().equals("ClassStudent")) {
                pid = "ihxdaus47t";

                ClassStudent model = classStudentDAO.findById(masterList.get(i).getObjectId()).orElse(null);

                if (model != null && !model.getEvaluationStatusReaction().equals(1)) {
                    messageContactDAO.deleteById(masterList.get(i).getMessageContactId());
                }
            } else if (masterList.get(i).getObjectType().equals("Teacher")) {
                pid = "er7wvzn4l4";

                Tclass model = tclassDAO.findById(masterList.get(i).getClassId()).orElse(null);

                if (model != null && !model.getEvaluationStatusReactionTeacher().equals(1)) {
                    messageContactDAO.deleteById(masterList.get(i).getMessageContactId());
                }
            }


            List<String> numbers = new ArrayList<>();
            numbers.add(masterList.get(i).getObjectMobile());

            //Long messageId = Long.valueOf(secureRandom.nextInt(Integer.MAX_VALUE));

            Map<String, String> paramValMap = new HashMap<>();

            List<MessageParameter> listParameter = messageParameterDAO.findByMessageContactId(masterList.get(i).getMessageContactId());

            for (MessageParameter parameter :  listParameter) {
                paramValMap.put(parameter.getName(), parameter.getValue());
            }

            Long messageId =Long.parseLong(nimadSMSService.syncEnqueue(pid, paramValMap, numbers).get(0));

            //magfaSMSService.asyncEnqueue(numbers, ++messageId, masterList.get(i).getContextText());

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
