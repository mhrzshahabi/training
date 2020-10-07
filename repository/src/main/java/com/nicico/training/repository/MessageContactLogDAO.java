/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/10/03
 * Last Modified: 2020/10/03
 */

package com.nicico.training.repository;

import com.nicico.training.model.MessageContact;
import com.nicico.training.model.MessageContactLog;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

public interface MessageContactLogDAO extends BaseDAO<MessageContactLog, Long> {

}
