/**
 * Author:    Mehran Golrokhi
 * Created:    1399.04.02
 * Description:  send sms
 */
package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.URL;
import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/sendMessage")
public class SendMessageRestController {

    private final SendMessageService sendMessageService;

    @Loggable
    @PostMapping(value = "/sendSMS")
    public ResponseEntity sendSMS(final HttpServletRequest request, @RequestBody String data) throws IOException {

        return sendMessageService.sendMessage(request,data);
    }




}
