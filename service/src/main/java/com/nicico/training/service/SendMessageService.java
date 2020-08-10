/**
 * Author:    Mehran Golrokhi
 * Created:    1399.04.02
 * Description:  send sms with copper
 */
package com.nicico.training.service;

import com.nicico.copper.core.service.sms.magfa.*;
import com.nicico.training.iservice.ISendMessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.security.SecureRandom;
import java.util.List;


@RequiredArgsConstructor
@Service
public class SendMessageService implements ISendMessageService {

    private final MagfaSMSService magfaSMSService;
    //private static Long messageId = -1L;
    private static SecureRandom secureRandom=new SecureRandom();


    @Override
    public Long asyncEnqueue(List<String> recipientNos, String message) {

        Long messageId= Long.valueOf(secureRandom.nextInt(Integer.MAX_VALUE));

        magfaSMSService.asyncEnqueue(recipientNos, ++messageId,message);

        return messageId;
    }
}
