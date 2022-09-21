package com.nicico.training.iservice;

import com.nicico.training.dto.MessageContactDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface ISendMessageService {

    List<String> syncEnqueue(String pid, Map<String, String> paramValMap, List<String> recipients);

    void scheduling();
    void sendSmsForUsers() throws IOException;

    ResponseEntity sendMessage( @RequestBody String data) throws IOException;

}
