package com.nicico.training.repository;

import com.nicico.training.model.Message;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface MessageDAO extends BaseDAO<Message, Long> {

}
