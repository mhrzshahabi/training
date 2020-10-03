/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */

package com.nicico.training.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.dto.grid.GridResponse;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IMasterDataService;
import com.nicico.training.iservice.IMessageContactService;
import com.nicico.training.repository.MessageContactDAO;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class MessageContactService implements IMessageContactService {

    private final MessageContactDAO messageContactDAO;

    @Override
    public List<MessageContactDTO.AllMessagesForSend> getAllMessageContactForSend() {
        List<Object> list = messageContactDAO.findAllMessagesForSend(LocalDate.now().toString());
        List<MessageContactDTO.AllMessagesForSend> masterList = new ArrayList<>();

        Integer cnt = list.size();

        for (int i = 0; i < cnt; i++) {
            Object[] oList = (Object[]) list.get(i);
            masterList.add(new MessageContactDTO.AllMessagesForSend(Integer.parseInt(oList[0].toString()), Integer.parseInt(oList[1].toString()), oList[2].toString(), Long.parseLong(oList[3].toString()), Long.parseLong(oList[4].toString()), oList[5].toString(), Long.parseLong(oList[6].toString())));
        }

        return  masterList;
    }
}
