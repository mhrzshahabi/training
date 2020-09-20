package com.nicico.training.iservice;

import java.util.List;
import java.util.Map;

public interface ISendMessageService {

    List<String> asyncEnqueue(String pid, Map<String, String> paramValMap, List<String> recipients);

    void scheduling();

}
