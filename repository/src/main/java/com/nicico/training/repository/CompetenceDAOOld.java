/*
ghazanfari_f, 9/7/2019, 10:52 AM
*/
package com.nicico.training.repository;

import com.nicico.training.model.CompetenceOld;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CompetenceDAOOld extends JpaRepository<CompetenceOld, Long>, JpaSpecificationExecutor<CompetenceOld> {

}
