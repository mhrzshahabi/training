package com.nicico.training.repository;

import com.nicico.training.model.Competence;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import java.util.Optional;

public interface CompetenceDAO extends BaseDAO<Competence, Long> {
    boolean existsByTitle(String title);

    boolean existsByTitleAndIdIsNot(String title, Long id);

    Optional<Competence> findByProcessInstanceId(String processInstanceId);

    Optional<Competence> findTopByCodeStartsWithOrderByCodeDesc(String code);

    @Modifying
    @Query(value = " update TBL_COMPETENCE set N_WORK_FLOW_CODE = :code where ID = :competenceId ", nativeQuery = true)
    public int updateCompetenceState(Long competenceId, Integer code);

    @Query(value = "select NVL(MAX(CAST(SUBSTR(c_code,7) AS INTEGER))+1, 0) from TBL_COMPETENCE where c_code like :code", nativeQuery = true)
    long getMaxCode(String code);
}
