package com.nicico.training.repository;

import com.nicico.training.model.DynamicQuestion;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DynamicQuestionDAO extends BaseDAO<DynamicQuestion, Long> {
    List<DynamicQuestion> findByQuestionAndTypeId(String question, Long typeId);
}
