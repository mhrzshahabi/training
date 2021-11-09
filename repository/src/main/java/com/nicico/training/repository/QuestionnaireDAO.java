package com.nicico.training.repository;

import com.nicico.training.model.Questionnaire;
import org.springframework.data.jpa.repository.Query;

public interface QuestionnaireDAO extends BaseDAO<Questionnaire, Long> {

    @Query(value = "select lock_status from tbl_questionnaire where id= :id",nativeQuery = true)
    Integer isLocked(Long id);

    Questionnaire findFirstById(Long questionnarieId);
}
