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

    private final NimadSMSService nimadSMSService;
    private final MessageContactService messageContactService;

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

        List<MessageContactDTO.AllMessagesForSend> masterList = messageContactService.getAllMessageContactForSend();
        Integer cnt = masterList.size();

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

            Map<String, String> paramValMap = new HashMap<>();

            List<MessageParameter> listParameter = messageParameterDAO.findByMessageContactId(masterList.get(i).getMessageContactId());

            for (MessageParameter parameter : listParameter) {
                paramValMap.put(parameter.getName(), parameter.getValue());
            }

            try {
                Long messageId = Long.parseLong(nimadSMSService.syncEnqueue(pid, paramValMap, numbers).get(0));

                MessageContact messageContact = messageContactDAO.findById(masterList.get(i).getMessageContactId()).orElse(null);

                if (messageContact.getCountSent() + 1 >= masterList.get(i).getCountSend()) {
                    messageContactDAO.deleteById(messageContact.getId());
                } else {
                    messageContactDAO.updateAfterSendMessage(messageId, (long) (messageContact.getCountSent() + 1), new Date(), messageContact.getId());
                }
            } catch (Exception ex) {

            }
        }
    }
}
