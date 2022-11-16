/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */

package com.nicico.training.iservice;

import com.nicico.training.dto.MessageContactDTO;
import com.nicico.training.model.MessageContact;

import java.util.List;

public interface IMessageContactService {
    List<MessageContactDTO.AllMessagesForSend> getAllMessageContactForSend();

    List<MessageContact>getAllMessage(Long id);

    MessageContactDTO.Info create(MessageContactDTO.Create model);

    void delete(Long id);
    String getSmsDetail(Long id);
    List<MessageContactDTO.InfoForSms> getClassSmsHistory(Long classId);
}
