/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */


package com.nicico.training.iservice;

import com.nicico.training.dto.MessageDTO;
import com.nicico.training.model.Message;

import java.util.Optional;

public interface IMessageService {
    MessageDTO.Info create(MessageDTO.Create model);
    void delete(Long id);
    Optional<Message> get(Long id);

    Message save(Message message);

//    List<MessageDTO.InfoForSms> getClassSmsHistory(Long classId);
//
//    String getSmsDetail(Long id);
}
