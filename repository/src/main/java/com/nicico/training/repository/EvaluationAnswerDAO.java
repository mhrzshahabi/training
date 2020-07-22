package com.nicico.training.repository;/* com.nicico.training.repository
@Author:jafari-h
@Date:5/28/2019
@Time:2:37 PM
*/

import com.nicico.training.model.EvaluationAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EvaluationAnswerDAO extends JpaRepository<EvaluationAnswer, Long>, JpaSpecificationExecutor<EvaluationAnswer> {

    List<EvaluationAnswer> findByEvaluationId(Long eId);
}
