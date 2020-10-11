/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */


package com.nicico.training.iservice;

import com.nicico.training.dto.MessageContactDTO;
import com.nicico.training.dto.MessageDTO;

import java.util.List;

public interface IMessageService {
    MessageDTO.Info create(MessageDTO.Create model);
}
