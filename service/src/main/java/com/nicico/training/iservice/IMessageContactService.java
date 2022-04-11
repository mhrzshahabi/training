/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */

package com.nicico.training.iservice;

import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface IMessageContactService {
    List<MessageContactDTO.AllMessagesForSend> getAllMessageContactForSend();

    MessageContactDTO.Info create(MessageContactDTO.Create model);

    void delete(Long id);
}
