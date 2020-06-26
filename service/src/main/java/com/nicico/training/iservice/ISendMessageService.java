package com.nicico.training.iservice;

import java.util.List;

public interface ISendMessageService {

    Long asyncEnqueue(List<String> recipientNos,String message);

}
