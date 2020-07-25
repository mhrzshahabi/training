/*
ghazanfari_f,
1/14/2020,
1:55 PM
*/
package com.nicico.training.repository;

import com.nicico.training.model.Competence;

import java.util.List;
import java.util.Optional;

public interface CompetenceDAO extends BaseDAO<Competence, Long> {
    boolean existsByTitle(String title);

    boolean existsByTitleAndIdIsNot(String title, Long id);

    Optional<Competence> findTopByCodeStartsWithOrderByCodeDesc(String code);
}
